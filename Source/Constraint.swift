/// A constraint used to design a custom view.
public struct Constraint: Hashable {
    internal struct Item: Hashable {
        internal let id: ID
        internal let attribute: NSLayoutConstraint.Attribute
    }

    internal let first: Item
    internal let relation: NSLayoutConstraint.Relation
    internal let second: Item?
    internal let constant: Float
}

private protocol AttributeKind {
    var attribute: NSLayoutConstraint.Attribute { get }
}

extension Dimension: AttributeKind {}

extension XAxis: AttributeKind {}

extension YAxis: AttributeKind {}

extension Constraint {
    fileprivate init<Kind: AttributeKind>(
        _ lhs: Anchor<Kind>,
        _ relation: NSLayoutConstraint.Relation,
        _ rhs: Anchor<Kind>?,
        constant: Float = 0
    ) {
        self.init(
            first: Constraint.Item(id: lhs.id, attribute: lhs.kind.attribute),
            relation: relation,
            second: rhs.map { Constraint.Item(id: $0.id, attribute: $0.kind.attribute) },
            constant: constant
        )
    }
}

public func == (lhs: Anchor<Dimension>, rhs: Anchor<Dimension>) -> Constraint {
    return Constraint(lhs, .equal, rhs)
}

public func == (lhs: Anchor<Dimension>, rhs: Float) -> Constraint {
    return Constraint(lhs, .equal, nil, constant: rhs)
}

public func == (lhs: Anchor<XAxis>, rhs: Anchor<XAxis>) -> Constraint {
    return Constraint(lhs, .equal, rhs)
}

public func == (lhs: Anchor<YAxis>, rhs: Anchor<YAxis>) -> Constraint {
    return Constraint(lhs, .equal, rhs)
}
