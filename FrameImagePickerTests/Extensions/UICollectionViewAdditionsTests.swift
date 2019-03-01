
import Foundation
import XCTest
@testable import FrameImagePicker

class UICollectionViewAdditionTests: XCTestCase {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let frame = CGRect(origin: .zero, size: CGSize(width: 2, height: 2))
        return UICollectionView(frame: frame, collectionViewLayout: layout)
    }()

    func testRegisterCell() {
        collectionView.registerCell(AssetGridCollectionViewCell.self)
        let assetGridCollectionViewCell: AssetGridCollectionViewCell = collectionView.dequeueCell(forIndexPath: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(assetGridCollectionViewCell)
    }

    func testRegisterNib() {
        collectionView.registerNib(AssetGridCollectionViewCell.self)
        let assetGridCollectionViewCell: AssetGridCollectionViewCell = collectionView.dequeueCell(forIndexPath: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(assetGridCollectionViewCell)
    }

    func testDequeueCell() {
        collectionView.registerNib(AssetGridCollectionViewCell.self)
        let assetGridCollectionViewCell: AssetGridCollectionViewCell = collectionView.dequeueCell(forIndexPath: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(assetGridCollectionViewCell)
    }

}
