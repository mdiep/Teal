import UIKit

/// A `UIView` that hosts a `Teal.UI`.
public final class View<Message: Equatable>: UIView {
    public let ui: UI<Message>
    private let view: UIView

    public init(_ ui: UI<Message>) {
        self.ui = ui
        view = ui.view.makeUIView()

        super.init(frame: view.frame)

        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return view.intrinsicContentSize
    }
}

extension UI.View {
    fileprivate func makeUIView() -> UIView {
        switch self {
        case let .button(button):
            return button.makeUIView()
        case let .custom(custom):
            return custom.makeUIView()
        case let .label(label):
            return label.makeUIView()
        case let .stack(stack):
            return stack.makeUIView()
        }
    }
}

extension UI.View.Button {
    fileprivate func makeUIView() -> UIView {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

extension UI.View.Custom {
    fileprivate func makeUIView() -> UIView {
        let view = UIView()

        let subviews = views.map { $0.makeUIView() }
        subviews.forEach(view.addSubview)

        let allViews = [view] + subviews
        for constraint in constraints {
            NSLayoutConstraint(
                item: allViews[constraint.first.id.value],
                attribute: constraint.first.attribute,
                relatedBy: constraint.relation,
                toItem: constraint.second.map { allViews[$0.id.value] },
                attribute: constraint.second.map { $0.attribute } ?? .notAnAttribute,
                multiplier: 1,
                constant: CGFloat(constraint.constant)
            ).isActive = true
        }

        return view
    }
}

extension UI.View.Label {
    fileprivate func makeUIView() -> UIView {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UI.View.Stack {
    fileprivate func makeUIView() -> UIView {
        let stack = UIStackView(arrangedSubviews: views.map { $0.makeUIView() })
        stack.axis = axis == .vertical ? .vertical : .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}
