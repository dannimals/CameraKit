
import UIKit

protocol NibRepresentable: class {}

extension UINib {

    typealias Name = String

}

extension NibRepresentable {

    static var nibName: UINib.Name { return String(describing: self) }

    static func instantiateFromNib() -> Self {
        return instantiateFromNib(withName: nibName)
    }

    static func instantiateFromNib(withName nibName: String) -> Self {
        return Bundle(for: self).loadNibNamed(nibName, owner: self, options: nil)?.first as! Self
    }

}

extension UIView {

    static var identifier: String { return String(describing: self) }

}

