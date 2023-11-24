import UIKit

class ThemeManager {
    static var currentTheme: Theme = LightTheme()
}

protocol Theme {
    var backgroundColor: UIColor { get }
    var primaryTextColor: UIColor { get }
    var secondaryTextColor: UIColor { get }
    // Добавьте другие цвета, если необходимо
}

struct LightTheme: Theme {
    var backgroundColor: UIColor = UIColor.white
    var primaryTextColor: UIColor = UIColor.black
    var secondaryTextColor: UIColor = UIColor.gray
    // Добавьте другие цвета, если необходимо
}

struct DarkTheme: Theme {
    var backgroundColor: UIColor = UIColor.black
    var primaryTextColor: UIColor = UIColor.white
    var secondaryTextColor: UIColor = UIColor.lightGray
    // Добавьте другие цвета, если необходимо
}
