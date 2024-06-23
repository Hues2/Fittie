import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    var canScale : Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect((configuration.isPressed && canScale) ? 0.8 : 1)
    }
}
