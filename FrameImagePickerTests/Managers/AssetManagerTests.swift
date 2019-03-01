
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class AssetManagerTests: XCTestCase {

    let delegate = AssetManagerDelegateMock()
    lazy var assetManager: AssetManaging = {
        let assetManager = AssetManager()
        assetManager.delegate = delegate
        return assetManager
    }()

    func testDelegateSet() {
        XCTAssertNotNil(assetManager.delegate)
    }

    func testAddAsset() {
        let addedAsset = SelectableAssetMock.generate()
        assetManager.addAsset(addedAsset)
        XCTAssertTrue(assetManager.assets.count == 1)
        XCTAssertTrue(delegate.selectedAssets.count == 1)
    }

    func testContainsAsset() {
        let addedAsset = SelectableAssetMock.generate()
        assetManager.addAsset(addedAsset)
        XCTAssertTrue(assetManager.containsAsset(addedAsset))
    }

    func testFinalizeAndClearAssets() {
        let addedAsset = SelectableAssetMock.generate()
        assetManager.addAsset(addedAsset)
        let asset = assetManager.finalizeAndClearAssets()
        XCTAssertEqual(addedAsset.id, asset.first?.id)
        XCTAssertTrue(assetManager.assets.isEmpty)
    }

    func testRemoveAssetIfNeeded() {
        let addedAsset = SelectableAssetMock.generate()
        assetManager.addAsset(addedAsset)
        XCTAssertTrue(!assetManager.assets.isEmpty)
        assetManager.removeAssetIfNeeded(withID: addedAsset.id)
        XCTAssertTrue(assetManager.assets.isEmpty)
    }

    func testComputedProperties() {
        let addedAsset = SelectableAssetMock.generate()
        assetManager.addAsset(addedAsset)
        XCTAssertEqual(assetManager.assetDescription, "1 item selected")
        XCTAssertTrue(assetManager.assets.count == 1)
        assetManager.addAsset(SelectableAssetMock.generate())
        XCTAssertEqual(assetManager.assetDescription, "2 items selected")
    }

}
