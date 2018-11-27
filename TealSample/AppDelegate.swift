import Teal

@UIApplicationMain
final class AppDelegate: UIResponder {
    let window = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let screen = Screen<Int, Int>(
            title: "Home",
            initial: 0,
            render: { _ in
                return .stack(
                    [
                        .label(text: "Go"),
                        .button(title: "Go", action: 0),
                    ],
                    axis: .vertical
                )
            }, update: { _, message in
                print("\(message)")
            }
        )
        window.rootViewController = ViewController(screen)
        window.rootViewController!.view!.backgroundColor = .gray
        window.makeKeyAndVisible()

        return true
    }
}
