import Foundation

public struct Property<Message: Equatable>: Equatable {
    enum Kind: Equatable {
        case accessibilityIdentifier(String)
        case backgroundColor(UIColor)
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

        case let .on(event, message):
            view.setBlock(for: event) { perform(message) }
        }
    }
}
