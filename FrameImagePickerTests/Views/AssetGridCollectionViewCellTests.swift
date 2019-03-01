
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class AssetGridCollectionViewCellTests: XCTestCase {

    let assetGridCell = AssetGridCollectionViewCell.instantiateFromNib()
    let asset = SelectableAssetMock.generate()

    func testPrepareForReuse() {
        XCTAssertNotNil(assetGridCell.imageView)
        XCTAssertNotNil(assetGridCell.selectionBubble)
        assetGridCell.prepareForReuse()
        XCTAssertNil(assetGridCell.imageView.image)
        XCTAssertFalse(assetGridCell.selectionBubble.isSelected)
    }

    func testConfigure() {
        assetGridCell.configure(asset: asset, isSelected: true)
        XCTAssertTrue(assetGridCell.selectionBubble.isSelected)
        XCTAssertNil(assetGridCell.imageView.image)
        XCTAssertEqual(assetGridCell.contentView.backgroundColor, .customBlack)
        XCTAssertEqual(assetGridCell.imageView.contentMode, .scaleAspectFill)
    }

    func testToggleSelection() {
        assetGridCell.layoutIfNeeded()
        assetGridCell.toggleSelection()
        XCTAssertTrue(assetGridCell.selectionBubble.isSelected)
        assetGridCell.toggleSelection()
        XCTAssertFalse(assetGridCell.selectionBubble.isSelected)
    }

}
