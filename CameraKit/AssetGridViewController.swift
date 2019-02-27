
import Photos
import PhotosUI
import UIKit

class AssetGridViewController: UIViewController, ViewStylePreparing {

    var fetchResult: PHFetchResult<PHAsset>!
    var gridView: UICollectionView!
    var cellWidth: CGFloat = 0
    private var assetManager: AssetManaging!

    var doneButton: UIBarButtonItem!

    fileprivate var thumbnailSize: CGSize!

    public weak var publicAssetPickerDelegate: AssetPickerDelegate?
    weak var internalAssetManagerDelegate: AssetManagerDelegate?

    func configure(assetManager: AssetManaging) {
        self.assetManager = assetManager
        self.assetManager.delegate = self
    }

    private func updateDoneButtonIfNeeded() {
        doneButton?.isEnabled = !assetManager.assets.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let layout = getGridViewLayout()
        gridView.collectionViewLayout = layout
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: cellWidth * scale, height: cellWidth * scale)
    }

    func setupColors() {
        view.backgroundColor = .white
        gridView.backgroundColor = view.backgroundColor
    }

    func setupViews() {
        setupNavigationButtons()
        setupGridView()
        updateDoneButtonIfNeeded()
    }

    private func setupNavigationButtons() {
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc
    func done() {
        let phAssets = assetManager.finalizeAndClearAssets().compactMap {$0 as? PHAsset }
        publicAssetPickerDelegate?.assetPickerDidFinishPickingAssets(phAssets)
        dismiss(animated: true, completion: nil)
    }

    private func setupGridView() {
        let layout = getGridViewLayout()
        gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridView.delegate = self
        gridView.dataSource = self
        gridView.registerNib(AssetGridCollectionViewCell.self)
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func getGridViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let columnCount: CGFloat = 3
        cellWidth = view.bounds.width / columnCount
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }

}

extension AssetGridViewController: AssetManagerDelegate {

    func assetManager(_ assetManager: AssetManaging, didSelectAssets: [SelectableAsset]) {
        updateDoneButtonIfNeeded()
    }
}

extension AssetGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {

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
        if assetCollectionViewCell.isSelected {
            assetManager.addAsset(asset)
        } else {
            assetManager.removeAssetIfNeeded(withID: asset.id)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let assetCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetGridCollectionViewCell.identifier, for: indexPath) as? AssetGridCollectionViewCell else { fatalError("Cannot dequeue AssetGridCollectionViewCell")}
        let asset = fetchResult.object(at: indexPath.item)
        let shouldSelect = assetManager.containsAsset(asset)
        assetCollectionViewCell.configure(asset: asset, imageSize: thumbnailSize, isSelected: shouldSelect)
        return assetCollectionViewCell
    }

}
