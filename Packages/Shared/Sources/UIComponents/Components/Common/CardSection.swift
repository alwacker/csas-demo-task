import SwiftUI

struct CardSection<Item: Identifiable, RowContent: View>: View {
    private let title: String
    private let titleFont: Font
    private let items: [Item]
    private let separatorInset: CGFloat
    private let rowContent: (Item) -> RowContent

    init(
        title: String,
        titleFont: Font,
        items: [Item],
        separatorInset: CGFloat,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.title = title
        self.titleFont = titleFont
        self.items = items
        self.separatorInset = separatorInset
        self.rowContent = rowContent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.titleToCard) {
            Text(title)
                .font(titleFont)
                .foregroundStyle(Color.Palette.textPrimary)
                .padding(.horizontal, Layout.titleInset)
                .accessibilityAddTraits(.isHeader)

            VStack(spacing: .zero) {
                ForEach(items) { item in
                    rowContent(item)

                    if item.id != items.last?.id {
                        SeparatorView()
                            .padding(.leading, separatorInset)
                    }
                }
            }
            .background(Color.Palette.backgroundElevated)
            .clipShape(.rect(cornerRadius: .cardRadius))
            .cardShadow()
        }
    }
}

private enum Layout {
    static let titleToCard: CGFloat = 8
    static let titleInset: CGFloat = 4
}
