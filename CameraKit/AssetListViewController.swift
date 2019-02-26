
import Photos
import PhotosUI
import UIKit

class AssetListViewController: UIViewController {

    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections

        static let count = 3
    }

    let assetTableView = UITableView()
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]

    var allPhotos: PHFetchResult<PHAssetCollection>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationButtons()
        setupFetches()
        setupTableView()
    }

    private func setupTableView() {
        assetTableView.delegate = self
        assetTableView.dataSource = self
        assetTableView.registerNib(AssetListTableViewCell.self)
        view.addSubview(assetTableView)
        assetTableView.translatesAutoresizingMaskIntoConstraints = false
        assetTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        assetTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        assetTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        assetTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupFetches() {
//        let allPhotosOptions = PHFetchOptions()
//        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
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

extension AssetListViewController: UITableViewDataSource, UITableViewDelegate {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { fatalError("Invalid cell selection") }
        let assetGridViewController = AssetGridViewController()
        let collection: PHCollection
        switch section {
        case .allPhotos:
            collection = allPhotos.object(at: indexPath.row)
        case .smartAlbums:
            collection = smartAlbums.object(at: indexPath.row)
        case .userCollections:
            collection = userCollections.object(at: indexPath.row)
        }
        guard let assetCollection = collection as? PHAssetCollection else { return }
        assetGridViewController.fetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
        assetGridViewController.assetCollection = assetCollection
        navigationController?.pushViewController(assetGridViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section), let cell = tableView.dequeueReusableCell(withIdentifier: AssetListTableViewCell.identifier) as? AssetListTableViewCell else { fatalError("Invalid section raw value") }
        switch section {
        case .allPhotos:
            cell.configure(title: NSLocalizedString("All Photos", comment: ""))
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
