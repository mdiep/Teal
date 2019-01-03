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
    var attribute: NSLayoutConstraint.Attribute

    private init(_ attribute: NSLayoutConstraint.Attribute) {
        self.attribute = attribute
    }

    internal static let height = Dimension(.height)
    internal static let width = Dimension(.width)
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
    var attribute: NSLayoutConstraint.Attribute

    private init(_ attribute: NSLayoutConstraint.Attribute) {
        self.attribute = attribute
    }

    internal static let center = XAxis(.centerX)
}

extension ID {
    public var centerX: Anchor<XAxis> {
        return Anchor(id: self, kind: .center)
    }
}

public struct YAxis {
    var attribute: NSLayoutConstraint.Attribute

    private init(_ attribute: NSLayoutConstraint.Attribute) {
        self.attribute = attribute
    }

    internal static let center = YAxis(.centerY)
}

extension ID {
    public var centerY: Anchor<YAxis> {
        return Anchor(id: self, kind: .center)
    }
}
