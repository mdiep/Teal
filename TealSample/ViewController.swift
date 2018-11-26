import Teal

final class ViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .lightGray

        struct Message: Equatable {}
        let ui = UI<Message>.stack(
            [
                .label(text: "Go"),
                .button(title: "Go", action: Message()),
            ],
            axis: .vertical
        )

        let view = Teal.View(ui) { message in
            print(message)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        let guide = self.view.safeAreaLayoutGuide
        view.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
}
