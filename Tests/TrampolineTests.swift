@testable import Teal
import XCTest

final class TrampolineTests: XCTestCase {
    func testUIControlSetBlockForEvent() {
        var done = false
        let button = UIButton()
        button.setBlock(for: .touchUpInside) { done = true }

        button.sendActions(for: .touchUpInside)

        XCTAssertTrue(done)
    }

    func testUIButtonTouchUpInsideReset() {
        var done = false
        let button = UIButton()
        button.setBlock(for: .touchUpInside) { done = true }
        button.setBlock(for: .touchUpInside) {}

        button.sendActions(for: .touchUpInside)

        XCTAssertFalse(done)
    }
}
