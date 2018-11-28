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
        return UI(
            .button(
                .init(
                    title: title,
                    action: action
                )
            )
        )
    }
}

extension UI {
    public static func custom(
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ constraints: (ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1)),
                    views: [a.view]
                )
            )
        )
    }
}

extension UI {
    public static func image(
        _ image: UIImage
    ) -> UI {
        return UI(
            .image(
                .init(
                    image: image
                )
            )
        )
    }
}

extension UI {
    public static func label(
        numberOfLines: Int = 1,
        text: String,
        textAlignment: NSTextAlignment = .natural,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> UI {
        return UI(
            .label(
                .init(
                    numberOfLines: numberOfLines,
                    text: text,
                    textAlignment: textAlignment,
                    textColor: textColor,
                    font: font
                )
            )
        )
    }
}

extension UI {
    public static func stack(_ elements: [UI], axis: Axis) -> UI {
        return UI(
            .stack(
                .init(
                    views: elements.map { $0.view },
                    axis: axis
                )
            )
        )
    }
}
