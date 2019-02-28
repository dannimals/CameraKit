
import PhotosUI
import UIKit

protocol CameraAssetPickerDataProviding:  UITableViewDataSource {

    var assetManager: AssetManaging { get }
    var hasAssets: Bool { get }
    var finalizedAssets: [PHAsset] { get }

    func resetAssets()
    func collectionForIndexPath(_ indexPath: IndexPath) -> PHAssetCollection?

}

class CameraAssetPickerDataSource: NSObject, CameraAssetPickerDataProviding {

    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections

        static let count = 3
    }

    var hasAssets: Bool {
        return !assetManager.assets.isEmpty
    }

    var finalizedAssets: [PHAsset] {
        return assetManager.finalizeAndClearAssets().compactMap { $0 as? PHAsset }
    }

    func resetAssets() {
        _ = assetManager.finalizeAndClearAssets()
    }

    var allPhotos: PHFetchResult<PHAssetCollection>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    let assetManager: AssetManaging

    let sectionLocalizedTitles = ["All Photos", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]

    init(assetManager: AssetManaging = AssetManager()) {
        self.assetManager = assetManager
        super.init()
        setupFetches()
    }

    func collectionForIndexPath(_ indexPath: IndexPath) -> PHAssetCollection? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        switch section {
        case .allPhotos:
            return allPhotos.object(at: indexPath.row)
        case .smartAlbums:
            return smartAlbums.object(at: indexPath.row)
        case .userCollections:
            return userCollections.object(at: indexPath.row) as? PHAssetCollection
        }
    }

    private func setupFetches() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }
}

extension CameraAssetPickerDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section), let cell = tableView.dequeueReusableCell(withIdentifier: AssetListTableViewCell.identifier) as? AssetListTableViewCell else { fatalError("Invalid section raw value") }
        switch section {
        case .allPhotos:
            cell.configure(title: NSLocalizedString("All Photos", comment: ""))
            //            if collection.estimatedAssetCount > 0 && collection.estimatedAssetCount != NSNotFound {
            //                let asset = PHAsset.fetchAssets(in: collection, options: nil).object(at: 0)
            //                PHCachingImageManager.default().requestImage(for: asset, targetSize: cell.imageSize, contentMode: .aspectFill, options: nil) { (image, _) in
            //                    cell.imageView?.image = image
            //                }
        //            }
        case .smartAlbums:
            let collection = smartAlbums.object(at: indexPath.row)
            cell.configure(title: collection.localizedTitle)
        case .userCollections:
            let collection = userCollections.object(at: indexPath.row)
            cell.configure(title: collection.localizedTitle)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitles[section]
    }

}
