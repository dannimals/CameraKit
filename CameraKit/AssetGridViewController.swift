
import Photos
import PhotosUI
import UIKit

class AssetGridViewController: UIViewController, ViewStylePreparing {

    public weak var cameraAssetPickerDelegate: CameraAssetPickerDelegate?
    weak var assetManagerDelegate: AssetManagerDelegate?

    private var gridView: UICollectionView!
    private var doneButton: UIBarButtonItem!
    private var dataSource: AssetGridDataSource!

    func configure(dataSource: AssetGridDataSource) {
        self.dataSource = dataSource
        dataSource.assetManager.delegate = self
    }

    private func updateDoneButtonIfNeeded() {
        doneButton?.isEnabled = dataSource.hasAssets
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let layout = getGridViewLayout()
        gridView.collectionViewLayout = layout
    }

    func setupColors() {
        view.backgroundColor = .customBlack
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
        cameraAssetPickerDelegate?.assetPickerDidFinishPickingAssets(dataSource.finalizedAssets)
        dismiss(animated: true, completion: nil)
    }

    private func setupGridView() {
        let layout = getGridViewLayout()
        gridView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        gridView.registerNib(AssetGridCollectionViewCell.self)
        gridView.dataSource = dataSource
        gridView.delegate = dataSource
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
        let cellWidth = view.bounds.width / columnCount
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
