import SnapshotTesting
import Teal
import XCTest

// swiftlint:disable force_cast

private struct Message: Equatable {}

final class ViewPerformTests: XCTestCase {
    func testButton() {
        var message: Message?
        let ui = UI<Message>.button([.onTouchUpInside(Message())], title: "")
        let view = View(ui) { message = $0 }
        let button = view.subviews[0] as! UIButton
        button.sendActions(for: .touchUpInside)
        XCTAssertNotNil(message)
    }
}

final class ViewPropertyTests: XCTestCase {
    private func makeView<View: UIView>(_ ui: UI<Message>) -> View {
        let view = Teal.View(ui) { _ in }
        return view.subviews[0] as! View // swiftlint:disable:this force_cast
    }

    func testAccessibilityIdentifier() {
        let view = Teal.View<Message>(.label([.accessibilityIdentifier("Bar")], text: "Foo"))

        XCTAssertEqual(view.subviews[0].accessibilityIdentifier, "Bar")

        view.ui = .label([], text: "Foo")

        XCTAssertNil(view.subviews[0].accessibilityIdentifier)
    }

    // MARK: - .textField

    func testTextFieldPlaceholder() {
        let view: UITextField = makeView(.textField([], placeholder: "Placeholder"))
        XCTAssertEqual(view.placeholder, "Placeholder")
    }

    func testTextFieldText() {
        let view: UITextField = makeView(.textField([], text: "Text"))
        XCTAssertEqual(view.text, "Text")
    }
}

extension UI {
    fileprivate static func square(_ color: UIColor = .gray) -> UI {
        return UI.custom([.backgroundColor(color)]) { view in
            [
                .equal(view.height, .const(20)),
                .equal(view.width, .const(20)),
            ]
        }
    }
}

