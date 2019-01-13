/// An identifier for a concrete `UI`.
public struct ID: Hashable {
    internal let value: Int

    internal init(_ value: Int) {
        self.value = value
    }
}

extension ID {
    public var height: Anchor<Size> {
        return Anchor(id: self, attribute: .height)
    }

    public var width: Anchor<Size> {
        return Anchor(id: self, attribute: .width)
    }
}

extension ID {
    public var centerX: Anchor<Horizontal> {
        return Anchor(id: self, attribute: .centerX)
    }

    public var leading: Anchor<Horizontal> {
        return Anchor(id: self, attribute: .leading)
    }

    public var trailing: Anchor<Horizontal> {
        return Anchor(id: self, attribute: .trailing)
    }

    public var horizontal: AnchorPair<Horizontal> {
        return AnchorPair(anchor1: leading, anchor2: trailing)
    }
}

extension ID {
    public var centerY: Anchor<Vertical> {
        return Anchor(id: self, attribute: .centerY)
    }

    public var top: Anchor<Vertical> {
        return Anchor(id: self, attribute: .top)
    }

    public var bottom: Anchor<Vertical> {
        return Anchor(id: self, attribute: .bottom)
    }

    public var vertical: AnchorPair<Vertical> {
        return AnchorPair(anchor1: top, anchor2: bottom)
    }
}
