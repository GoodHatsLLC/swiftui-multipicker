import SwiftUI

public struct MenuMultiPickerStyle: MultiPickerStyle {
    public init() {}

    public func makeBody(configuration: MultiPickerStyleConfiguration) -> some View {
        Menu {
            ForEach(configuration.options) { option in
                Toggle(isOn: Binding(
                    get: { option.isSelected },
                    set: { _ in option.toggle() }
                )) {
                    option.label
                }
            }
        } label: {
            configuration.title
        }
    }
}

extension MultiPickerStyle where Self == MenuMultiPickerStyle {
    public static var menu: MenuMultiPickerStyle { .init() }
}

// MARK: - Preview

private enum PreviewTopping: String, CaseIterable, Hashable, CustomStringConvertible {
    case pepperoni, mushrooms, onions, peppers
    var description: String { rawValue.capitalized }
}

@available(macOS 14.0, iOS 17.0, *)
private struct MenuStylePreview: View {
    @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]

    var body: some View {
        MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
            .multiPickerStyle(.menu)
    }
}

@available(macOS 14.0, iOS 17.0, *)
#Preview("Menu Style") {
    MenuStylePreview()
}
