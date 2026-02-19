import SwiftUI

// MARK: - Style Protocol

public protocol MultiPickerStyle: Sendable {
    associatedtype Body: View
    @MainActor @ViewBuilder func makeBody(configuration: MultiPickerStyleConfiguration) -> Body
}

// MARK: - Configuration

public struct MultiPickerStyleConfiguration {
    public let title: Text
    public let options: [Option]

    public struct Option: Identifiable, Sendable {
        public let id: AnyHashableSendable
        public let isSelected: Bool
        private let _label: @Sendable @MainActor () -> AnyView
        private let _toggle: @Sendable @MainActor () -> Void

        @MainActor public var label: AnyView { _label() }
        @MainActor public func toggle() { _toggle() }

        init(
            id: AnyHashableSendable,
            label: @Sendable @MainActor @escaping () -> AnyView,
            isSelected: Bool,
            toggle: @Sendable @MainActor @escaping () -> Void
        ) {
            self.id = id
            self._label = label
            self.isSelected = isSelected
            self._toggle = toggle
        }
    }
}

// MARK: - Type Erasure (internal)

struct AnyMultiPickerStyle: Sendable {
    private let _makeBody: @Sendable @MainActor (MultiPickerStyleConfiguration) -> AnyView

    init<S: MultiPickerStyle>(_ style: S) {
        _makeBody = { configuration in
          AnyView(VStack { style.makeBody(configuration: configuration) })
        }
    }

    @MainActor
    func makeBody(configuration: MultiPickerStyleConfiguration) -> AnyView {
        _makeBody(configuration)
    }
}

// MARK: - Environment

private struct MultiPickerStyleKey: EnvironmentKey {
    static let defaultValue = AnyMultiPickerStyle(MenuMultiPickerStyle())
}

extension EnvironmentValues {
    var multiPickerStyle: AnyMultiPickerStyle {
        get { self[MultiPickerStyleKey.self] }
        set { self[MultiPickerStyleKey.self] = newValue }
    }
}

extension View {
    public func multiPickerStyle<S: MultiPickerStyle>(_ style: S) -> some View {
        environment(\.multiPickerStyle, AnyMultiPickerStyle(style))
    }
}
