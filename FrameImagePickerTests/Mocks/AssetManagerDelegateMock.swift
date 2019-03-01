
@testable import FrameImagePicker

class AssetManagerDelegateMock: AssetManagerDelegate {

    var selectedAssets: [SelectableAsset] = []
    func assetManager(_ assetManager: AssetManaging, didSelectAssets assets: [SelectableAsset]) {
        selectedAssets = assets
    }

}
