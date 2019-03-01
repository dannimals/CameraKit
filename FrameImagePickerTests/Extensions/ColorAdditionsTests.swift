
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class ColorAdditionsTests: XCTestCase {

    func testInit() {
        let testColor = Color(redValue: 184, greenValue: 193, blueValue: 207)
        XCTAssertEqual(Color.gray300, testColor)
    }

}
