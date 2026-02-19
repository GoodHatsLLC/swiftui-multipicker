import SwiftUI

// MARK: - FlowLayout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(in: proposal.width ?? .infinity, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(in: bounds.width, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    private func arrange(in maxWidth: CGFloat, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x - spacing)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}

// MARK: - ChipsMultiPickerStyle

public struct ChipsMultiPickerStyle: MultiPickerStyle {
    public init() {}

    public func makeBody(configuration: MultiPickerStyleConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            configuration.title
                .font(.subheadline)
                .foregroundStyle(.secondary)

            FlowLayout(spacing: 8) {
                ForEach(configuration.options) { option in
                    Button {
                        option.toggle()
                    } label: {
                        option.label
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                              option.isSelected ? AnyShapeStyle(Color.accentColor.gradient) : AnyShapeStyle(.thickMaterial),
                                in: Capsule()
                            )
                            .foregroundStyle(option.isSelected ? .white : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private var chipBackground: Color {
        #if os(macOS)
        Color(nsColor: .controlBackgroundColor)
        #else
        Color(.systemGray5)
        #endif
    }
}

extension MultiPickerStyle where Self == ChipsMultiPickerStyle {
    public static var chips: ChipsMultiPickerStyle { .init() }
}