final class ViewSnapshotTests: XCTestCase {
    private func snapshot(
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

    // MARK: - .button

    func testButton() {
        snapshot(.button([], title: "Button"))
    }

    func testButtonChangeTitle() {
        snapshot(
            .button([], title: "Foo"),
            .button([], title: "Button")
        )
    }

    // MARK: - .custom

    func testCustom0Subviews() {
        snapshot(.square())
    }

    func testCustom1Subview() {
        snapshot(
            .custom(
                [.backgroundColor(.lightGray)],
                .square()
            ) { view, a in
                [
                    .equal(view.top, .anchor(a.top)),
                    .equal(view.bottom, .anchor(a.bottom)),
                    .equal(view.leading, .anchor(a.leading)),
                    .equal(view.trailing, .anchor(a.trailing)),
                ]
            }
        )
    }

    func testCustom2Subviews() {
        snapshot(
            .custom(
                [.backgroundColor(.white)],
                .square(.red),
                .square(.orange)
            ) { view, a, b in
                [
                    .equal(view.top, .anchor(a.top)),
                    .equal(view.bottom, .anchor(a.bottom)),
                    .equal(view.leading, .anchor(a.leading)),
                    .equal(b.leading, .add(5, .anchor(a.trailing))),
                    .equal(view.top, .anchor(b.top)),
                    .equal(view.bottom, .anchor(b.bottom)),
                    .equal(view.trailing, .anchor(b.trailing)),
                ]
            }
        )
    }

    func testCustom3Subviews() {
        snapshot(
            .custom(
                [.backgroundColor(.white)],
                .square(.red),
                .square(.orange),
                .square(.yellow)
            ) { view, a, b, c in
                [
                    .equal(view.top, .anchor(a.top)),
                    .equal(view.bottom, .anchor(a.bottom)),
                    .equal(view.top, .anchor(b.top)),
                    .equal(view.bottom, .anchor(b.bottom)),
                    .equal(view.top, .anchor(c.top)),
                    .equal(view.bottom, .anchor(c.bottom)),
                    .equal(view.leading, .anchor(a.leading)),
                    .equal(b.leading, .add(5, .anchor(a.trailing))),
                    .equal(c.leading, .add(5, .anchor(b.trailing))),
                    .equal(view.trailing, .anchor(c.trailing)),
                ]
            }
        )
    }

    func testCustom4Subviews() {
        snapshot(
            .custom(
                [.backgroundColor(.white)],
                .square(.red),
                .square(.orange),
                .square(.yellow),
                .square(.blue)
            ) { view, a, b, c, d in
                [
                    .equal(view.top, .anchor(a.top)),
                    .equal(view.bottom, .anchor(a.bottom)),
                    .equal(view.top, .anchor(b.top)),
                    .equal(view.bottom, .anchor(b.bottom)),
                    .equal(view.top, .anchor(c.top)),
                    .equal(view.bottom, .anchor(c.bottom)),
                    .equal(view.top, .anchor(d.top)),
                    .equal(view.bottom, .anchor(d.bottom)),
                    .equal(view.leading, .anchor(a.leading)),
                    .equal(b.leading, .add(5, .anchor(a.trailing))),
                    .equal(c.leading, .add(5, .anchor(b.trailing))),
                    .equal(d.leading, .add(5, .anchor(c.trailing))),
                    .equal(view.trailing, .anchor(d.trailing)),
                ]
            }
        )
    }

    func testCustom5Subviews() {
        snapshot(
            .custom(
                [.backgroundColor(.white)],
                .square(.red),
                .square(.orange),
                .square(.yellow),
                .square(.blue),
                .square(.green)
            ) { view, a, b, c, d, e in
                [
                    .equal(view.top, .anchor(a.top)),
                    .equal(view.bottom, .anchor(a.bottom)),
                    .equal(view.top, .anchor(b.top)),
                    .equal(view.bottom, .anchor(b.bottom)),
                    .equal(view.top, .anchor(c.top)),
                    .equal(view.bottom, .anchor(c.bottom)),
                    .equal(view.top, .anchor(d.top)),
                    .equal(view.bottom, .anchor(d.bottom)),
                    .equal(view.top, .anchor(e.top)),
                    .equal(view.bottom, .anchor(e.bottom)),
                    .equal(view.leading, .anchor(a.leading)),
                    .equal(b.leading, .add(5, .anchor(a.trailing))),
                    .equal(c.leading, .add(5, .anchor(b.trailing))),
                    .equal(d.leading, .add(5, .anchor(c.trailing))),
                    .equal(e.leading, .add(5, .anchor(d.trailing))),
                    .equal(view.trailing, .anchor(e.trailing)),
                ]
            }
        )
    }

    func testCustomBackgroundColor() {
        snapshot(
            .custom(
                [.backgroundColor(.lightGray)],
                .label([], text: "Label")
            ) { view, label in
                [
                    .equal(view.width, .const(200)),
                    .equal(view.height, .const(50)),
                    .equal(label.centerX, .anchor(view.centerX)),
                    .equal(label.centerY, .anchor(view.centerY)),
                ]
            }
        )
    }

    func testCustomHeightWidthCenter() {
        snapshot(
            .custom([], .label([], text: "Label")) { view, label in
                [
                    .equal(view.width, .const(200)),
                    .equal(view.height, .const(50)),
                    .equal(label.centerX, .anchor(view.centerX)),
                    .equal(label.centerY, .anchor(view.centerY)),
                ]
            }
        )
    }

    func testCustomTopBottomLeadingTrailing() {
        snapshot(
            .custom([], .label([], text: "Label")) { view, label in
                [
                    .equal(label.top, .anchor(view.top)),
                    .equal(label.bottom, .anchor(view.bottom)),
                    .equal(label.leading, .anchor(view.leading)),
                    .equal(label.trailing, .anchor(view.trailing)),
                ]
            }
        )
    }

    func testCustomTopBottomLeadingTrailingOffset() {
        snapshot(
            .custom([.backgroundColor(.white)], .square()) { view, square in
                return [
                    .equal(square.top, .add(5, .anchor(view.top))),
                    .equal(square.bottom, .add(-5, .anchor(view.bottom))),
                    .equal(square.leading, .add(5, .anchor(view.leading))),
                    .equal(square.trailing, .add(-5, .anchor(view.trailing))),
                ]
            }
        )
    }

    // MARK: - .image

    func testImage() {
        let image = UIImage(named: "elm-lang")!
        snapshot(.image([], image))
    }

    // MARK: - .label

    func testLabel() {
        snapshot(.label([], text: "Label"))
    }

    func testLabelNumberOfLines() {
        snapshot(
            .label([], numberOfLines: 0, text: "Foo Bar Baz"),
            width: 40
        )
    }

    func testLabelChangeText() {
        snapshot(
            .label([], text: "Foo"),
            .label([], text: "Label")
        )
    }

    func testLabelTextAlignment() {
        snapshot(
            .label([], text: "Label", textAlignment: .center),
            width: 200
        )
    }

    func testLabelTextColor() {
        snapshot(.label([], text: "Label", textColor: .red))
    }

    func testLabelChangeTextColor() {
        snapshot(
            .label([], text: "Label"),
            .label([], text: "Label", textColor: .red)
        )
    }

    func testLabelFont() {
        snapshot(.label([], text: "Label", font: .boldSystemFont(ofSize: 20)))
    }

    func testLabelChangeFont() {
        snapshot(
            .label([], text: "Label"),
            .label([], text: "Label", font: .boldSystemFont(ofSize: 20))
        )
    }

    // MARK: - .stack

    func testStackHorizontal() {
        snapshot(
            UI.stack(
                [],
                [.label([], text: "First"), .label([], text: "Second")],
                axis: .horizontal
            )
        )
    }

    func testStackChangeAxis() {
        let label1: UI<Message> = .label([], text: "First")
        let label2: UI<Message> = .label([], text: "Second")
        snapshot(
            UI.stack([], [label1, label2], axis: .horizontal),
            UI.stack([], [label1, label2], axis: .vertical)
        )
    }

    func testStackVertical() {
        snapshot(
            UI.stack(
                [],
                [.label([], text: "First"), .label([], text: "Second")],
                axis: .vertical
            )
        )
    }

    // MARK: - .textField

    func testTextField() {
        snapshot(.textField([], text: "Foo"), width: 50)
    }
}
