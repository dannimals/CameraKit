
import Photos
import PhotosUI
import UIKit

class AssetGridCollectionViewCell: UICollectionViewCell, ViewStylePreparing {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionBubble: SelectionBubble!

    private let imageManager = PHCachingImageManager()
    
    private var assetIdentifier: String?
    private var asset: SelectableAsset?
    private var imageSize: CGSize?
    private var shouldSelect = false

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    private func reset() {
        asset = nil
        assetIdentifier = nil
        imageView.image = nil
        selectionBubble.setIsSelected(false, animated: false)
        shouldSelect = false
    }

    func configure(asset: SelectableAsset, isSelected: Bool) {
        self.asset = asset
        self.assetIdentifier = asset.id
        self.shouldSelect = isSelected
        setup()
    }

    func setupViews() {
        setSelected(shouldSelect)
    }

    func setupColors() {
        contentView.backgroundColor = .customBlack
    }

    func setupImages() {
        guard let asset = asset as? PHAsset, let assetIdentifier = assetIdentifier else { return }
        imageManager.requestImage(for: asset, targetSize: bounds.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, _ in
            if asset.id == assetIdentifier {
                self?.imageView.image = image
            }
        })
    }

    func toggleSelection(animated: Bool = true) {
        let shouldSelect = !self.shouldSelect
        setSelected(shouldSelect, animated: true)
        self.shouldSelect = shouldSelect
    }

    private func setSelected(_ selected: Bool, animated: Bool = false) {
        selectionBubble.setIsSelected(selected, animated: animated)
        isSelected = selected
    }

}
