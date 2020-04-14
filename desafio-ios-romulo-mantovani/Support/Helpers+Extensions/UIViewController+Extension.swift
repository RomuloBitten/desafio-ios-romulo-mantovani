//
//  UIViewController+Extension.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 14/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var wrapNavigation: UINavigationController {
        let nav = MarvelNavigationController()
        nav.viewControllers = [self]
        return nav
    }
    
}
