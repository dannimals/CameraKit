
import PhotosUI
import UIKit

protocol CameraAssetPickerDataProviding:  UITableViewDataSource {

    var assetManager: AssetManaging { get }
    var hasAssets: Bool { get }
    var finalizedAssets: [PHAsset] { get }
    var sectionLocalizedTitles: [String] { get }

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

    var allPhotos: PHFetchResult<PHAssetCollection>!
    var smartAlbums: [PHAssetCollection] = []
    var userCollections: PHFetchResult<PHCollection>!
    let assetManager: AssetManaging
    let sectionLocalizedTitles = ["All Photos", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]

    var hasAssets: Bool {
        return !assetManager.assets.isEmpty
    }

    var finalizedAssets: [PHAsset] {
        return assetManager.finalizeAndClearAssets().compactMap { $0 as? PHAsset }
    }

    init(assetManager: AssetManaging = AssetManager()) {
        self.assetManager = assetManager
        super.init()
        setupFetches()
    }

    func resetAssets() {
        _ = assetManager.finalizeAndClearAssets()
    }

    func collectionForIndexPath(_ indexPath: IndexPath) -> PHAssetCollection? {
        guard let section = Section(rawValue: indexPath.section) else { return nil }
        switch section {
        case .allPhotos: return allPhotos[indexPath.row]
        case .smartAlbums: return smartAlbums[indexPath.row]
        case .userCollections: return userCollections[indexPath.row] as? PHAssetCollection
        }
    }

    private func setupFetches() {
        let endDateSort = PHFetchOptions()
        endDateSort.sortDescriptors = [NSSortDescriptor(key: "endDate", ascending: true)]
        allPhotos = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        smartAlbums = filteredSmartAlbums()
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }

    private func filteredSmartAlbums() -> [PHAssetCollection] {
        let filterAlbumTypes: [PHAssetCollectionSubtype] = [.smartAlbumRecentlyAdded, .smartAlbumVideos, .smartAlbumFavorites,
                                                            .smartAlbumScreenshots, .smartAlbumSelfPortraits]
        let allSmartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        var smartAlbums = [PHAssetCollection]()
        allSmartAlbums.enumerateObjects { (album, _, _) in
            guard filterAlbumTypes.contains(album.assetCollectionSubtype) else { return }
            smartAlbums.append(album)
        }
        return smartAlbums
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
        guard let assetCollection = collectionForIndexPath(indexPath), let assetListCell = tableView.dequeueReusableCell(withIdentifier: AssetListTableViewCell.identifier) as? AssetListTableViewCell else { fatalError("Invalid section raw value") }
        let isAllPhotos = indexPath.section == 0
        assetListCell.configure(collection: assetCollection, isAllPhotos: isAllPhotos)
        return assetListCell
    }

}
