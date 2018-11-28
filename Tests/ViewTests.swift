import SnapshotTesting
import Teal
import XCTest

// swiftlint:disable force_cast

private struct Message: Equatable {}

final class ViewPerformTests: XCTestCase {
    func testButton() {
        var message: Message?
        let ui = UI<Message>.button(title: "", action: Message())
        let view = View(ui) { message = $0 }
        let button = view.subviews[0] as! UIButton
        button.sendActions(for: .touchUpInside)
        XCTAssertNotNil(message)
    }
}

final class ViewSnapshotTests: XCTestCase {
    fileprivate func snapshot(
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line,
        _ ui: UI<Message>,
        _ rest: UI<Message>...,
        width: CGFloat? = nil
    ) {
        let view = View(ui)
        if let width = width {
            view.widthAnchor
                .constraint(equalToConstant: width)
                .isActive = true
        }

        rest.forEach { view.ui = $0 }

        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        assertSnapshot(matching: view, file: file, function: function, line: line)
    }

    func testButton() {
        snapshot(.button(title: "Button", action: Message()))
    }

    func testButtonChangeTitle() {
        snapshot(
            .button(title: "Foo", action: Message()),
            .button(title: "Button", action: Message())
        )
    }

    func testCustomBackgroundColor() {
        snapshot(
            .custom(
                backgroundColor: .lightGray,
                .label(text: "Label")
            ) { view, label -> Set<Constraint> in
                [
                    view.width == 200,
                    view.height == 50,
                    label.centerX == view.centerX,
                    label.centerY == view.centerY,
                ]
            }
        )
    }

    func testCustomHeightWidthCenter() {
        snapshot(
            .custom(.label(text: "Label")) { view, label -> Set<Constraint> in
                [
                    view.width == 200,
                    view.height == 50,
                    label.centerX == view.centerX,
                    label.centerY == view.centerY,
                ]
            }
        )
    }

    func testImage() {
        let image = UIImage(named: "elm-lang")!
        snapshot(.image(image))
    }

    func testLabel() {
        snapshot(.label(text: "Label"))
    }

    func testLabelNumberOfLines() {
        snapshot(
            .label(numberOfLines: 0, text: "Foo Bar Baz"),
            width: 40
        )
    }

    func testLabelChangeText() {
        snapshot(
            .label(text: "Foo"),
            .label(text: "Label")
        )
    }

    func testLabelTextAlignment() {
        snapshot(
            .label(text: "Label", textAlignment: .center),
            width: 200
        )
    }

    func testLabelTextColor() {
        snapshot(.label(text: "Label", textColor: .red))
    }

    func testLabelChangeTextColor() {
        snapshot(
            .label(text: "Label"),
            .label(text: "Label", textColor: .red)
        )
    }

    func testLabelFont() {
        snapshot(.label(text: "Label", font: .boldSystemFont(ofSize: 20)))
    }

    func testLabelChangeFont() {
        snapshot(
            .label(text: "Label"),
            .label(text: "Label", font: .boldSystemFont(ofSize: 20))
        )
    }

    func testStackHorizontal() {
        snapshot(UI.stack([.label(text: "First"), .label(text: "Second")], axis: .horizontal))
    }

    func testStackChangeAxis() {
        let label1: UI<Message> = .label(text: "First")
        let label2: UI<Message> = .label(text: "Second")
        snapshot(
            UI.stack([label1, label2], axis: .horizontal),
            UI.stack([label1, label2], axis: .vertical)
        )
    }

    func testStackVertical() {
        snapshot(UI.stack([.label(text: "First"), .label(text: "Second")], axis: .vertical))
    }
}
