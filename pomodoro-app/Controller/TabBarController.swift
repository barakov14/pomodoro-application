//
//  MainTabBarController.swift
//  pomodoro-app
//
//  Created by Adilkhan Barakov on 18.11.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        tabBar.tintColor = .purple
        tabBar.unselectedItemTintColor = .white
        tabBar.backgroundColor = .black
        
        // Создайте экземпляры ваших контроллеров
        let firstViewController = TimerViewController()
        let secondViewController = TaskManagerViewController()
        let thirdViewController = SettingsViewController()
        
        // Установите их в соответствующие элементы таб-бара
        let firstTabBarItem = UITabBarItem(title: "", image: UIImage(named: "timer"), tag: 0)
        firstViewController.tabBarItem = firstTabBarItem
        
        let secondTabBarItem = UITabBarItem(title: "", image: UIImage(named: "task"), tag: 1)
        secondViewController.tabBarItem = secondTabBarItem
        let thirdTabBarItem = UITabBarItem(title: "", image: UIImage(named: "settings"), tag: 2)
        thirdViewController.tabBarItem = thirdTabBarItem
        
        viewControllers = [firstViewController, secondViewController, thirdViewController]
        
    }
}
extension UIColor {
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
class CustomTabBar: UITabBar {
    
    private var additionalTopInset: CGFloat = 20.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 70 + additionalTopInset  // Установите желаемую высоту TabBar
        return sizeThatFits
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in subviews where subview is UIControl {
            subview.frame.origin.y = 10
        }
    }
}
