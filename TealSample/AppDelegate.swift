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
                    [],
                    [ .axis(.vertical) ],
                    [
                        .label([], text: "Go"),
                        .button([.onTouchUpInside(0)], title: "Go"),
                    ]
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
