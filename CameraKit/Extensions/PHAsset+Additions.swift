
import Photos

public protocol SelectableAsset {

    var id: String { get }
    var mediaType: PHAssetMediaType { get }
    var mediaSubtypes: PHAssetMediaSubtype { get }
    var pixelWidth: Int { get }
    var pixelHeight: Int { get }
    var creationDate: Date? { get }
    var modificationDate: Date? { get }
    var location: CLLocation? { get }
    var duration: TimeInterval { get }

}

extension PHAsset: SelectableAsset {

    public var id: String { return localIdentifier }

}
