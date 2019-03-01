
import FrameImagePicker
import PhotosUI
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!

    var assetPickerViewController: ImagePickerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        assetPickerViewController = ImagePickerViewController()
        assetPickerViewController.imagePickerDelegate = self
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization { [weak self] authorizationStatus in
            guard authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                self?.presentImagePicker()
            }
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func presentImagePicker() {
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

extension ViewController: ImagePickerDelegate {

    func imagePickerDidFinishPickingAssets(_ assets: [PHAsset]) {
        debugPrint(assets)
    }

}

