import UIKit

/// A `UIView` that hosts a `Teal.UI`.
public final class View<Message: Equatable>: UIView {
    public let ui: UI<Message>

    public init(_ ui: UI<Message>) {
        self.ui = ui
        super.init(frame: .zero)

        let view = makeUIView(for: ui.view)
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
}

extension View {
    fileprivate func makeUIView(for view: UI<Message>.View) -> UIView {
        switch view {
        case let .button(button):
            return makeUIView(for: button)
        case let .label(label):
            return makeUIView(for: label)
        case let .stack(stack):
            return makeUIView(for: stack)
        }
    }

    fileprivate func makeUIView(for button: UI<Message>.View.Button) -> UIView {
        let view = UIButton()
        view.setTitle(button.title, for: .normal)
        return view
    }

    fileprivate func makeUIView(for label: UI<Message>.View.Label) -> UIView {
        let view = UILabel()
        view.text = label.text
        view.font = label.font
        return view
    }

    fileprivate func makeUIView(for stack: UI<Message>.View.Stack) -> UIView {
        let view = UIStackView(arrangedSubviews: stack.views.map(makeUIView))
        view.axis = stack.axis == .vertical ? .vertical : .horizontal
        return view
    }
}
