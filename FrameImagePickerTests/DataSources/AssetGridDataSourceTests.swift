
import Foundation
import PhotosUI
import XCTest
@testable import FrameImagePicker

class AssetGridDataSourceTests: XCTestCase {

    lazy var assetGridDataSource: AssetGridDataSource = {
        let collection = PHAssetCollection()
        let assetManagerMock = AssetManagerMock()
        let assetManagerDelegate = AssetManagerDelegateMock()
        let assetGridDataSource = AssetGridDataSource(assetCollection: collection, assetManager: assetManagerMock)
        assetGridDataSource.delegate = assetManagerDelegate
        return assetGridDataSource
    }()

    func testInitializer() {
        XCTAssertNotNil(assetGridDataSource.assetManager)
        XCTAssertNotNil(assetGridDataSource.assetDescription)
        XCTAssertFalse(assetGridDataSource.hasAssets)
        XCTAssertTrue(assetGridDataSource.finalizedAssets.isEmpty)
        XCTAssertNotNil(assetGridDataSource.fetchResult)
        XCTAssertNotNil(assetGridDataSource.delegate)
        XCTAssertNotNil(assetGridDataSource.assetManager.delegate)
    }

    func testNumberOfSections() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let sections = assetGridDataSource.numberOfSections(in: collectionView)
        XCTAssertEqual(sections, 1)
    }

    func testNumberOfItems() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let items = assetGridDataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(items, 0)
    }

    func testCellForIndexPath() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.registerNib(AssetGridCollectionViewCell.self)
        let cell = assetGridDataSource.collectionView(collectionView, cellForItemAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
    }

}
