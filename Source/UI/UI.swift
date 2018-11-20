/// An element in a user interface.
public struct UI<Message: Equatable>: Equatable {
    internal let view: View

    internal init(_ view: View) {
        self.view = view
    }
}

public enum Axis: Equatable {
    case horizontal
    case vertical
}

extension UI {
    public static func button(title: String, action: Message) -> UI {
        return UI(.button(title: title, action: action))
    }
}

extension UI {
    public static func label(
        text: String,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> UI {
        return UI(.label(text: text, textColor: textColor, font: font))
    }
}

extension UI {
    public static func stack(_ elements: [UI], axis: Axis) -> UI {
        return UI(.stack(views: elements.map { $0.view }, axis: axis))
    }
}
