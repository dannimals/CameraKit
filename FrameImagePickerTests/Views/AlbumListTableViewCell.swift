
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class AlbumListTableViewCellTests: XCTestCase {

    let albumListCell = AlbumListTableViewCell.instantiateFromNib()
    let asset = SelectableAssetMock.generate()
    let assetCollection = PHAssetCollection()

    func testOutlets() {
        XCTAssertNotNil(albumListCell.imageView)
        XCTAssertNotNil(albumListCell.titleLabel)
        XCTAssertNotNil(albumListCell.albumImageView)
        XCTAssertNotNil(albumListCell.emptyAlbumView)
        XCTAssertNotNil(albumListCell.dividerLine)
        XCTAssertNotNil(albumListCell.itemCountLabel)
    }

    func testImageSize() {
        XCTAssertEqual(albumListCell.imageSize, albumListCell.albumImageView.bounds.size)
    }

    func testSetup() {
        XCTAssertEqual(albumListCell.albumImageView.contentMode, .scaleAspectFill)
        XCTAssertEqual(albumListCell.albumImageView.layer.cornerRadius, 6)
        XCTAssertTrue(albumListCell.clipsToBounds)
        XCTAssertEqual(albumListCell.contentView.backgroundColor, .customBlack)
        XCTAssertEqual(albumListCell.dividerLine.backgroundColor, .gray900)
        XCTAssertEqual(albumListCell.titleLabel.textColor, .customWhite)
        XCTAssertEqual(albumListCell.itemCountLabel.textColor, .gray400)
        XCTAssertEqual(albumListCell.albumImageView.backgroundColor, .customGrey)
        XCTAssertEqual(albumListCell.emptyAlbumView.tintColor, .gray400)
        XCTAssertNotNil(albumListCell.selectedBackgroundView)
    }
    func testPrepareForReuse() {
        albumListCell.prepareForReuse()
        XCTAssertNil(albumListCell.albumImageView.image)
        XCTAssertNil(albumListCell.titleLabel.text)
        XCTAssertFalse(albumListCell.emptyAlbumView.isHidden)
        XCTAssertNil(albumListCell.itemCountLabel.text)
    }

    func testConfigure() {
        albumListCell.configure(collection: assetCollection, isAllPhotos: true)
        XCTAssertEqual(albumListCell.titleLabel.text, "All Photos")
        XCTAssertEqual(albumListCell.itemCountLabel.text, "0 items")
    }

    func testSetImage() {
        albumListCell.setImage(forAsset: PHAsset())
        XCTAssertFalse(albumListCell.emptyAlbumView.isHidden)
    }

    func testSetHighlightedSelected() {
        albumListCell.setHighlighted(true, animated: false)
        XCTAssertEqual(albumListCell.albumImageView.backgroundColor, .customGrey)
        albumListCell.setSelected(true, animated: false)
        XCTAssertEqual(albumListCell.albumImageView.backgroundColor, .customGrey)
    }

}
