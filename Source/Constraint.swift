/// An anchor used to build constraints.
public struct Anchor<Kind>: Equatable {
    internal let id: ID
    internal let attribute: NSLayoutConstraint.Attribute
}

internal struct AnyAnchor: Hashable {
    internal let id: ID
    internal let attribute: NSLayoutConstraint.Attribute
}

extension AnyAnchor {
    init<Kind>(_ anchor: Anchor<Kind>) {
        id = anchor.id
        attribute = anchor.attribute
    }
}

public enum Dimension {}
public enum XAxis {}
public enum YAxis {}

/// A target that an anchor can be constrained to.
public struct AnchorTarget<Kind>: Equatable {
    internal let anchor: Anchor<Kind>?
    internal var offset: CGFloat
}

internal struct AnyAnchorTarget: Hashable {
    internal let anchor: AnyAnchor?
    internal let offset: CGFloat
}

extension AnyAnchorTarget {
    init<Kind>(_ target: AnchorTarget<Kind>) {
        anchor = target.anchor.map(AnyAnchor.init)
        offset = target.offset
    }
}

extension AnchorTarget {
    public static func anchor(_ anchor: Anchor<Kind>) -> AnchorTarget {
        return AnchorTarget(anchor: anchor, offset: 0)
    }

    public static func const(_ offset: CGFloat) -> AnchorTarget {
        return AnchorTarget(anchor: nil, offset: offset)
    }

    public static func add(
        _ offset: CGFloat,
        _ target: AnchorTarget<Kind>
    ) -> AnchorTarget {
        var result = target
        result.offset += offset
        return result
    }
}

/// A constraint used to design a custom view.
public struct Constraint: Hashable {
    internal let first: AnyAnchor
    internal let relation: NSLayoutConstraint.Relation
    internal let second: AnyAnchorTarget

    fileprivate init<Kind>(
        _ first: Anchor<Kind>,
        _ relation: NSLayoutConstraint.Relation,
        _ second: AnchorTarget<Kind>
    ) {
        self.first = AnyAnchor(first)
        self.relation = relation
        self.second = AnyAnchorTarget(second)
    }
}

extension Constraint {
    public static func equal<Kind>(
        _ lhs: Anchor<Kind>,
        _ rhs: AnchorTarget<Kind>
    ) -> Constraint {
        return Constraint(lhs, .equal, rhs)
    }
}
