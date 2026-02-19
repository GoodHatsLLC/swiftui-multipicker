import Testing
import SwiftUI
@testable import MultiPicker

// MARK: - Test Helpers

enum Fruit: String, CaseIterable, Hashable, CustomStringConvertible {
    case apple, banana, cherry

    var description: String { rawValue.capitalized }
}

// MARK: - Configuration Tests

@Suite("MultiPickerStyleConfiguration")
struct ConfigurationTests {
    @Test("Options reflect selection state")
    func optionsReflectSelection() {
        let selected: Set<Fruit> = [.apple, .cherry]
        let options = Fruit.allCases.map { fruit in
            MultiPickerStyleConfiguration.Option(
                id: AnyHashableSendable(fruit),
                label: { AnyView(Text(fruit.description)) },
                isSelected: selected.contains(fruit),
                toggle: {}
            )
        }

        #expect(options[0].isSelected == true)   // apple
        #expect(options[1].isSelected == false)  // banana
        #expect(options[2].isSelected == true)   // cherry
    }

    @Test("Toggle closure mutates selection")
    func toggleMutatesSelection() {
        var selected: Set<Fruit> = [.apple]

        let toggle: (Fruit) -> Void = { fruit in
            if selected.contains(fruit) {
                selected.remove(fruit)
            } else {
                selected.insert(fruit)
            }
        }

        toggle(.banana)
        #expect(selected == [.apple, .banana])

        toggle(.apple)
        #expect(selected == [.banana])
    }

    @Test("Option identifiers are unique")
    func optionIdentifiersUnique() {
        let options = Fruit.allCases.map { fruit in
            MultiPickerStyleConfiguration.Option(
                id: AnyHashableSendable(fruit),
                label: { AnyView(Text(fruit.description)) },
                isSelected: false,
                toggle: {}
            )
        }

        let ids = Set(options.map(\.id))
        #expect(ids.count == Fruit.allCases.count)
    }

    @Test("Equal values produce equal identifiers")
    func identifierEquality() {
        let a = AnyHashableSendable(Fruit.apple)
        let b = AnyHashableSendable(Fruit.apple)
        let c = AnyHashableSendable(Fruit.banana)

        #expect(a == b)
        #expect(a != c)
    }
}
