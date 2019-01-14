import Foundation

public struct Property<Message: Equatable>: Equatable {
    enum Kind: Equatable {
        case accessibilityIdentifier(String)
        case backgroundColor(UIColor)
        case contentCompressionResistancePriority(NSLayoutConstraint.Axis, UILayoutPriority)
        case contentHuggingPriority(NSLayoutConstraint.Axis, UILayoutPriority)
        case on(Event, Message)
    }

    let kind: Kind

    init(_ kind: Kind) {
        self.kind = kind
    }
}

extension Property {
    public static func accessibilityIdentifier(_ string: String) -> Property {
        return Property(.accessibilityIdentifier(string))
    }

    public static func backgroundColor(_ color: UIColor) -> Property {
        return Property(.backgroundColor(color))
    }

    public static func contentCompressionResistancePriority(
        _ axis: NSLayoutConstraint.Axis,
        _ priority: UILayoutPriority
    ) -> Property {
        return Property(.contentCompressionResistancePriority(axis, priority))
    }

    public static func contentHuggingPriority(
        _ axis: NSLayoutConstraint.Axis,
        _ priority: UILayoutPriority
    ) -> Property {
        return Property(.contentHuggingPriority(axis, priority))
    }

    public static func onTouchUpInside(_ message: Message) -> Property {
        return Property(.on(.touchUpInside, message))
    }
}

extension Property {
    func apply(to view: UIControl, _ perform: @escaping (Message) -> Void) {
        switch kind {
        case let .accessibilityIdentifier(identifier):
            view.accessibilityIdentifier = identifier

        case let .backgroundColor(color):
            view.backgroundColor = color

        case let .contentCompressionResistancePriority(axis, priority):
            view.setContentCompressionResistancePriority(priority, for: axis)

        case let .contentHuggingPriority(axis, priority):
            view.setContentHuggingPriority(priority, for: axis)

        case let .on(event, message):
            view.setBlock(for: event) { perform(message) }
        }
    }
}
