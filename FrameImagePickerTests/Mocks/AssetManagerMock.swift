
import Foundation
@testable import FrameImagePicker

class AssetManagerMock: AssetManaging {

    var assets: [SelectableAsset] = []
    var delegate: AssetManagerDelegate?
    var assetDescription: String? = "test"

    var addedAsset: SelectableAsset?
    func addAsset(_ asset: SelectableAsset) {
        addedAsset = asset
    }

    func containsAsset(_ asset: SelectableAsset) -> Bool {
        return false
    }

    var didClearAssets = false
    @discardableResult func finalizeAndClearAssets() -> [SelectableAsset] {
        didClearAssets = true
        return assets
    }

    var didRemoveAssetID: String?
    func removeAssetIfNeeded(withID id: String) {
        didRemoveAssetID = id
    }

}
