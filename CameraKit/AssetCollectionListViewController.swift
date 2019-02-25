
import Photos
import PhotosUI
import UIKit

class AssetCollectionListViewController: UIViewController {

    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections

        static let count = 3
    }

    enum SegueIdentifier: String {
        case showAllPhotos
        case showCollection
    }

    let assetListView = UITableView()

    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButtons()
        setupFetches()

    }

    private func setupFetches() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
    }

    private func setupNavigationButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
    }

    @objc
    func cancel() {
        dismiss(animated: true, completion: nil)
    }

}
