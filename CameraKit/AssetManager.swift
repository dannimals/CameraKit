
import UIKit

protocol AssetManagerDelegate: class {

    func assetManager(_ assetManager: AssetManaging, didSelectAssets assets: [SelectableAsset])

}

protocol AssetManaging {

    var assets: [SelectableAsset] { get }
    var delegate: AssetManagerDelegate? { get set }
    var assetDescription: String? { get }

    func addAsset(_ asset: SelectableAsset)
    func containsAsset(_ asset: SelectableAsset) -> Bool
    @discardableResult func finalizeAndClearAssets() -> [SelectableAsset]
    func removeAssetIfNeeded(withID id: String)

}

class AssetManager: AssetManaging {

    private(set) var assetMap: [String: SelectableAsset] = [:]
    var assets: [SelectableAsset] { return Array(assetMap.values) }
    var assetDescription: String? {
        let itemString = assets.count == 1 ? NSLocalizedString("item selected", comment: "") : NSLocalizedString("items selected", comment: "")
        let title = assets.count > 0 ? "\(assets.count) \(itemString)" : nil
        return title
    }

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
