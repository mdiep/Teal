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
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ constraints: (ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0)),
                    views: []
                )
            )
        )
    }

    public static func custom(
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ constraints: (ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1)),
                    views: [a.view]
                )
            )
        )
    }

    public static func custom(
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ b: UI,
        _ constraints: (ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1), ID(2)),
                    views: [a.view, b.view]
                )
            )
        )
    }

    public static func custom(
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ constraints: (ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3)),
                    views: [a.view, b.view, c.view]
                )
            )
        )
    }

    public static func custom(
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ constraints: (ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3), ID(4)),
                    views: [a.view, b.view, c.view, d.view]
                )
            )
        )
    }

    // swiftlint:disable:next function_parameter_count
    public static func custom(
        accessibilityIdentifier: String? = nil,
        backgroundColor: UIColor? = nil,
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ e: UI,
        _ constraints: (ID, ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            .custom(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
                    backgroundColor: backgroundColor,
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3), ID(4), ID(5)),
                    views: [a.view, b.view, c.view, d.view, e.view]
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
        accessibilityIdentifier: String? = nil,
        numberOfLines: Int = 1,
        text: String,
        textAlignment: NSTextAlignment = .natural,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> UI {
        return UI(
            .label(
                .init(
                    accessibilityIdentifier: accessibilityIdentifier,
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
