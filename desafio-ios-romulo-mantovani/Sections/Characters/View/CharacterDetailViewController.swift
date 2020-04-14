//
//  CharacterDetailViewController.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 13/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CharacterDetailViewController: UIViewController {

    var character: MarvelCharacter!
    
    var disposeUIBag = DisposeBag()
    
    var labelName = UILabel()
    
    var imageView = UIImageView()
    
    var labelDescription = UILabel()
    
    var buttonPriciestHQ = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        bindUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = Colors.lightBackground
        setupNav()
        setupNameLabel()
        setupImageView()
        setupDescriptionLabel()
        setupButton()
    }
    
    func setupNav() {
        let image = UIImage(named: "header_title")
        let titleView = UIImageView(image: image)
        titleView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_icon"), style: .plain, target: self, action: #selector(CharacterDetailViewController.selfDismiss))
    }
    
    func setupNameLabel() {
        self.view.addSubview(self.labelName)
        self.labelName.translatesAutoresizingMaskIntoConstraints = false
        self.labelName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.labelName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.labelName.trailingAnchor, constant: 24).isActive = true
        self.labelName.layoutIfNeeded()
        
        
        self.labelName.textColor = Colors.lightContentText
        self.labelName.font = .systemFont(ofSize: 24)
        self.labelName.textAlignment = .center
        
        self.labelName.text = self.character.name
    }
    
    func setupImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        self.imageView.topAnchor.constraint(equalTo: self.labelName.bottomAnchor, constant: 16).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.imageView.contentMode = .scaleAspectFit
        
        let divider = UIView(frame: CGRect(x: 0, y: imageView.frame.maxY+16, width: self.view.frame.width, height: 0.5))
        divider.backgroundColor = Colors.lightContentText
        
        self.view.addSubview(divider)
        
    }
    
    func setupDescriptionLabel() {
        self.labelDescription.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.labelDescription)
        self.labelDescription.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 32).isActive = true
        self.labelDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.labelDescription.trailingAnchor, constant: 8).isActive = true
        
        self.labelDescription.numberOfLines = 3
        self.labelDescription.font = .systemFont(ofSize: 16)
        self.labelDescription.textColor = Colors.lightContentText
        self.labelDescription.text = character.description
        self.labelDescription.textAlignment = .center
    }
    
    func setupButton() {
        self.buttonPriciestHQ.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.buttonPriciestHQ)
        self.buttonPriciestHQ.topAnchor.constraint(greaterThanOrEqualTo: labelDescription.bottomAnchor, constant: 8).isActive = true
        self.buttonPriciestHQ.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.buttonPriciestHQ.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85).isActive = true
        self.buttonPriciestHQ.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.buttonPriciestHQ.bottomAnchor, constant: 8).isActive = true
        
        self.buttonPriciestHQ.backgroundColor = Colors.marvelYellow
        self.buttonPriciestHQ.layer.cornerRadius = 8
        self.buttonPriciestHQ.layer.masksToBounds = true
        
        self.buttonPriciestHQ.setTitle("Veja qual a HQ mais cara", for: .normal)
    }
    
    func bindUI() {
        bindImage()
        bindButton()
    }
    
    func bindImage()  {
        character.image().subscribe(onNext: { [weak self] image in
            guard let self = self, let image = image else {return}
            self.imageView.image = image
        }).disposed(by: self.disposeUIBag)
    }
    
    func bindButton() {
        buttonPriciestHQ.rx.tap.subscribe { [weak self] _ in
            guard let self = self else {return}
            self.goToPriciestHQ()
        }.disposed(by: self.disposeUIBag)
    }
    
    @objc func selfDismiss() {
        self.dismiss(animated: true)
    }
    
    func goToPriciestHQ() {
        let vc = PriciestCharacterHQViewController()
        vc.characterId = character.id
        
        self.navigationController?.pushViewController(vc, animated: true)
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
