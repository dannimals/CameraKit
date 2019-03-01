
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class PhAssetAdditionsTests: XCTestCase {

    let testAsset = PHAsset()

    func testProperties() {
        XCTAssertEqual(testAsset.localIdentifier, testAsset.id)
    }

}
