@testable import Teal
import XCTest

final class TargetTests: XCTestCase {
    func testUIButtonTouchUpInside() {
        var done = false
        let button = UIButton()
        button.touchUpInside = { done = true }
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(done)
    }
    
    func testUIButtonTouchUpInsideReset() {
        var done = false
        let button = UIButton()
        button.touchUpInside = { done = true }
        button.touchUpInside = { }
        
        button.sendActions(for: .touchUpInside)
        
        XCTAssertFalse(done)
    }
}
