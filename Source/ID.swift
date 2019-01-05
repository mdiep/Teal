/// An identifier for a concrete `UI`.
public struct ID: Hashable {
    internal let value: Int

    internal init(_ value: Int) {
        self.value = value
    }
}

public struct Anchor<Kind> {
    internal let id: ID
    internal let attribute: NSLayoutConstraint.Attribute
}

public enum Dimension {}

extension ID {
    public var height: Anchor<Dimension> {
        return Anchor(id: self, attribute: .height)
    }

    public var width: Anchor<Dimension> {
        return Anchor(id: self, attribute: .width)
    }
}

public enum XAxis {}

extension ID {
    public var centerX: Anchor<XAxis> {
        return Anchor(id: self, attribute: .centerX)
    }
}

public enum YAxis {}

extension ID {
    public var centerY: Anchor<YAxis> {
        return Anchor(id: self, attribute: .centerY)
    }
}
