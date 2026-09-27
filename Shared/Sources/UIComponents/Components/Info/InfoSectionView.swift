import SwiftUI

public struct InfoSectionView: View {
    private let section: InfoSection

    public init(section: InfoSection) {
        self.section = section
    }

    public var body: some View {
        CardSection(
            title: section.title,
            titleFont: .headline,
            items: section.rows,
            separatorInset: .screenMargin
        ) { row in
            InfoRowView(row: row)
        }
    }
}
