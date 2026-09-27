# Transparent Accounts

An iOS app for browsing Česká spořitelna transparent accounts: search the public list, open an account, and read its transactions and details. Built on the public Transparent Accounts API, with Clean Architecture, SwiftUI screens inside UIKit navigation, and no third-party dependencies.

## Contents

- [Features](#features)
- [Requirements](#requirements)
- [Build & Run](#build--run)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [How a Screen Works](#how-a-screen-works)
- [Key Decisions](#key-decisions)
- [Localization](#localization)
- [Adding a New Screen](#adding-a-new-screen)
- [Testing](#testing)
- [Not in Scope](#not-in-scope)

## Features

**Account list**
- Server-side search by account name or purpose, debounced while typing
- Infinite scroll and pull to refresh
- Card per account: status bar and chip (active / closed), balance with superscript hellers, purpose, domestic account number with a copy button
- Result count in the navigation bar subtitle, with correct Czech plural forms

**Account detail**
- Header with name, status and balance stays pinned; the content below scrolls
- **Transactions** tab: newest first, grouped by month, infinite scroll. Each row shows direction, counterparty, payment message, date, transaction type and amount
- **Info** tab: account number and IBAN with copy buttons, purpose, note, transparency period, last update

**Across the app**
- Skeleton loading, full-screen errors with the API error code and retry, empty and no-results states
- English and Czech
- Light and dark mode; Dynamic Type (transaction rows reflow at accessibility sizes); VoiceOver labels on every custom control
- iOS 26 Liquid Glass navigation bar with large titles; launch screen with brand colour and mark

## Requirements

- Xcode 27
- iOS 26 or later (simulator or device)
- Swift 6 with strict concurrency checking
- No third-party dependencies, no package resolution from the network

## Build & Run

1. Open `csas-demo-task.xcodeproj` in Xcode.
2. Select the **csas-demo-task** scheme and an iOS 26 simulator.
3. Press **Run** (⌘R).

No extra setup is needed: the API key and base URL are already in `Demo/Config.xcconfig`.

To run all tests press ⌘U. The scheme's test plan (`Demo/csas-demo-task.xctestplan`) includes the test bundles of every package.

## Configuration

Settings flow from the xcconfig into the app's Info.plist and are read by `Environment` in Networking:

```
Demo/Config.xcconfig  →  Demo/csas-demo-task-Info.plist  →  Environment.baseURL / Environment.apiKey
```

| Setting    | Value |
|------------|-------|
| `BASE_URL` | `https://webapi.developers.erstegroup.com/api/csas/public/sandbox/v3` |
| `API_KEY`  | sandbox key from the Erste developer portal, sent as the `WEB-API-key` header |

Two xcconfig details that are easy to trip over: `//` starts a comment, so the URL is written as `https:/$()/…`; and quotes become part of the value, so values are unquoted.

**Why the key is committed.** It is a sandbox key for publicly available data, issued for this assignment. Committing it lets the reviewer build and run the project right away. In a production project the xcconfig would be git-ignored and the key injected by CI or fetched from a backend, never shipped in the repository.

The sandbox base URL is used because the key is not authorised for the production endpoint. Switching to production only needs a different `BASE_URL` and key.

## Architecture

Clean Architecture in four local Swift packages plus a thin app target. Dependencies point one way only:

```
Demo (app target)
  └── App
        └── Features
              └── Shared
                    └── Library
```

| Package | Modules | Responsibility |
|---------|---------|----------------|
| `Library` | `Models`, `Pipeline`, `Networking`, `DIContainer`, `Service`, `Localization` | Lowest level. Domain primitives (amount, errors), the repository state pipeline, the API client, the DI base class, the debounce use case and all user-facing strings |
| `Shared` | `SharedExtensions`, `UIComponents`, `UIKitNavigation` | Formatters, the design system (tokens, components, base view models), coordinator and router protocols |
| `Features` | `Account` | The account list and account detail screens |
| `App` | `App` | Composition root: `SceneDelegate`, `AppCoordinator`, `AppContainer` |

Every screen is split into the same five folders:

| Layer | Contains | Knows about |
|-------|----------|-------------|
| **Data** | `Decodable` models, model → entity converters, repository `actor` | Networking, Domain |
| **Domain** | Entities, repository protocols, use cases | nothing below it |
| **Presentation** | View model, content converter (entity → view content), SwiftUI view | Domain, UIComponents |
| **Router / Navigation** | Router protocol for the screen; the coordinator implements it | UIKitNavigation |
| **DI** | `AccountContainer` extensions per layer | everything, to wire it |

Naming follows one rule: a protocol carries the intended name (`AccountListRepository`) and its implementation adds `Imp` (`AccountListRepositoryImp`).

## Project Structure

### Library

```
Library/Sources/
├── Models/
│   ├── ModelsContainer.swift               # Factory for amount conversion
│   ├── Amount/
│   │   ├── Data/Converters/AmountConverter.swift   # (Decimal, currency code?) → Amount; missing currency → CZK
│   │   └── Domain/Entities/
│   │       ├── Amount.swift                # value: Decimal + Currency
│   │       └── Currency.swift              # ISO code, .czk
│   └── AppError/
│       ├── AppErrorContainer.swift         # Factory for error converters
│       ├── Data/Converters/DomainErrorConverter.swift     # APIError / URLError → DomainError
│       ├── Data/Models/APIErrorModel.swift                # {"status":412,"errors":[{"error":"KEY_NOT_FOUND"}]}
│       ├── Domain/Entities/APIError.swift                 # Transport-level errors
│       ├── Domain/Entities/DomainError.swift              # offline, notFound, error(data), cancelled, unknown
│       ├── Presentation/Converters/ErrorViewModelConverter.swift  # DomainError → title, message, API code
│       └── Presentation/Entities/ErrorViewModel.swift
├── Pipeline/
│   ├── Pipeline.swift                      # Pipeline protocol + StatePipeline actor (current value + AsyncStream)
│   └── NetworkRepositoryState.swift        # loading / data / error, getData() throws(DomainError)
├── Networking/
│   ├── NetworkingContainer.swift           # Factory for APIProvider
│   ├── Interface/APIProvider.swift         # APIProvider protocol + APIProviderImp (URLSession, async/await)
│   ├── Models/
│   │   ├── APIEndpoint.swift               # accountList, accountDetail(id), accountTransactions(id)
│   │   ├── APIMethod.swift
│   │   └── APIHelpers.swift                # Parameters, HTTPHeaders, success status range
│   ├── Constants/Environment.swift         # BASE_URL and API_KEY from Info.plist
│   └── Extensions/
│       ├── JSONDecoder+API.swift           # Dates without timezone, read as Europe/Prague
│       └── URLSession+Default.swift        # Timeouts, connection limit, shared URL cache
├── DIContainer/
│   ├── BaseContainer.swift                 # makeSingleton / makeShared (weakly held)
│   └── DependencyInjectionKey.swift
├── Service/
│   ├── AsyncDebounceUseCase.swift          # Cancels the pending action, runs the last one after the interval
│   └── ServiceContainer.swift
└── Localization/
    ├── Localization.swift                  # tr(key, fallback:) over Bundle.module
    ├── Localization+Common.swift           # Status titles, copy, retry
    ├── Localization+AppError.swift
    ├── Localization+AccountList.swift
    ├── Localization+AccountDetail.swift
    └── Resources/Localizable.xcstrings     # The only string catalog in the project (en + cs)
```

### Shared

```
Shared/Sources/
├── SharedExtensions/
│   ├── FormatterContainer.swift            # Factory for all formatters
│   └── Formatting/
│       ├── AmountFormatter.swift           # Decimal → FormattedAmount, Czech notation
│       ├── FormattedAmount.swift           # integer / fraction / currency parts + full text + isNegative
│       ├── AccountNumberFormatter.swift    # "000027-2000709369" + "0800" → "27-2000709369/0800"
│       ├── DateTextFormatter.swift         # Date → text in a DateTextFormat
│       └── DateTextFormat.swift            # dateOnly, dateTime, monthAndYear
├── UIComponents/
│   ├── Tokens/
│   │   ├── Color+Palette.swift             # Color.Palette.* backed by Icons.xcassets (light + dark)
│   │   ├── CGFloat+Layout.swift            # Shared spacing and radius tokens
│   │   └── Image+Icon.swift                # Image.Icon.copy / .checkmark / .errorCircle
│   ├── State/
│   │   ├── BaseViewModel.swift             # @MainActor ObservableObject with published state
│   │   ├── LoadingViewModel.swift          # setLoading / setContent / setError
│   │   ├── ViewModelState.swift            # loading / content / error
│   │   └── ViewModelStateView.swift        # Switches between skeleton, content and ErrorStateView
│   ├── Models/                             # View models of the components
│   │   ├── AccountStatus.swift             # active / closed with title and colours
│   │   ├── TransactionDirection.swift      # incoming / outgoing with icon and colours
│   │   ├── TransactionGroup.swift, TransactionRow.swift
│   │   └── InfoSection.swift, InfoRow.swift
│   ├── Components/
│   │   ├── Account/                        # AccountCardView, AccountHeaderView, their skeletons,
│   │   │                                   # StatusChipView, StatusBarView
│   │   ├── Transaction/                    # TransactionGroupView, TransactionRowView, skeleton, CategoryChipView
│   │   ├── Info/                           # InfoSectionView, InfoRowView
│   │   ├── Common/                         # AmountView, CardSection, CopyButton, ErrorStateView, SeparatorView
│   │   └── Hosting/SearchableHostingController.swift  # UIHostingController with a native UISearchController
│   ├── Modifiers/
│   │   ├── BrandBackground.swift           # Page colour + brand gradient behind the glass bar
│   │   ├── CardShadow.swift                # Two-layer card shadow
│   │   └── View+OnLoad.swift               # onLoadAsync: runs once per view lifetime
│   └── Resources/Icons.xcassets
└── UIKitNavigation/
    ├── Coordinator.swift                   # start()
    ├── NavigationCoordinator.swift         # Coordinator driving a UINavigationController
    └── BaseRouter.swift                    # close(), goBack()
```

### Features

```
Features/Sources/Account/
├── AccountContainer.swift                  # Module container; receives the Library/Shared containers
├── Navigation/AccountCoordinator.swift     # Root flow; implements AccountListRouter
├── AccountList/
│   ├── Data/
│   │   ├── Model/AccountListModel.swift, AccountModel.swift
│   │   ├── Converters/AccountListConverter.swift, AccountConverter.swift
│   │   └── Repositories/AccountListRepositoryImp.swift    # GET /transparentAccounts?page&size&filter
│   ├── Domain/
│   │   ├── Entities/AccountListEntity.swift, AccountEntity.swift
│   │   ├── Repositories/AccountListRepository.swift
│   │   └── UseCases/AccountListUseCase.swift              # download → read pipeline; stops on a repeated page
│   ├── Presentation/
│   │   ├── AccountListViewModel.swift      # Paging cursor, search, one load at a time
│   │   ├── AccountListContentConverter.swift               # Entity → rows, subtitle, no-results
│   │   └── AccountListView.swift
│   ├── Router/AccountListRouter.swift      # accountSelected(id:)
│   └── DI/AccountListContainer+Data.swift, +Domain.swift, +Presentation.swift
└── AccountDetail/
    ├── Data/
    │   ├── Models/AccountDetailModel.swift, TransactionListModel.swift, TransactionModel.swift,
    │   │          TransactionAmountModel.swift, TransactionSenderModel.swift
    │   ├── Converters/AccountDetailConverter.swift, TransactionListConverter.swift, TransactionConverter.swift
    │   └── Repositories/AccountDetailRepositoryImp.swift     # GET /transparentAccounts/{id}
    │                    TransactionListRepositoryImp.swift   # GET /transparentAccounts/{id}/transactions/
    ├── Domain/
    │   ├── Entities/AccountDetailEntity.swift, TransactionListEntity.swift, TransactionEntity.swift,
    │   │            AccountDetailHeader.swift
    │   ├── Repositories/AccountDetailRepository.swift, TransactionListRepository.swift
    │   └── UseCases/AccountDetailUseCase.swift, TransactionListUseCase.swift
    ├── Presentation/
    │   ├── AccountDetailViewModel.swift    # Loads account + first transactions page concurrently, pages transactions
    │   ├── Converters/AccountDetailContentConverter.swift     # Header, info sections, month groups
    │   └── AccountDetailView.swift         # Pinned header, tabs, skeleton
    └── DI/AccountDetailContainer+Data.swift, +Domain.swift, +Presentation.swift
```

### App and Demo

```
App/Sources/App/
├── AppContainer.swift        # Singletons: Networking, Models, AppError, Formatter, Service, Account containers
├── AppCoordinator.swift      # Creates the navigation controller, starts the Account flow
└── SceneDelegate.swift

Demo/
├── AppDelegate.swift         # @main, scene configuration
├── Assets.xcassets           # App assets, launch colour and mark
├── Config.xcconfig           # API_KEY, BASE_URL
├── csas-demo-task-Info.plist # Keys from the xcconfig, UILaunchScreen, CFBundleLocalizations
└── csas-demo-task.xctestplan # All package test bundles
```

## How a Screen Works

### Request flow

```
AccountListView
   │ onLoadAsync / onSearch / onReachedEnd
   ▼
AccountListViewModel ───────────────────────────► AccountListContentConverter ─► Content ─► View
   │ try await getAccounts(page:query:)                 ▲
   ▼                                                    │ AccountListEntity
AccountListUseCase                                      │
   │ 1. await repository.download(page:filter:)         │
   │ 2. repository.observe().getValue().getData() ──────┘
   ▼
AccountListRepositoryImp (actor)
   │ apiProvider.request → AccountListModel → AccountListConverter → entity
   │ StatePipeline.send(.loading → .data(entity) | .error(DomainError))
   ▼
APIProviderImp ─► URLSession ─► Transparent Accounts API
```

- The repository never throws. It publishes the result into its `StatePipeline`, and errors are converted to `DomainError` at this boundary.
- The use case is stateless: it starts the download, then reads the pipeline's current value.
- The view model holds only use cases and converters. It never formats anything; the content converter does.
- The view renders `ViewModelState` through `ViewModelStateView`: skeleton, content or `ErrorStateView`.

### Dependency graph

```
SceneDelegate
  └── AppCoordinator(window, AppContainer)
        └── AppContainer
              ├── NetworkingContainer   (singleton) → APIProviderImp
              ├── ModelsContainer       (singleton) → AmountConverter
              ├── AppErrorContainer     (singleton) → DomainErrorConverter, ErrorViewModelConverter
              ├── FormatterContainer    (singleton) → Amount / AccountNumber / DateText formatters
              ├── ServiceContainer      (singleton) → AsyncDebounceUseCase
              └── AccountContainer      (singleton)
                    ├── repositories    (makeShared: live while a screen holds them)
                    ├── use cases, converters, view models (new per screen)
                    └── AccountCoordinator → implements AccountListRouter
```

Ownership points down; the only reference back is `ViewModel → Router`, and it is `weak`.

## Key Decisions

**Money.** Amounts are decoded as `Decimal`, never `Double`, and a test checks that `1063961.87` survives decoding exactly. Some accounts come without `currency`; they are all domestic ČS accounts (bank code `0800`), so a missing currency is treated as CZK.

**Dates.** The API sends `"2016-08-31T00:00:00"`, with no timezone. `JSONDecoder.makeAPIDecoder()` reads it as Europe/Prague wall-clock time, so models and entities carry `Date`. Presentation formats dates through `DateTextFormatter`: numeric dates always in Czech format, month names in the UI language.

**Account status.** Active while `transparencyTo` is in the future, closed once it has passed. Open-ended accounts use year 3000 in the API, which is simply a future date.

**Pagination.**
- `nextPage` comes from the API, and the view model keeps it as the cursor.
- The content converter receives the content already on screen and appends the new page to it.
- The sandbox answers every page request with page 0. The use cases therefore treat a page that did not move forward as the end of the list; otherwise scrolling would load the same page forever.

**One request at a time.** Refresh and paging share a repository's pipeline. A new load cancels the one in flight, so an older response can never overwrite a newer one.

**Search.**
- Uses the server-side `filter` parameter, which matches name and description.
- Keystrokes go through an injected `AsyncDebounceUseCase` (300 ms), so the view model is tested with a spy instead of real waiting.
- Search goes through a native `UISearchController` in `SearchableHostingController`, because `.searchable` does not reach the UIKit navigation bar from a hosting controller.

**Account detail.** One view model loads the account and the first page of transactions concurrently (`async let`) and builds a single content from both. Paging then appends transactions only.

**Transactions.**
- The account itself is always the `receiver`, so `sender` is the counterparty.
- `sender.name` is the title and `sender.description` is the payment message. Bank fees and interest have neither, so the trimmed transaction type becomes the title.
- The API gives transactions no id, so a row's id is its position in the loaded list, which stays stable while pages are appended.
- Incoming amounts are green; outgoing amounts stay neutral, because red is kept for alarms.

**UI on iOS 26.**
- The native glass navigation bar is used as is. A custom bar background hides the large title, so the brand colour lives in the content as a gradient behind the glass.
- The launch screen is a `UILaunchScreen` with a colour and a vector mark, and no text to localize.

**Concurrency.** Swift 6 strict mode. Repositories and the state pipeline are actors; view models are `@MainActor`; test doubles are actors or `@MainActor` classes, with no `@unchecked Sendable`.

## Localization

All strings live in one catalog, `Library/Sources/Localization/Resources/Localizable.xcstrings`, with English and Czech. Code never uses string literals for UI text. It reads typed keys:

```swift
Localization.AccountList.title                        // "Accounts" / "Účty"
Localization.AccountList.subtitle(count: 120)         // "120 accounts" / "120 účtů"
Localization.Common.copy("IBAN")                      // "Copy IBAN" / "Zkopírovat: IBAN"
```

To add a string:
1. Add a key with `en` and `cs` values to `Localizable.xcstrings`.
2. Add a static property to the matching `Localization+<Area>.swift`, using the English text as the fallback.

The app declares both languages in `CFBundleLocalizations`. The system picks the language from the app bundle, and package bundles follow it. To try Czech: Scheme → Run → Options → App Language → Czech.

## Adding a New Screen

Using the account detail as the template:

1. **Domain**: define the entity, a repository protocol, and a use case with `callAsFunction`.
2. **Data**: add a `Decodable` model (one type per file), a model → entity converter, and a repository `actor` that publishes into a `StatePipeline`. Add the endpoint to `APIEndpoint`.
3. **Presentation**:
   - a `Content` struct;
   - a content converter that takes only formatters;
   - a view model subclassing `LoadingViewModel<Content>`;
   - a SwiftUI view built with `ViewModelStateView` and `onLoadAsync`.
4. **Router**: a protocol with methods named after what happened (`accountSelected(id:)`), implemented by the coordinator in an extension.
5. **DI**: `+Data`, `+Domain` and `+Presentation` extensions of the module container. Repositories use `makeShared`; formatters come from `formatterContainer`.
6. **Strings**: keys in the catalog plus a `Localization+<Screen>.swift`.
7. **Tests**: converters, repository (with `APIProviderFake`), use case, content converter and view model. Add the test target to the test plan if it is new.

## Testing

Swift Testing throughout. Every test follows `test_given…_when…_then…` naming and `// arrange`, `// act`, `// assert` structure, and builds its subject in `makeSUT()`.

Run everything with ⌘U, or from the command line (use any iOS 26 simulator available on your machine):

```bash
xcodebuild test \
  -project csas-demo-task.xcodeproj \
  -scheme csas-demo-task \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

To run one package in isolation, open its `Package.swift` in Xcode and press ⌘U.

| Package | Test target | Covers |
|---------|-------------|--------|
| `Library` | `NetworkingTests` | Request building (query, header, method), 2xx decoding, non-2xx → `APIError`, decoding errors, missing base URL or key. Uses a `URLProtocol` stub, no network |
| | `ModelsTests` | Error mapping to `DomainError` and to the error screen (including the API code), amount conversion and CZK fallback |
| | `PipelineTests` | `StatePipeline` values and streams |
| | `DIContainerTests` | Singleton reuse, shared instances released with their last owner |
| | `ServiceTests` | Debounce runs only the last action |
| | `LocalizationTests` | Keys resolve, plural forms, argument substitution |
| `Shared` | `SharedExtensionsTests` | Czech amount format and its parts, account number format, date formats and time zones |
| `Features` | `AccountTests` | Decoding real API payloads (dates, `Decimal` precision, optional fields, the transaction variants); all converters; repositories through `APIProviderFake`; use cases (including the repeated-page stop); content converters (status, month grouping across pages, row titles); view models (load, error, retry, paging, debounced search, routing); the coordinator |
| `App` | `AppTests` | Module containers are app-wide singletons |

Test doubles live in `Features/Tests/AccountTests/Helpers`:

| Double | Kind | Purpose |
|--------|------|---------|
| `APIProviderFake` | actor | Returns a prepared response or error and records requests |
| `*RepositoryFake` | actor | Publishes a prepared state into a real `StatePipeline` |
| `*UseCaseFake` | actor | Answers calls in order and records arguments |
| `AccountListRouterSpy`, `AsyncDebounceUseCaseSpy` | `@MainActor` class | Record calls; the debounce spy lets a test fire the action itself |
| `*Stubs`, `Date.gmt(…)` | extensions | Test data with defaulted parameters |

## Not in Scope

- Search and sorting inside transactions
- An offline banner with automatic retry (offline is shown as an error state with retry)
- Statements: the API lists file names without URLs, so there is nothing to open
- Snapshot and UI tests
