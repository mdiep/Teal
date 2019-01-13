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
public struct Target<Kind>: Equatable {
    internal let anchor: Anchor<Kind>?
    internal var offset: CGFloat
}

internal struct AnyTarget: Hashable {
    internal let anchor: AnyAnchor?
    internal let offset: CGFloat
}

extension AnyTarget {
    init<Kind>(_ target: Target<Kind>) {
        anchor = target.anchor.map(AnyAnchor.init)
        offset = target.offset
    }
}

extension Target {
    public static func anchor(_ anchor: Anchor<Kind>) -> Target {
        return Target(anchor: anchor, offset: 0)
    }

    public static func const(_ offset: CGFloat) -> Target {
        return Target(anchor: nil, offset: offset)
    }

    public static func add(
        _ offset: CGFloat,
        _ target: Target<Kind>
    ) -> Target {
        var result = target
        result.offset += offset
        return result
    }
}

public struct AnchorPair<Kind>: Equatable {
    let anchor1: Anchor<Kind>
    let anchor2: Anchor<Kind>
}

public struct TargetPair<Kind>: Equatable {
    let target1: Target<Kind>
    let target2: Target<Kind>
}

extension TargetPair {
    public static func anchor(_ anchor: AnchorPair<Kind>) -> TargetPair {
        return TargetPair(
            target1: .anchor(anchor.anchor1),
            target2: .anchor(anchor.anchor2)
        )
    }
}

internal struct Connection: Hashable {
    let anchor: AnyAnchor
    let target: AnyTarget
}

extension Connection {
    init<Kind>(_ anchor: Anchor<Kind>, _ target: Target<Kind>) {
        self.anchor = AnyAnchor(anchor)
        self.target = AnyTarget(target)
    }
}

/// A constraint used to design a custom view.
public struct Constraint: Hashable {
    internal var priority: UILayoutPriority
    internal let relation: NSLayoutConstraint.Relation
    internal let connections: [Connection]

    fileprivate init(
        _ priority: UILayoutPriority,
        _ relation: NSLayoutConstraint.Relation,
        _ connections: [Connection]
    ) {
        self.priority = priority
        self.relation = relation
        self.connections = connections
    }
}

extension Constraint {
    public static func equal<Kind>(
        _ lhs: Anchor<Kind>,
        _ rhs: Target<Kind>
    ) -> Constraint {
        return Constraint(.required, .equal, [Connection(lhs, rhs)])
    }

    public static func equal<Kind>(
        _ lhs: AnchorPair<Kind>,
        _ rhs: TargetPair<Kind>
    ) -> Constraint {
        return Constraint(
            .required, .equal, [
                Connection(lhs.anchor1, rhs.target1),
                Connection(lhs.anchor2, rhs.target2),
            ]
        )
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
