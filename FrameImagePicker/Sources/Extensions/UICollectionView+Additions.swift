
import UIKit

extension UICollectionView {

    public func registerCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    public func registerNib<T: UICollectionViewCell>(_: T.Type) {
        register(UINib(nibName: T.identifier, bundle: Bundle(for: type(of: T()) as AnyClass)), forCellWithReuseIdentifier: T.identifier)
    }

}
