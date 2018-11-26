import ObjectiveC

/// A trampoline that bounces from `UIControl`'s target-actions to
/// perform blocks.
private final class Target: NSObject {
    let block: () -> Void

    init(_ block: @escaping () -> Void) {
        self.block = block
    }

    @IBAction func execute() {
        block()
    }
}

private let objc_get = objc_getAssociatedObject
private let objc_set = objc_setAssociatedObject

extension UIButton {
    private enum Keys {
        static var touchUpInside = "touchUpInside"
    }

    internal var touchUpInside: () -> Void {
        get {
            let target = objc_get(self, &Keys.touchUpInside) as? Target
            return target?.block ?? {}
        }
        set {
            removeTarget(nil, action: nil, for: .touchUpInside)

            let target = Target(newValue)
            addTarget(target, action: #selector(Target.execute), for: .touchUpInside)

            objc_set(self, &Keys.touchUpInside, target, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
