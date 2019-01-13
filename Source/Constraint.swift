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

public enum Size {}
public enum Horizontal {}
public enum Vertical {}

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
    internal var priority: UILayoutPriority
    internal let relation: NSLayoutConstraint.Relation
    internal let first: AnyAnchor
    internal let second: AnyAnchorTarget

    fileprivate init<Kind>(
        _ priority: UILayoutPriority,
        _ relation: NSLayoutConstraint.Relation,
        _ first: Anchor<Kind>,
        _ second: AnchorTarget<Kind>
    ) {
        self.priority = priority
        self.relation = relation
        self.first = AnyAnchor(first)
        self.second = AnyAnchorTarget(second)
    }
}

extension Constraint {
    public static func equal<Kind>(
        _ lhs: Anchor<Kind>,
        _ rhs: AnchorTarget<Kind>
    ) -> Constraint {
        return Constraint(.required, .equal, lhs, rhs)
    }
}

extension Constraint {
    public static func priority(
        _ priority: UILayoutPriority,
        _ constraint: Constraint
    ) -> Constraint {
        var result = constraint
        result.priority = priority
        return result
    }
}
