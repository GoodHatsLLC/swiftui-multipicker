import SwiftUI

public struct InlineListMultiPickerStyle: MultiPickerStyle {
    public init() {}

    public func makeBody(configuration: MultiPickerStyleConfiguration) -> some View {
        Section {
            ForEach(configuration.options) { option in
                Button {
                    option.toggle()
                } label: {
                    HStack {
                        option.label
                        Spacer()
                        if option.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                                .fontWeight(.semibold)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundStyle(.primary)
            }
        } header: {
            configuration.title
        }
    }
}

extension MultiPickerStyle where Self == InlineListMultiPickerStyle {
    public static var inlineList: InlineListMultiPickerStyle { .init() }
}

// MARK: - Preview

private enum PreviewTopping: String, CaseIterable, Hashable, CustomStringConvertible {
    case pepperoni, mushrooms, onions, peppers
    var description: String { rawValue.capitalized }
}

@available(macOS 14.0, iOS 17.0, *)
private struct InlineListStylePreview: View {
    @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]

    var body: some View {
        Form {
            MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
                .multiPickerStyle(.inlineList)
        }
    }
}

@available(macOS 14.0, iOS 17.0, *)
#Preview("Inline List Style") {
    InlineListStylePreview()
}
