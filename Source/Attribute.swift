import Foundation

public struct Attribute<Message: Equatable>: Equatable {
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

extension Attribute {
    public static func accessibilityIdentifier(_ string: String) -> Attribute {
        return Attribute(.accessibilityIdentifier(string))
    }

    public static func backgroundColor(_ color: UIColor) -> Attribute {
        return Attribute(.backgroundColor(color))
    }

    public static func onTouchUpInside(_ message: Message) -> Attribute {
        return Attribute(.on(.touchUpInside, message))
    }
}

extension Attribute {
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
