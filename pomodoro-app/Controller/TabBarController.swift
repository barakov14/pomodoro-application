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
