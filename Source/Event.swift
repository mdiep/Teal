public enum Event: Hashable {
    case editingChanged
    case editingDidEnd
    case touchUpInside
}

extension Event {
    var uikitEvent: UIControl.Event {
        switch self {
        case .editingChanged:
            return .editingChanged
        case .editingDidEnd:
            return .editingDidEnd
        case .touchUpInside:
            return .touchUpInside
        }
    }
}
