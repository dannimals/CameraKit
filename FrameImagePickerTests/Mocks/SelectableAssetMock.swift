
import FrameImagePicker
import PhotosUI

struct SelectableAssetMock: SelectableAsset {

    var id: String
    var mediaType: PHAssetMediaType
    var mediaSubtypes: PHAssetMediaSubtype
    var pixelWidth: Int
    var pixelHeight: Int
    var creationDate: Date?
    var modificationDate: Date?
    var location: CLLocation?
    var duration: TimeInterval

    static func generate() -> SelectableAssetMock {
        return SelectableAssetMock(id: UUID().uuidString, mediaType: .image, mediaSubtypes: .photoHDR, pixelWidth: 2, pixelHeight: 2, creationDate: Date(), modificationDate: nil, location: nil, duration: 0)
    }

}
