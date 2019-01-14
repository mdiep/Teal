/// An element in a user interface.
public struct UI<Message: Equatable>: Equatable {
    internal let properties: [Property<Message>]
    internal let view: View

    internal init(_ properties: [Property<Message>], _ view: View) {
        self.properties = properties
        self.view = view
    }
}

public enum Axis: Equatable {
    case horizontal
    case vertical
}

extension UI {
    public static func button(_ properties: [Property<Message>], title: String) -> UI {
        return UI(
            properties,
            .button(.init(title: title))
        )
    }
}

extension UI {
    public static func custom(
        _ properties: [Property<Message>],
        _ constraints: (ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
            .custom(
                .init(
                    constraints: constraints(ID(0)),
                    views: []
                )
            )
        )
    }

    public static func custom(
        _ properties: [Property<Message>],
        _ a: UI,
        _ constraints: (ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1)),
                    views: [a]
                )
            )
        )
    }

    public static func custom(
        _ properties: [Property<Message>],
        _ a: UI,
        _ b: UI,
        _ constraints: (ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
            .custom(
                .init(
                    constraints: constraints(ID(0), ID(1), ID(2)),
                    views: [a, b]
                )
            )
        )
    }

    public static func custom(
        _ properties: [Property<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ constraints: (ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
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
        _ properties: [Property<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ constraints: (ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
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
        _ properties: [Property<Message>],
        _ a: UI,
        _ b: UI,
        _ c: UI,
        _ d: UI,
        _ e: UI,
        _ constraints: (ID, ID, ID, ID, ID, ID) -> Set<Constraint>
    ) -> UI {
        return UI(
            properties,
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
        _ properties: [Property<Message>],
        _ image: UIImage
    ) -> UI {
        return UI(
            properties,
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
        _ properties: [Property<Message>],
        numberOfLines: Int = 1,
        text: String,
        textAlignment: NSTextAlignment = .natural,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) -> UI {
        return UI(
            properties,
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
        _ properties: [Property<Message>],
        _ elements: [UI],
        axis: Axis
    ) -> UI {
        return UI(
            properties,
            .stack(.init(views: elements, axis: axis))
        )
    }
}

extension UI {
    public static func textField(
        _ properties: [Property<Message>],
        placeholder: String = "",
        text: String = ""
    ) -> UI {
        return UI(properties, .textField(.init(placeholder: placeholder, text: text)))
    }
}
