
import Foundation
import XCTest
@testable import FrameImagePicker

class ViewStylePreparingTests: XCTestCase {

    class TestView: UIView, ViewStylePreparing {
        var setupCalled = false
        func setupViews() {
            setupCalled = true
        }
    }

    let testView = TestView()

    func testSetup() {
        XCTAssertFalse(testView.setupCalled)
        testView.setup()
        XCTAssertTrue(testView.setupCalled)
    }

}
