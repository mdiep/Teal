/// An anchor used to build constraints.
public struct Anchor<Kind> {
    internal let id: ID
    internal let attribute: NSLayoutConstraint.Attribute
}

public enum Dimension {}
public enum XAxis {}
public enum YAxis {}

/// An anchor that's offset by a constant number of points.
public struct OffsetAnchor<Kind> {
    internal let anchor: Anchor<Kind>
    internal let offset: Float
}

public func + <Kind>(lhs: Anchor<Kind>, rhs: Float) -> OffsetAnchor<Kind> {
    return OffsetAnchor(anchor: lhs, offset: rhs)
}

public func - <Kind>(lhs: Anchor<Kind>, rhs: Float) -> OffsetAnchor<Kind> {
    return OffsetAnchor(anchor: lhs, offset: -rhs)
}

/// A constraint used to design a custom view.
public struct Constraint: Hashable {
    internal struct Item: Hashable {
        internal let id: ID
        internal let attribute: NSLayoutConstraint.Attribute
    }

    internal let first: Item
    internal let relation: NSLayoutConstraint.Relation
    internal let second: Item?
    internal var constant: Float
}

extension Constraint {
    fileprivate init<Kind>(
        _ lhs: Anchor<Kind>,
        _ relation: NSLayoutConstraint.Relation,
        _ rhs: Anchor<Kind>?,
        constant: Float = 0
    ) {
        self.init(
            first: Constraint.Item(id: lhs.id, attribute: lhs.attribute),
            relation: relation,
            second: rhs.map { Constraint.Item(id: $0.id, attribute: $0.attribute) },
            constant: constant
        )
    }
}

public func == <Kind>(lhs: Anchor<Kind>, rhs: Anchor<Kind>) -> Constraint {
    return Constraint(lhs, .equal, rhs)
}

public func == <Kind>(lhs: Anchor<Kind>, rhs: Float) -> Constraint {
    return Constraint(lhs, .equal, nil, constant: rhs)
}

public func == <Kind>(lhs: Anchor<Kind>, rhs: OffsetAnchor<Kind>) -> Constraint {
    var constraint = lhs == rhs.anchor
    constraint.constant = rhs.offset
    return constraint
}
