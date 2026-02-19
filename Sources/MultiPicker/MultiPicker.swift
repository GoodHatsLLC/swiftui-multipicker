import SwiftUI

public struct MultiPicker<SelectionValue: Hashable & Sendable, ItemLabel: View>: View {
    let title: Text
    let options: [SelectionValue]
    @Binding var selection: Set<SelectionValue>
    let itemLabel: (SelectionValue) -> ItemLabel

    @Environment(\.multiPickerStyle) private var style

    public var body: some View {
        style.makeBody(configuration: MultiPickerStyleConfiguration(
            title: title,
            options: options.map { option in
                .init(
                    id: AnyHashableSendable(option),
                    label: { AnyView(self.itemLabel(option)) },
                    isSelected: selection.contains(option),
                    toggle: { self.toggleSelection(option) }
                )
            }
        ))
    }

    private func toggleSelection(_ option: SelectionValue) {
        if selection.contains(option) {
            selection.remove(option)
        } else {
            selection.insert(option)
        }
    }
}

// MARK: - ViewBuilder Initializers

extension MultiPicker {
    public init(
        _ title: LocalizedStringKey,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder itemLabel: @escaping (SelectionValue) -> ItemLabel
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = itemLabel
    }

    public init(
        _ title: String,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>,
        @ViewBuilder itemLabel: @escaping (SelectionValue) -> ItemLabel
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = itemLabel
    }
}

// MARK: - KeyPath Initializers

extension MultiPicker where ItemLabel == Text {
    public init(
        _ title: LocalizedStringKey,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>,
        labelKeyPath: KeyPath<SelectionValue, String>
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = { Text($0[keyPath: labelKeyPath]) }
    }

    public init(
        _ title: String,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>,
        labelKeyPath: KeyPath<SelectionValue, String>
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = { Text($0[keyPath: labelKeyPath]) }
    }
}

// MARK: - CustomStringConvertible Initializers

extension MultiPicker where ItemLabel == Text, SelectionValue: CustomStringConvertible {
    public init(
        _ title: LocalizedStringKey,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = { Text($0.description) }
    }

    public init(
        _ title: String,
        sources: [SelectionValue],
        selection: Binding<Set<SelectionValue>>
    ) {
        self.title = Text(title)
        self.options = sources
        self._selection = selection
        self.itemLabel = { Text($0.description) }
    }
}


// MARK: - Preview

private enum PreviewTopping: String, CaseIterable, Hashable, CustomStringConvertible {
    case pepperoni, mushrooms, onions, peppers
    var description: String { rawValue.capitalized }
}

#Preview("Checkbox Style") {
  @Previewable @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]
  MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
      .multiPickerStyle(.checkbox)
      .padding()
}

#Preview("Chips Style") {
  @Previewable @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]
  MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
      .multiPickerStyle(.chips)
      .frame(width: 250)
      .padding()
}

#Preview("Inline List Style") {
  @Previewable @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]
  MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
      .multiPickerStyle(.inlineList)
      .frame(width: 250)
      .padding()

}
#Preview("Menu Style") {
  @Previewable @State var selection: Set<PreviewTopping> = [.pepperoni, .mushrooms]
  MultiPicker("Toppings", sources: PreviewTopping.allCases, selection: $selection)
      .multiPickerStyle(.menu)
      .padding()
}

