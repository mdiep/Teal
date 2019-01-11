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
    func testLabelAccessibilityIdentifier() {
        let view = Teal.View<Message>(.label([.accessibilityIdentifier("Bar")], text: "Foo"))

        XCTAssertEqual(view.subviews[0].accessibilityIdentifier, "Bar")

        view.ui = .label([], text: "Foo")

        XCTAssertNil(view.subviews[0].accessibilityIdentifier)
    }
}

extension UI {
    fileprivate static func square(_ color: UIColor = .gray) -> UI {
        return UI.custom([.backgroundColor(color)]) { view in
            [view.height == 20, view.width == 20]
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
            ) { view, a -> Set<Constraint> in
                [
                    view.top == a.top,
                    view.bottom == a.bottom,
                    view.leading == a.leading,
                    view.trailing == a.trailing,
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
                let constraints: Set<Constraint> = [
                    view.top == a.top,
                    view.bottom == a.bottom,
                    view.leading == a.leading,
                    b.leading == a.trailing + 5,
                    view.top == b.top,
                    view.bottom == b.bottom,
                    view.trailing == b.trailing,
                ]
                return constraints
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
                let constraints: Set<Constraint> = [
                    view.top == a.top,
                    view.bottom == a.bottom,
                    view.leading == a.leading,
                    b.leading == a.trailing + 5,
                    view.top == b.top,
                    view.bottom == b.bottom,
                    c.leading == b.trailing + 5,
                    view.top == c.top,
                    view.bottom == c.bottom,
                    view.trailing == c.trailing,
                ]
                return constraints
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
                let constraints: Set<Constraint> = [
                    view.top == a.top,
                    view.bottom == a.bottom,
                    view.leading == a.leading,
                    b.leading == a.trailing + 5,
                    view.top == b.top,
                    view.bottom == b.bottom,
                    c.leading == b.trailing + 5,
                    view.top == c.top,
                    view.bottom == c.bottom,
                    d.leading == c.trailing + 5,
                    view.top == d.top,
                    view.bottom == d.bottom,
                    view.trailing == d.trailing,
                ]
                return constraints
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
                let vertical: Set<Constraint> = [
                    view.top == a.top,
                    view.bottom == a.bottom,
                    view.top == b.top,
                    view.bottom == b.bottom,
                    view.top == c.top,
                    view.bottom == c.bottom,
                    view.top == d.top,
                    view.bottom == d.bottom,
                    view.top == e.top,
                    view.bottom == e.bottom,
                ]
                var horizontal: Set<Constraint> = []
                horizontal.insert(view.leading == a.leading)
                horizontal.insert(b.leading == a.trailing + 5)
                horizontal.insert(c.leading == b.trailing + 5)
                horizontal.insert(d.leading == c.trailing + 5)
                horizontal.insert(e.leading == d.trailing + 5)
                horizontal.insert(view.trailing == e.trailing)
                return vertical.union(horizontal)
            }
        )
    }

    func testCustomBackgroundColor() {
        snapshot(
            .custom(
                [.backgroundColor(.lightGray)],
                .label([], text: "Label")
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
            .custom([], .label([], text: "Label")) { view, label -> Set<Constraint> in
                [
                    view.width == 200,
                    view.height == 50,
                    label.centerX == view.centerX,
                    label.centerY == view.centerY,
                ]
            }
        )
    }

    func testCustomTopBottomLeadingTrailing() {
        snapshot(
            .custom([], .label([], text: "Label")) { view, label -> Set<Constraint> in
                [
                    label.top == view.top,
                    label.bottom == view.bottom,
                    label.leading == view.leading,
                    label.trailing == view.trailing,
                ]
            }
        )
    }

    func testCustomTopBottomLeadingTrailingOffset() {
        snapshot(
            .custom([.backgroundColor(.white)], .square()) { view, square -> Set<Constraint> in
                let a = square.top == view.top + 5
                return [
                    a,
                    square.bottom == view.bottom - 5,
                    square.leading == view.leading + 5,
                    square.trailing == view.trailing - 5,
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
}
