import SwiftUI

extension Image {
    enum Icon {
        static var copy: Image { Image("ic_copy", bundle: .module) }
        static var checkmark: Image { Image("ic_checkmark", bundle: .module) }
        static var errorCircle: Image { Image("ic_error_circle", bundle: .module) }
    }
}
