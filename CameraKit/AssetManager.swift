
import Photos
import PhotosUI
import UIKit

public protocol AssetPickerDelegate: class {

    func assetPickerDidFinishPickingAssets(_ assets: [PHAsset])

}

protocol AssetManagerDelegate: class {

    func assetManager(_ assetManager: AssetManaging, didSelectAssets: [SelectableAsset])

}

protocol AssetManaging {

    var assets: [SelectableAsset] { get }
    var delegate: AssetManagerDelegate? { get set }

    func addAsset(_ asset: SelectableAsset)
    func containsAsset(_ asset: SelectableAsset) -> Bool
    @discardableResult func finalizeAndClearAssets() -> [SelectableAsset]
    func removeAssetIfNeeded(withID id: String)

}

class AssetManager: AssetManaging {

    private(set) var assetMap: [String: SelectableAsset] = [:]
    var assets: [SelectableAsset] { return Array(assetMap.values) }

    weak var delegate: AssetManagerDelegate?

    func addAsset(_ asset: SelectableAsset) {
        assetMap[asset.id] = asset
        delegate?.assetManager(self, didSelectAssets: assets)
    }

    func containsAsset(_ asset: SelectableAsset) -> Bool {
        return assets.contains(where: { $0.id == asset.id })
    }

    @discardableResult
    func finalizeAndClearAssets() -> [SelectableAsset] {
        let currentAssets = assets
        reset()
        return currentAssets
    }

    func removeAssetIfNeeded(withID id: String) {
        assetMap.removeValue(forKey: id)
        delegate?.assetManager(self, didSelectAssets: assets)
    }

    private func reset() {
        assetMap.removeAll()
    }

}
