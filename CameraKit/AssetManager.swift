
import UIKit


protocol AssetManaging {

    var assets: [SelectableAsset] { get }

    func containsAsset(_ asset: SelectableAsset) -> Bool
    func addAsset(_ asset: SelectableAsset)
    func removeAssetIfNeeded(withID id: String)
    func reset()

}

class AssetManager: AssetManaging {

    private(set) var assetMap: [String: SelectableAsset] = [:]
    var assets: [SelectableAsset] { return Array(assetMap.values) }

    func addAsset(_ asset: SelectableAsset) {
        assetMap[asset.id] = asset
    }

    func containsAsset(_ asset: SelectableAsset) -> Bool {
        return assets.contains(where: { $0.id == asset.id })
    }

    func removeAssetIfNeeded(withID id: String) {
        assetMap.removeValue(forKey: id)
    }

    func reset() {
        assetMap.removeAll()
    }

}
