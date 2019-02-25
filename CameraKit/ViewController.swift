
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    var assetCollectionListViewController: AssetCollectionListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        assetCollectionListViewController = AssetCollectionListViewController()
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentImagePicker()
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePickerActionSheet = UIAlertController(title: "Upload",
                                                       message: nil, preferredStyle: .actionSheet)
        let libraryButton = UIAlertAction(title: "Camera roll", style: .default) { [unowned self] _ in
            let navigationController = UINavigationController(rootViewController: self.assetCollectionListViewController)
            self.present(navigationController, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        present(imagePickerActionSheet, animated: true)
    }
}

