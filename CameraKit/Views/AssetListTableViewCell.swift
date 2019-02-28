
import UIKit

class AssetListTableViewCell: UITableViewCell, ViewStylePreparing {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!

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
        albumImageView.layer.cornerRadius = 8
    }

    func configure(title: String?) {
        titleLabel.text = title
    }

    private func reset() {
        titleLabel.text = nil
        albumImageView.image = nil
    }
    
}
