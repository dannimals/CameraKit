
import UIKit

class AssetListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!

    var imageSize: CGSize {
        return albumImageView.bounds.size
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    func reset() {
        titleLabel.text = nil
        albumImageView.image = nil
    }

    func configure(title: String?) {
        titleLabel.text = title
    }
    
}
