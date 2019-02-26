
import UIKit


protocol AssetManaging {

    var assets: [SelectableAsset] { get }

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

    func removeAssetIfNeeded(withID id: String) {
        assetMap.removeValue(forKey: id)
    }

    func reset() {
        assetMap.removeAll()
    }

}
