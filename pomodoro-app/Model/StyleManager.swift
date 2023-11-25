//
//  StyleManager.swift
//  pomodoro-app
//
//  Created by Adilkhan Barakov on 25.11.2023.
//

import UIKit

class StyleManager {
    static var backgroundColor: UIColor = .white
    static var textColor: UIColor = .black

    static func applyStyle(to viewController: UIViewController) {
        viewController.view.backgroundColor = backgroundColor
        viewController.view.tintColor = textColor
    }
}
