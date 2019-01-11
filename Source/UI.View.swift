extension UI {
    /// An internal representation of a `UI`'s view.
    internal enum View: Equatable {
        case button(Button)
        case custom(Custom)
        case image(Image)
        case label(Label)
        case stack(Stack)
        case textField(TextField)
    }
}

extension UI.View {
    struct Button: Equatable {
        let title: String
    }
}

extension UI.View {
    struct Custom: Equatable {
        let constraints: Set<Constraint>
        let views: [UI]
    }
}

extension UI.View {
    struct Image: Equatable {
        let image: UIImage
    }
}

extension UI.View {
    struct Label: Equatable {
        let numberOfLines: Int
        let text: String
        let textAlignment: NSTextAlignment
        let textColor: UIColor?
        let font: UIFont?
    }
}

extension UI.View {
    struct Stack: Equatable {
        let views: [UI]
        let axis: Axis
    }
}

extension UI.View {
    struct TextField: Equatable {
        let placeholder: String
        let text: String
    }
}
