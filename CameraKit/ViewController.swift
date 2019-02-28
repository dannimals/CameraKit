
import PhotosUI
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    var assetPickerViewController: CameraAssetPickerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        assetPickerViewController = CameraAssetPickerViewController()
        assetPickerViewController.cameraAssetPickerDelegate = self
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
            let navigationController = UINavigationController(rootViewController: self.assetPickerViewController)
            self.present(navigationController, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        present(imagePickerActionSheet, animated: true)
    }
}

extension ViewController: CameraAssetPickerDelegate {

    func assetPickerDidFinishPickingAssets(_ assets: [PHAsset]) {
        debugPrint(assets)
    }

}

