public enum Event: Hashable {
    case touchUpInside
}

extension Event {
    var uikitEvent: UIControl.Event {
        switch self {
        case .touchUpInside:
            return .touchUpInside
        }
    }
}
