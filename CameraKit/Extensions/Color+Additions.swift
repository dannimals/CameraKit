
import UIKit

typealias Color = UIColor

extension Color {

    static var customPurple: Color { return Color(redValue: 91, greenValue: 83, blueValue: 255) }
    static var customBlack: Color { return Color(redValue: 15, greenValue: 15, blueValue: 20) }
    static var customWhite: Color { return Color(redValue: 241, greenValue: 243, blueValue: 246) }
    static var selectedCellColor: Color { return Color(redValue: 50, greenValue: 55, blueValue: 69) }

    convenience init(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat = 1.0) {
        let denominator: CGFloat = 255.0
        let red = redValue / denominator
        let green = greenValue / denominator
        let blue = blueValue / denominator
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}
