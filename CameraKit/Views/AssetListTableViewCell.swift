
import UIKit

class AssetListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
    }

    func configure(title: String?) {
        titleLabel.text = title
    }
    
}
