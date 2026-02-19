import SwiftUI

public struct CheckboxMultiPickerStyle: MultiPickerStyle {
    public init() {}

    public func makeBody(configuration: MultiPickerStyleConfiguration) -> some View {
        Section {
          VStack(alignment: .leading) {
            ForEach(configuration.options) { option in
              Toggle(isOn: Binding(
                get: { option.isSelected },
                set: { _ in option.toggle() }
              )) {
                option.label
              }
            }
          }
        } header: {
            configuration.title
        }
    }
}

extension MultiPickerStyle where Self == CheckboxMultiPickerStyle {
    public static var checkbox: CheckboxMultiPickerStyle { .init() }
}
