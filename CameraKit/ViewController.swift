
import PhotosUI
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    var assetListViewController: AssetListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        assetListViewController = AssetListViewController()
        assetListViewController.publicAssetPickerDelegate = self
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentImagePicker()
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePicker() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let imagePickerActionSheet = UIAlertController(title: "Browse photos",
                                                       message: nil, preferredStyle: .actionSheet)
        let libraryButton = UIAlertAction(title: "Camera roll", style: .default) { [unowned self] _ in
            let navigationController = UINavigationController(rootViewController: self.assetListViewController)
            self.present(navigationController, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        present(imagePickerActionSheet, animated: true)
    }
}

extension ViewController: AssetPickerDelegate {

    func assetPickerDidFinishPickingAssets(_ assets: [PHAsset]) {
        debugPrint(assets)
    }

}

