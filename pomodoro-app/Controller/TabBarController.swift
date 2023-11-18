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
        let firstViewController = ViewController()
        let secondViewController = SecondViewController()
        
        // Установите их в соответствующие элементы таб-бара
        let firstTabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        firstViewController.tabBarItem = firstTabBarItem
        
        let secondTabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 1)
        secondViewController.tabBarItem = secondTabBarItem
        
        viewControllers = [firstViewController, secondViewController]
    }
}
