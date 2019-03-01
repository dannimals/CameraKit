
import UIKit

final class SelectionBubble: UIControl {

    private(set) var imageView: UIImageView!
    private(set) var selectedColor: UIColor = .customPurple
    private(set) var deselectedColor: UIColor = .clear
    private(set) var borderSelectedColor: CGColor = UIColor.clear.cgColor
    private(set) var borderDeselectedColor: CGColor = UIColor.white.cgColor
    private(set) var selectedImage: UIImage? = UIImage(named: "Done", in: Bundle(for: SelectionBubble.self), compatibleWith: nil)
    private(set) var deselectedImage: UIImage? = nil

    fileprivate var image: UIImage? { return isSelected ? selectedImage : deselectedImage }
    fileprivate var color: UIColor { return isSelected ? selectedColor : deselectedColor }
    fileprivate var borderColor: CGColor { return isSelected ? borderSelectedColor : borderDeselectedColor }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        addImageView()
        configureTarget()
        addShadow()
        setupColors()
        isUserInteractionEnabled = false
        isEnabled = false
    }

    private func addShadow() {
        guard let imageView = imageView else { return }
        layer.shadowPath = UIBezierPath(roundedRect: imageView.frame, cornerRadius: imageView.frame.height / 2).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
    }

    private func addImageView() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .center
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.image = image
        addSubview(imageView)
    }

    private func configureTarget() {
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    func toggleSelection(animated: Bool) {
        isSelected = !isSelected
        didSetIsSelected(to: isSelected, animated: animated)
    }

    @objc func tapped(_ sender: UIControl) {
        toggleSelection(animated: true)
    }

    func setIsEnabled(_ isEnabled: Bool, animated: Bool) {
        self.isEnabled = isEnabled
        didSetIsEnabled(to: isEnabled, animated: animated)
    }

    func setIsSelected(_ isSelected: Bool, animated: Bool) {
        self.isSelected = isSelected
        didSetIsSelected(to: isSelected, animated: animated)
    }

    private func didSetIsEnabled(to isEnabled: Bool, animated: Bool) {
        fade(shouldShrink: !isEnabled, animated: animated)
    }

    private func didSetIsSelected(to isSelected: Bool, animated: Bool) {
        animatedChangedSelectionState(isSelected: isSelected, animated: animated)
    }

    fileprivate func setupColors() {
        backgroundColor = .clear
        imageView.backgroundColor = color
        imageView.layer.borderColor = borderColor
    }

    private func setColorForSelectedState(selected: Bool, backgroundColor: UIColor, borderColor: CGColor) {
        if selected {
            selectedColor = backgroundColor
            borderSelectedColor = borderColor
            return
        }
        deselectedColor = backgroundColor
        borderDeselectedColor = borderColor
    }

}

extension SelectionBubble {

    var transformConstant: CGFloat { return 1.0/20.0 }
    var contractFactor: CGFloat { return 1 - transformConstant }
    var expandFactor: CGFloat { return 1 + transformConstant }
    var selectionChangeAnimationDuration: TimeInterval { return 0.3 }

    fileprivate func animatedChangedSelectionState(isSelected: Bool, animated: Bool) {
        colorsForSelectionChange(isSelected: isSelected, animated: animated)
        imageCrossDissolveForSelectionChange(isSelected: isSelected, animated: animated)
        if !animated { return }
        transformForSelectionChange()
    }

    fileprivate func colorsForSelectionChange(isSelected: Bool, animated: Bool) {
        let duration = animated ? selectionChangeAnimationDuration : 0
        UIView.animate(withDuration: duration) {
            self.setupColors()
        }
    }

    fileprivate func transformForSelectionChange() {
        UIView.animateKeyframes(withDuration: selectionChangeAnimationDuration, delay: 0, options: [.calculationModeCubicPaced], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.33, animations: {
                self.transform = CGAffineTransform(scaleX: self.contractFactor, y: self.contractFactor)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.33, animations: {
                self.transform = CGAffineTransform(scaleX: self.expandFactor, y: self.expandFactor)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.34, animations: {
                self.transform = .identity
            })
        }, completion: nil)
    }

    fileprivate func imageCrossDissolveForSelectionChange(isSelected: Bool, animated: Bool) {
        if !animated {
            imageView.image = image
            return
        }
        UIView.transition(with: imageView, duration: selectionChangeAnimationDuration, options: [.transitionCrossDissolve, .allowAnimatedContent], animations: {
            self.imageView.image = self.image
        }, completion: nil)
    }

    fileprivate func fade(shouldShrink: Bool, animated: Bool) {
        let alpha: CGFloat = shouldShrink ? 0 : 1
        let scale: CGFloat = shouldShrink ? 0.1 : 1
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        if !animated {
            isHidden = shouldShrink
            self.alpha = alpha
            imageView.transform = transform
            return
        }
        isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0.05, options: [.curveEaseIn], animations: {
            self.imageView.transform = transform
            self.alpha = alpha
        }, completion: { _ in
            self.isHidden = shouldShrink
        })
    }

}
