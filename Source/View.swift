import UIKit

extension UIView {
    fileprivate func constrainEdgesToSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

/// A `UIView` that hosts a `Teal.UI`.
public final class View<Message: Equatable>: UIView {
    public var ui: UI<Message> {
        didSet {
            view = ui.makeUIView { [weak self] message in
                self?.perform(message)
            }
        }
    }

    public var perform: (Message) -> Void

    private var view: UIView {
        willSet {
            view.removeFromSuperview()
        }
        didSet {
            addSubview(view)
            constrainEdgesToSubview(view)
        }
    }

    public init(
        _ ui: UI<Message>,
        perform: @escaping (Message) -> Void = { _ in }
    ) {
        defer { self.ui = ui }
        self.ui = ui
        self.perform = perform
        view = UIView()

        super.init(frame: view.frame)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        return view.intrinsicContentSize
    }
}

extension UI {
    fileprivate func makeUIView(
        _ perform: @escaping (Message) -> Void
    ) -> UIView {
        let view: UIControl
        switch self.view {
        case let .button(button):
            view = button.makeUIView()
        case let .custom(custom):
            view = custom.makeUIView(perform)
        case let .image(image):
            view = image.makeUIView()
        case let .label(label):
            view = label.makeUIView()
        case let .stack(stack):
            view = stack.makeUIView(perform)
        case let .textField(textField):
            view = textField.makeUIView()
        }
        attributes.forEach { $0.apply(to: view, perform) }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}

extension UI.View.Button {
    fileprivate func makeUIView() -> UIControl {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        return button
    }
}

extension UI.View.Custom {
    fileprivate func makeUIView(
        _ perform: @escaping (Message) -> Void
    ) -> UIControl {
        let view = UIControl()

        let subviews = views.map { $0.makeUIView(perform) }
        subviews.forEach(view.addSubview)

        let allViews = [view] + subviews
        for constraint in constraints {
            for connection in constraint.connections {
                let anchor = connection.anchor
                let target = connection.target
                NSLayoutConstraint(
                    item: allViews[anchor.id.value],
                    attribute: anchor.attribute,
                    relatedBy: constraint.relation,
                    toItem: target.anchor.map { allViews[$0.id.value] },
                    attribute: target.anchor?.attribute ?? .notAnAttribute,
                    multiplier: 1,
                    constant: target.offset
                ).isActive = true
            }
        }

        return view
    }
}

extension UI.View.Image {
    fileprivate func makeUIView() -> UIControl {
        let view = UIImageView()
        view.image = image

        let control = UIControl()
        control.addSubview(view)
        control.constrainEdgesToSubview(view)
        return control
    }
}

extension UI.View.Label {
    fileprivate func makeUIView() -> UIControl {
        let label = UILabel()
        label.numberOfLines = numberOfLines
        label.text = text
        label.textAlignment = textAlignment
        label.textColor = textColor
        label.font = font
        label.sizeToFit()

        let control = UIControl()
        control.addSubview(label)
        control.constrainEdgesToSubview(label)
        return control
    }
}

extension UI.View.Stack {
    fileprivate func makeUIView(
        _ perform: @escaping (Message) -> Void
    ) -> UIControl {
        let views = self.views.map { $0.makeUIView(perform) }
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = axis == .vertical ? .vertical : .horizontal

        let control = UIControl()
        control.addSubview(stack)
        control.constrainEdgesToSubview(stack)
        return control
    }
}

extension UI.View.TextField {
    fileprivate func makeUIView() -> UIControl {
        let view = UITextField()
        view.placeholder = placeholder
        view.text = text
        return view
    }
}
