
import UIKit

class AssetGridCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectionBubble: SelectionBubble!
    
    var assetIdentifier: String?

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        assetIdentifier = nil
        selectionBubble.setIsSelected(false, animated: false)
        shouldSelect = false
    }

    func configure(image: UIImage?) {
        imageView.image = image
    }

    private var shouldSelect = false
    func toggleSelection(animated: Bool = true) {
        let shouldSelect = !self.shouldSelect
        selectionBubble.setIsEnabled(true, animated: animated)
        selectionBubble.setIsSelected(shouldSelect, animated: animated)
        self.shouldSelect = shouldSelect
    }

}
