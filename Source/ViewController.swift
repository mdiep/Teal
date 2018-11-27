/// A `UIViewController` for running a `Screen`.
public final class ViewController<Model, Message: Equatable>: UIViewController {
    private var screen: Screen<Model, Message> {
        didSet {
            let view = self.view as! View<Message> // swiftlint:disable:this force_cast
            view.ui = screen.render()
        }
    }

    public init(_ screen: Screen<Model, Message>) {
        self.screen = screen

        super.init(nibName: nil, bundle: nil)

        navigationItem.title = screen.title
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        let ui = screen.render()
        view = View(ui) { [weak self] message in
            self?.screen.update(message)
        }
    }
}
