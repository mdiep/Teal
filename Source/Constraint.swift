public struct Anchor<Kind> {
    internal let id: ID
    internal let attribute: NSLayoutConstraint.Attribute
}

public enum Dimension {}
public enum XAxis {}
public enum YAxis {}

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
