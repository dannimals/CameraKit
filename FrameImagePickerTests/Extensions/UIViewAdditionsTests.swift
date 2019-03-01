
import Foundation
import XCTest
@testable import FrameImagePicker

class UIViewAdditionsTests: XCTestCase {

    func testIdentifier() {
        let identifier = AlbumListTableViewCell.identifier
        XCTAssertEqual(identifier, "AlbumListTableViewCell")
    }

    func testInstantiateFromNib() {
        let albumListCell = AlbumListTableViewCell.instantiateFromNib()
        XCTAssertEqual(AlbumListTableViewCell.nibName, "AlbumListTableViewCell")
        XCTAssertNotNil(albumListCell)
    }

}
