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

    func testLabel() {
        snapshot(.label(text: "Label"))
    }
}
