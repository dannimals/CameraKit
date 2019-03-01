
import Foundation
import XCTest
@testable import FrameImagePicker

class UIViewAdditionsTests: XCTestCase {

    func testIdentifier() {
        let identifier = AlbumListTableViewCell.identifier
        XCTAssertEqual(identifier, "AlbumListTableViewCell")
    }

}
