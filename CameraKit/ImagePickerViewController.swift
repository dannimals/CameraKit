
import PhotosUI
import UIKit

public protocol ImagePickerDelegate: class {

    func imagePickerDidFinishPickingAssets(_ assets: [PHAsset])

}

public enum ImagePickerError: Error {
    case invalidPermission

    public var localizedDescription: String {
        switch self {
        default: return "You must first obtain photo access permission from user."
        }
    }
}

public final class ImagePickerViewController: UIViewController, ViewStylePreparing {

    public weak var imagePickerDelegate: ImagePickerDelegate?
    weak var assetManagerDelegate: AssetManagerDelegate?

    let assetTableView = UITableView(frame: .zero, style: .grouped)
    var doneButton: UIBarButtonItem!
    var dataSource: CameraAssetPickerDataProviding!

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        try? commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        try? commonInit()
    }

    func commonInit() throws {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else { throw ImagePickerError.invalidPermission }
        let assetManager = AssetManager()
        dataSource = ImagePickerDataSource(assetManager: assetManager)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateDoneButtonIfNeeded()
        updateTitleIfNeeded()
    }

    func setupViews() {
        setupNavigationButtons()
        setupTableView()
    }

    func setupColors() {
        view.backgroundColor = .customBlack
        assetTableView.backgroundColor = view.backgroundColor
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .customBlack
        UINavigationBar.appearance().tintColor = .gray400
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray400]
    }

    private func setupTableView() {
        assetTableView.separatorStyle = .none
        assetTableView.delegate = self
        assetTableView.dataSource = dataSource
        assetTableView.registerNib(AlbumListTableViewCell.self)
        assetTableView.register(AssetListHeaderView.self, forHeaderFooterViewReuseIdentifier: AssetListHeaderView.identifier)
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
        dismiss(animated: true, completion: nil)
    }

    @objc
    func done() {
        imagePickerDelegate?.imagePickerDidFinishPickingAssets(dataSource.finalizedAssets)
        dismiss(animated: true, completion: nil)
    }

    private func updateDoneButtonIfNeeded() {
        doneButton?.isEnabled = dataSource.hasAssets
    }

    private func updateTitleIfNeeded() {
        title = dataSource.assetDescription
    }

}

extension ImagePickerViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let assetCollection = dataSource.collectionForIndexPath(indexPath) else { return }
        let assetGridViewController = AssetGridViewController()
        let gridDataSource = AssetGridDataSource(assetCollection: assetCollection, assetManager: dataSource.assetManager)
        assetGridViewController.configure(dataSource: gridDataSource)
        assetGridViewController.imagePickerDelegate = imagePickerDelegate
        navigationController?.pushViewController(assetGridViewController, animated: true)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AssetListHeaderView.identifier) as? AssetListHeaderView else { return nil }
        headerView.titleLabel.text = dataSource.sectionLocalizedTitles[section]
        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }

}

class AssetListHeaderView: UITableViewHeaderFooterView, ViewStylePreparing {

    let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    func setupColors() {
        titleLabel.textColor = .customWhite
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        contentView.backgroundColor = .gray900
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
    }

}
