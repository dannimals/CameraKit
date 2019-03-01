
import UIKit

public extension UITableView {

    public func registerCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }

    public func registerNib<T: UITableViewCell>(_: T.Type) {
        register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }

}

