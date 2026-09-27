import SwiftUI
import UIKit

public final class SearchableHostingController<Content: View>: UIHostingController<Content>, UISearchResultsUpdating {
    private let onSearch: @MainActor (String) -> Void

    public init(rootView: Content, searchPrompt: String, onSearch: @escaping @MainActor (String) -> Void) {
        self.onSearch = onSearch
        super.init(rootView: rootView)

        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchPrompt
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateSearchResults(for searchController: UISearchController) {
        onSearch(searchController.searchBar.text ?? "")
    }
}
