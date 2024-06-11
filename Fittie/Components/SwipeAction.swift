import SwiftUI

struct SwipeAction<Content : View> : View {
    var isLastCell : Bool = false
    @ViewBuilder var content : Content
    @ActionBuilder var actions : [Action]
    var swipeDirection : SwipeDirection = .trailing
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                    
                    actionButtons()
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .cornerRadius(isLastCell ? Constants.cornerRadius : 0, corners: [.bottomLeft, .bottomRight])
                }
            }
        }
    }
    
    // MARK: Action Buttons
    func actionButtons() -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: swipeDirection.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { action in
                        Button {
                            action.action()
                        } label: {
                            Image(systemName: action.icon)
                                .font(action.iconFont)
                                .foregroundStyle(action.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(action.tint)
                    }
                }
            }
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
