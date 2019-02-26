
import Photos
import PhotosUI
import UIKit

class AssetGridViewController: UIViewController {

    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!

    var gridView: UICollectionView!
    var cellWidth: CGFloat = 0

    private let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGridView()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let layout = getGridViewLayout()
        gridView.collectionViewLayout = layout
        let scale = UIScreen.main.scale
        thumbnailSize = CGSize(width: cellWidth * scale, height: cellWidth * scale)
    }

    private func setup() {
        view.backgroundColor = .white
        gridView.backgroundColor = view.backgroundColor
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
        let columnCount: CGFloat = 4
        cellWidth = view.bounds.width / columnCount
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }

}

extension AssetGridViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let assetCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetGridCollectionViewCell.identifier, for: indexPath) as? AssetGridCollectionViewCell else { fatalError("Cannot dequeue AssetGridCollectionViewCell")}
        let asset = fetchResult.object(at: indexPath.item)
        if asset.mediaSubtypes.contains(.photoLive) {
            assetCollectionViewCell.configure(image: PHLivePhotoView.livePhotoBadgeImage(options: .overContent))
        }
        assetCollectionViewCell.assetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if assetCollectionViewCell.assetIdentifier == asset.localIdentifier {
                assetCollectionViewCell.configure(image: image)
            }
        })
        return assetCollectionViewCell
    }

}
