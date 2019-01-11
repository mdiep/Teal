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

extension UIControl {
    private enum Keys {
        static var targets = "targets"
    }

    internal func setBlock(for event: Teal.Event, _ block: @escaping () -> Void) {
        var targets: [Teal.Event: Target]

        if let object = objc_get(self, &Keys.targets) {
            removeTarget(nil, action: nil, for: event.uikitEvent)
            targets = object as! [Teal.Event: Target] // swiftlint:disable:this force_cast
        } else {
            targets = [:]
        }

        let target = Target(block)
        addTarget(target, action: #selector(Target.execute), for: event.uikitEvent)

        targets[event] = target
        objc_set(self, &Keys.targets, targets, .OBJC_ASSOCIATION_COPY)
    }
}
