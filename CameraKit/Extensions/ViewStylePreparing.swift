
import UIKit

protocol ViewStylePreparing {

    func setup()
    func setupColors()
    func setupFonts()
    func setupLayers()
    func setupText()
    func setupImages()
    func setupViews()

}

extension ViewStylePreparing {

    func setup() {
        setupViews()
        setupColors()
        setupFonts()
        setupLayers()
        setupText()
        setupImages()
    }

    func setupColors() {}
    func setupFonts() {}
    func setupLayers() {}
    func setupText() {}
    func setupImages() {}
    func setupViews() {}

}
