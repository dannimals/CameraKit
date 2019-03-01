
import Foundation
import XCTest
@testable import FrameImagePicker

class UITableViewAdditionTests: XCTestCase {

    let tableView = UITableView()

    func testRegisterCell() {
        tableView.registerCell(AlbumListTableViewCell.self)
        let albumListTableViewCell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableViewCell.identifier)
        XCTAssertNotNil(albumListTableViewCell)
    }

    func testRegisterNib() {
        tableView.registerNib(AlbumListTableViewCell.self)
        let albumListTableViewCell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableViewCell.identifier)
        XCTAssertNotNil(albumListTableViewCell)
    }

    func testDequeueCell() {
        tableView.registerNib(AlbumListTableViewCell.self)
        let albumListTableViewCell: AlbumListTableViewCell = tableView.dequeueCell(forIndexPath: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(albumListTableViewCell)
    }

}
