
import UIKit

extension UITableView {

    func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }

    func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.identifier, bundle: Bundle(for: type(of: T()) as AnyClass)), forCellReuseIdentifier: T.identifier)
    }

    func dequeueCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as! T
    }

}
