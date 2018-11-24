import SnapshotTesting
import Teal
import XCTest

private struct Message: Equatable {}

final class ViewSnapshotTests: XCTestCase {
    fileprivate func snapshot(
        _ ui: UI<Message>,
        file: StaticString = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        let view = View(ui)
        view.frame.size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        assertSnapshot(matching: view, file: file, function: function, line: line)
    }

    func testButton() {
        snapshot(.button(title: "Button", action: Message()))
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

    func testLabel() {
        snapshot(.label(text: "Label"))
    }

    func testLabelTextColor() {
        snapshot(.label(text: "Label", textColor: .red))
    }

    func testLabelFont() {
        snapshot(.label(text: "Label", font: .boldSystemFont(ofSize: 20)))
    }

    func testStackHorizontal() {
        snapshot(UI.stack([.label(text: "First"), .label(text: "Second")], axis: .horizontal))
    }

    func testStackVertical() {
        snapshot(UI.stack([.label(text: "First"), .label(text: "Second")], axis: .vertical))
    }
}
