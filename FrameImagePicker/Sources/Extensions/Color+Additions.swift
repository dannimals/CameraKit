
import UIKit

typealias Color = UIColor

extension Color {

    static var customPurple: Color { return Color(redValue: 91, greenValue: 83, blueValue: 255) }
    static var customBlack: Color { return Color(redValue: 15, greenValue: 15, blueValue: 20) }
    static var customWhite: Color { return Color(redValue: 241, greenValue: 243, blueValue: 246) }
    static var gray400: Color { return Color(redValue: 125, greenValue: 130, blueValue: 156) }
    static var gray900: Color { return Color(redValue: 21, greenValue: 21, blueValue: 28) }
    static var customGrey: Color { return Color(redValue: 32, greenValue: 34, blueValue: 43) }
    static var gray300: Color { return Color(redValue: 184, greenValue: 193, blueValue: 207) }

    convenience init(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat = 1.0) {
        let denominator: CGFloat = 255.0
        let red = redValue / denominator
        let green = greenValue / denominator
        let blue = blueValue / denominator
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

}
