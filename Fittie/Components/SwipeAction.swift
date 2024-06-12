import SwiftUI

struct SwipeAction<Content : View> : View {
    var isLastCell : Bool = false
    @ViewBuilder var content : Content
    @ActionBuilder var actions : [Action]
    var swipeDirection : SwipeDirection = .trailing
    @State private var showBackgroundColour : Bool = false
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                    
                    actionButtons()
                }
                .padding()
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)                        
        }
    }
    
    // MARK: Action Buttons
    func actionButtons() -> some View {
        HStack(spacing: 8) {
            ForEach(actions) { action in
                Button {
                    action.action()
                } label: {
                    Image(systemName: action.icon)
                        .font(action.iconFont)
                        .foregroundStyle(action.iconTint)
                        .padding()
                        .contentShape(.rect)
                        .background(action.tint)
                        .cornerRadius(Constants.cornerRadius, corners: .allCorners)
                }
                .buttonStyle(.plain)
            }
        }
        .frame(alignment: swipeDirection.alignment)
    }
    
    
    // MARK: Scroll Offset
    private func scrollOffset(_ proxy : GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return (swipeDirection == .trailing) ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}

// MARK: Swipe direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment : Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        }
    }
}

// MARK: Action Model
struct Action : Identifiable {
    private(set) var id: UUID = .init()
    var tint : Color
    var icon : String
    var iconFont : Font = .title3
    var iconTint : Color = .white
    var isEnabled : Bool = true
    var action : () -> Void
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
    
}

#Preview {
    ExerciseCellContentView(set: 1, weight: 22.5, reps: 10) {
        
    }
}
