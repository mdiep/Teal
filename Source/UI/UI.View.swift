extension UI {
    /// An internal representation of a `UI`'s view.
    internal enum View: Equatable {
        case button(Button)
        case label(Label)
        case stack(Stack)
    }
}

extension UI.View {
    struct Button: Equatable {
        let title: String
        let action: Message
    }

    static func button(title: String, action: Message) -> UI.View {
        return .button(Button(title: title, action: action))
    }
}

extension UI.View {
    struct Label: Equatable {
        let text: String
        let textColor: UIColor?
        let font: UIFont?
    }

    static func label(text: String, textColor: UIColor?, font: UIFont?) -> UI.View {
        return .label(Label(text: text, textColor: textColor, font: font))
    }
}

extension UI.View {
    struct Stack: Equatable {
        let views: [UI.View]
        let axis: Axis
    }

    static func stack(views: [UI.View], axis: Axis) -> UI.View {
        return .stack(Stack(views: views, axis: axis))
    }
}
