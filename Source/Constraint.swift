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
    internal let anchor1: Anchor<Kind>
    internal let anchor2: Anchor<Kind>
}

public struct TargetPair<Kind>: Equatable {
    internal let target1: Target<Kind>
    internal let target2: Target<Kind>
}

public struct EdgeAnchors: Equatable {
    internal let id: ID
}

public struct EdgeTargets: Equatable {
    internal let id: ID
    internal let insets: UIEdgeInsets
}

extension EdgeTargets {
    public static func anchor(_ anchors: EdgeAnchors) -> EdgeTargets {
        return EdgeTargets(id: anchors.id, insets: .zero)
    }

    public static func inset(_ insets: UIEdgeInsets, targets: EdgeTargets) -> EdgeTargets {
        return EdgeTargets(
            id: targets.id,
            insets: UIEdgeInsets(
                top: targets.insets.top - insets.top,
                left: targets.insets.left - insets.left,
                bottom: targets.insets.bottom - insets.bottom,
                right: targets.insets.right - insets.right
            )
        )
    }
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

    fileprivate init(_ anchor: AnyAnchor, _ target: AnyTarget) {
        self.anchor = anchor
        self.target = target
    }
}

extension Connection {
    fileprivate init<Kind>(_ anchor: Anchor<Kind>, _ target: Target<Kind>) {
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

    public static func equal(_ lhs: EdgeAnchors, _ rhs: EdgeTargets) -> Constraint {
        return Constraint(
            .required, .equal, [
                Connection(
                    AnyAnchor(id: lhs.id, attribute: .top),
                    AnyTarget(
                        anchor: AnyAnchor(id: rhs.id, attribute: .top),
                        offset: -rhs.insets.top
                    )
                ),
                Connection(
                    AnyAnchor(id: lhs.id, attribute: .bottom),
                    AnyTarget(
                        anchor: AnyAnchor(id: rhs.id, attribute: .bottom),
                        offset: -rhs.insets.bottom
                    )
                ),
                Connection(
                    AnyAnchor(id: lhs.id, attribute: .right),
                    AnyTarget(
                        anchor: AnyAnchor(id: rhs.id, attribute: .right),
                        offset: -rhs.insets.right
                    )
                ),
                Connection(
                    AnyAnchor(id: lhs.id, attribute: .left),
                    AnyTarget(
                        anchor: AnyAnchor(id: rhs.id, attribute: .left),
                        offset: -rhs.insets.left
                    )
                ),
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
