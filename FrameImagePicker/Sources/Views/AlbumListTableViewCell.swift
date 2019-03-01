
import PhotosUI
import UIKit

class AlbumListTableViewCell: UITableViewCell, ViewStylePreparing, NibRepresentable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var emptyAlbumView: UIImageView!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var dividerLine: UIView!

    private let imageManager = PHCachingImageManager()
    private var assetIdentifier: String?

    var imageSize: CGSize {
        return albumImageView.bounds.size
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    func setupViews() {
        albumImageView.contentMode = .scaleAspectFill
        albumImageView.layer.cornerRadius = 6
        albumImageView.clipsToBounds = true
    }

    func setupFonts() {
        itemCountLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }

    func setupColors() {
        contentView.backgroundColor = .customBlack
        dividerLine.backgroundColor = .gray900
        titleLabel.textColor = .customWhite
        itemCountLabel.textColor = .gray400
        albumImageView.backgroundColor = .customGrey
        emptyAlbumView.tintColor = .gray400
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = .gray900
        selectedBackgroundView = selectedBackground
    }

    func configure(collection: PHAssetCollection, isAllPhotos: Bool) {
        titleLabel.text = isAllPhotos ? NSLocalizedString("All Photos", comment: "All Photos") : collection.localizedTitle
        let fetchedAssets = PHAsset.fetchAssets(in: collection, options: nil)
        itemCountLabel.text = "\(fetchedAssets.count) items"
        guard fetchedAssets.count > 0 else { return }
        let firstAsset = fetchedAssets.firstObject
        assetIdentifier = firstAsset?.id
        setImage(forAsset: firstAsset)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let albumBackgroundColor = albumImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        albumImageView.backgroundColor = albumBackgroundColor
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let albumBackgroundColor = albumImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        albumImageView.backgroundColor = albumBackgroundColor
    }

    func setImage(forAsset asset: PHAsset?) {
        guard let asset = asset, let assetIdentifier = assetIdentifier else {
            emptyAlbumView.isHidden = false
            return
        }
        imageManager.requestImage(for: asset, targetSize: albumImageView.bounds.size, contentMode: .aspectFill, options: nil, resultHandler: { [weak self] image, _ in
            if asset.id == assetIdentifier {
                self?.albumImageView.image = image
                self?.emptyAlbumView.isHidden = true

            }
        })
    }

    private func reset() {
        titleLabel.text = nil
        albumImageView.image = nil
        assetIdentifier = nil
        emptyAlbumView.isHidden = false
        itemCountLabel.text = nil
    }
    
}
