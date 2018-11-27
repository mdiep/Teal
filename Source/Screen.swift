/// A screen, corresponding to a `UIViewController`.
public struct Screen<Model, Message: Equatable> {
    public private(set) var title: String
    public private(set) var model: Model
    private let _render: (Model) -> UI<Message>
    private let _update: (inout Model, Message) -> Void

    public init(
        title: String,
        initial model: Model,
        render: @escaping (Model) -> UI<Message>,
        update: @escaping (inout Model, Message) -> Void
    ) {
        self.title = title
        self.model = model
        _render = render
        _update = update
    }

    public func render() -> UI<Message> {
        return _render(model)
    }

    public mutating func update(_ message: Message) {
        _update(&model, message)
    }
}
