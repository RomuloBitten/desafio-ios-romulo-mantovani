//
//  UINavigationController+Extension.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 13/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? UIApplication.shared.statusBarFrame
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
