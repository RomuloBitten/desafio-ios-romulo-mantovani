//
//  MarvelNavigationController.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit

class MarvelNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBar.backgroundColor = Colors.marvelRed
        self.setStatusBar(backgroundColor: Colors.marvelRed)
        self.navigationBar.isOpaque = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .white
    }
    
    func setDefaultTitle() {
        let image = UIImage(named: "header_title")
        let titleView = UIImageView(image: image)
        titleView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 40))
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
