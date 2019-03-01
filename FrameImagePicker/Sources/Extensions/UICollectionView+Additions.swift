
import UIKit

extension UICollectionView {

    func registerCell<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }

    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        register(UINib(nibName: T.identifier, bundle: Bundle(for: type(of: T()) as AnyClass)), forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
    }

}
