
import Photos
import UIKit

protocol AssetGridDataProviding: UICollectionViewDataSource, UICollectionViewDelegate {

    var delegate: AssetManagerDelegate? { get set }

    var assetDescription: String? { get }
    var hasAssets: Bool { get }
    var finalizedAssets: [PHAsset] { get }

}

class AssetGridDataSource: NSObject, AssetGridDataProviding {

    let fetchResult: PHFetchResult<PHAsset>!
    var assetManager: AssetManaging

    var assetDescription: String? { return assetManager.assetDescription }
    var hasAssets: Bool { return !assetManager.assets.isEmpty }
    var finalizedAssets: [PHAsset] {
        return assetManager.finalizeAndClearAssets().compactMap { $0 as? PHAsset }
    }

    weak var delegate: AssetManagerDelegate? {
        didSet {
            assetManager.delegate = delegate
        }
    }

    init(assetCollection: PHAssetCollection, assetManager: AssetManaging) {
        let dateSortOption = PHFetchOptions()
        dateSortOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: dateSortOption)
        self.assetManager = assetManager
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let assetCollectionViewCell = collectionView.cellForItem(at: indexPath) as? AssetGridCollectionViewCell else { return }
        assetCollectionViewCell.toggleSelection()
        let asset = fetchResult.object(at: indexPath.item)
        assetCollectionViewCell.isSelected ? assetManager.addAsset(asset) : assetManager.removeAssetIfNeeded(withID: asset.id)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let assetCollectionViewCell: AssetGridCollectionViewCell = collectionView.dequeueCell(forIndexPath: indexPath)
        let asset = fetchResult.object(at: indexPath.item)
        let shouldSelect = assetManager.containsAsset(asset)
        assetCollectionViewCell.configure(asset: asset, isSelected: shouldSelect)
        return assetCollectionViewCell
    }

}
