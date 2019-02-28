
import PhotosUI
import UIKit

public protocol CameraAssetPickerDelegate: class {

    func assetPickerDidFinishPickingAssets(_ assets: [PHAsset])

}

public final class CameraAssetPickerViewController: UIViewController, ViewStylePreparing {

    public weak var cameraAssetPickerDelegate: CameraAssetPickerDelegate?
    weak var assetManagerDelegate: AssetManagerDelegate?

    let assetTableView = UITableView()
    var doneButton: UIBarButtonItem!
    var dataSource: CameraAssetPickerDataProviding!

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let assetManager = AssetManager()
        dataSource = CameraAssetPickerDataSource(assetManager: assetManager)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateDoneButtonIfNeeded()
    }

    func setupViews() {
        setupNavigationButtons()
        setupTableView()
    }

    func setupColors() {
        view.backgroundColor = .customBlack
        assetTableView.backgroundColor = view.backgroundColor
    }

    private func setupTableView() {
        assetTableView.separatorStyle = .none
        assetTableView.delegate = self
        assetTableView.dataSource = dataSource
        assetTableView.registerNib(AssetListTableViewCell.self)
        view.addSubview(assetTableView)
        assetTableView.translatesAutoresizingMaskIntoConstraints = false
        assetTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        assetTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        assetTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        assetTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupNavigationButtons() {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = doneButton
    }

    @objc
    func cancel() {
        dataSource.resetAssets()
    }

    @objc
    func done() {
        cameraAssetPickerDelegate?.assetPickerDidFinishPickingAssets(dataSource.finalizedAssets)
        dismiss(animated: true, completion: nil)
    }

    private func updateDoneButtonIfNeeded() {
        doneButton?.isEnabled = dataSource.hasAssets
    }

}

extension CameraAssetPickerViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let assetCollection = dataSource.collectionForIndexPath(indexPath) else { return }
        let assetGridViewController = AssetGridViewController()
        let gridDataSource = AssetGridDataSource(assetCollection: assetCollection, assetManager: dataSource.assetManager)
        assetGridViewController.configure(dataSource: gridDataSource)
        assetGridViewController.cameraAssetPickerDelegate = cameraAssetPickerDelegate
        navigationController?.pushViewController(assetGridViewController, animated: true)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
