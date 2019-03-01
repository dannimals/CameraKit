
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class ImagePickerDataSourceTests: XCTestCase {

    let assetManager = AssetManagerMock()
    lazy var imagePickerDataSource: ImagePickerDataSource = {
        return ImagePickerDataSource(assetManager: assetManager)
    }()

    func testProperties() {
        XCTAssertEqual(ImagePickerDataSource.Section.count, 3)
        XCTAssertEqual(imagePickerDataSource.smartAlbums.count, 5)
        XCTAssertNotNil(imagePickerDataSource.assetManager)
        XCTAssertNotNil(imagePickerDataSource.allPhotos)
        XCTAssertNotNil(imagePickerDataSource.userCollections)
        XCTAssertEqual(imagePickerDataSource.sectionLocalizedTitles.count, 3)
        XCTAssertEqual(imagePickerDataSource.assetDescription, "test")
        XCTAssertTrue(imagePickerDataSource.finalizedAssets.isEmpty)
    }

    func testResetAssets() {
        imagePickerDataSource.resetAssets()
        XCTAssertTrue(assetManager.didClearAssets)
    }

    func testCollectionForIndexPath() {
        let collection = imagePickerDataSource.collectionForIndexPath(IndexPath(item: 0, section: 0))
        XCTAssertNotNil(collection)
    }

    func testNumberOfSections() {
        let sections = imagePickerDataSource.numberOfSections(in: UITableView())
        XCTAssertEqual(sections, 2)
    }

    func testNumberOfRowsInSection() {
        let section0Rows = imagePickerDataSource.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertEqual(section0Rows, 1)
        let section1Rows = imagePickerDataSource.tableView(UITableView(), numberOfRowsInSection: 1)
        XCTAssertEqual(section1Rows, imagePickerDataSource.smartAlbums.count)
    }

    func testsCellForRow() {
        let tableView = UITableView()
        tableView.registerNib(AlbumListTableViewCell.self)
        let cell = imagePickerDataSource.tableView(tableView, cellForRowAt: IndexPath(item: 0, section: 0))
        XCTAssertTrue(cell is AlbumListTableViewCell)
    }

}
