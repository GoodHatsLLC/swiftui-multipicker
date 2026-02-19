private protocol HashableBox: Sendable {
    func hash(into hasher: inout Hasher)
    func isEqual(to other: any HashableBox) -> Bool
}

private struct ConcreteHashableBox<T: Hashable & Sendable>: HashableBox {
    let value: T

    func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }

    func isEqual(to other: any HashableBox) -> Bool {
        guard let other = other as? ConcreteHashableBox<T> else { return false }
        return value == other.value
    }
}

public struct AnyHashableSendable: Hashable, Sendable {
    private let box: any HashableBox

    public init<Item: Hashable & Sendable>(_ item: Item) {
        box = ConcreteHashableBox(value: item)
    }

    public func hash(into hasher: inout Hasher) {
        box.hash(into: &hasher)
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.box.isEqual(to: rhs.box)
    }
}
