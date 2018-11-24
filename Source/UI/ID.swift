/// An identifier for a concrete `UI`.
public struct ID: Hashable {
    internal let value: Int

    internal init(_ value: Int) {
        self.value = value
    }
}

public struct Anchor<Kind> {
    internal let id: ID
    internal let kind: Kind
}

public struct Dimension {
    internal enum Kind {
        case height
        case width
    }

    internal let kind: Kind

    internal static let height = Dimension(kind: .height)
    internal static let width = Dimension(kind: .width)
}

extension ID {
    public var height: Anchor<Dimension> {
        return Anchor(id: self, kind: .height)
    }

    public var width: Anchor<Dimension> {
        return Anchor(id: self, kind: .width)
    }
}

public struct XAxis {
    internal enum Kind {
        case center
    }

    internal let kind: Kind

    internal static let center = XAxis(kind: .center)
}

extension ID {
    public var centerX: Anchor<XAxis> {
        return Anchor(id: self, kind: .center)
    }
}

public struct YAxis {
    internal enum Kind {
        case center
    }

    internal let kind: Kind

    internal static let center = YAxis(kind: .center)
}

extension ID {
    public var centerY: Anchor<YAxis> {
        return Anchor(id: self, kind: .center)
    }
}
