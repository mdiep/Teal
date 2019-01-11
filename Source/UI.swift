/// An element in a user interface.
public struct UI<Message: Equatable>: Equatable {
    internal let attributes: [Attribute<Message>]
    internal let view: View

    internal init(_ attributes: [Attribute<Message>], _ view: View) {
        self.attributes = attributes
        self.view = view
    }
}

public enum Axis: Equatable {
    case horizontal
    case vertical
}

extension UI {
    public static func button(_ attributes: [Attribute<Message>], title: String) -> UI {
        return UI(
            attributes,
            .button(.init(title: title))
        )
    }
}

extension UI {
    public static func custom(
        _ attributes: [Attribute<Message>],
        _ constraints: (ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0)),
                    views: []
                )
            )
        )
    }

    public static func custom(
        _ attributes: [Attribute<Message>],
        _ a: UI,
        _ constraints: (ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1)),
                    views: [a]
                )
            )
        )
    }

    public static func custom(
        _ attributes: [Attribute<Message>],
        _ a: UI,
        _ b: UI,
        _ constraints: (ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1), ID(2)),
                    views: [a, b]
                )
            )
        )
    }

    public static func custom(
        _ attributes: [Attribute<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ constraints: (ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3)),
                    views: [a, b, c]
                )
            )
        )
    }

    // swiftlint:disable:next function_parameter_count
    public static func custom(
        _ attributes: [Attribute<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ constraints: (ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3), ID(4)),
                    views: [a, b, c, d]
                )
            )
        )
    }

    // swiftlint:disable:next function_parameter_count
    public static func custom(
        _ attributes: [Attribute<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ e: UI,
        _ constraints: (ID, ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            attributes,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1), ID(2), ID(3), ID(4), ID(5)),
                    views: [a, b, c, d, e]
                )
            )
        )
    }
}

extension UI {
    public static func image(
        _ attributes: [Attribute<Message>],
        _ image: UIImage
    ) -> UI {
        return UI(
            attributes,
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
        _ attributes: [Attribute<Message>],
        numberOfLines: Int = 1,
        text: String,
        textAlignment: NSTextAlignment = .natural,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> UI {
        return UI(
            attributes,
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
    public static func stack(
        _ attributes: [Attribute<Message>],
        _ elements: [UI],
        axis: Axis
    ) -> UI {
        return UI(
            attributes,
            .stack(.init(views: elements, axis: axis))
        )
    }
}

extension UI {
    public static func textField(
        _ attributes: [Attribute<Message>],
        placeholder: String = "",
        text: String = ""
    ) -> UI {
        return UI(attributes, .textField(.init(placeholder: placeholder, text: text)))
    }
}
