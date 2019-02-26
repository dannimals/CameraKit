
import UIKit

class AssetGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    var assetIdentifier: String?

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        assetIdentifier = nil
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }

}
