//
//  PriciestCharacterHQViewController.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 14/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit
import RxSwift

class PriciestCharacterHQViewController: UIViewController {

    var characterId: Int!
    
    var viewModel = PriciestCharacterHQViewModel()
    
    var disposeUIBag = DisposeBag()
    
    var waitLabel = UILabel()
    
    var containerView = UIView()
    
    var titleLabel = UILabel()
    
    var imageView = UIImageView()
    
    var descriptionLabel = UILabel()
    
    var priceLabel = UILabel()
    
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
        setupWaitLabel()
        setupContainerView()
        setupTitleLabel()
        setupImageView()
        setupDescriptionLabel()
        setupPriceLabel()
    }
    
    func setupNav() {
        let image = UIImage(named: "header_title")
        let titleView = UIImageView(image: image)
        titleView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
    }
    
    func setupWaitLabel() {
        self.waitLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.waitLabel)
        self.waitLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.waitLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.waitLabel.font = .systemFont(ofSize: 24)
        self.waitLabel.textColor = Colors.lightContentText
        
        self.waitLabel.text = "Aguarde..."
    }
    
    func setupTitleLabel() {
        self.containerView.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.containerView.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 24).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 24).isActive = true
        self.titleLabel.layoutIfNeeded()
        
        
        self.titleLabel.textColor = Colors.lightContentText
        self.titleLabel.font = .systemFont(ofSize: 24)
        self.titleLabel.textAlignment = .center
        
    }
    
    func setupImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(imageView)
        self.imageView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 16).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        self.imageView.contentMode = .scaleAspectFit
        
        let divider = UIView(frame: CGRect(x: 0, y: imageView.frame.maxY+16, width: self.containerView.frame.width, height: 0.5))
        divider.backgroundColor = Colors.lightContentText
        
        self.containerView.addSubview(divider)
        
    }
    
    func setupDescriptionLabel() {
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.descriptionLabel)
        self.descriptionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 32).isActive = true
        self.descriptionLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 8).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.descriptionLabel.trailingAnchor, constant: 8).isActive = true
        
        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.font = .systemFont(ofSize: 16)
        self.descriptionLabel.textColor = Colors.lightContentText
        self.descriptionLabel.textAlignment = .center
    }
    
    func setupPriceLabel() {
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(self.priceLabel)
        self.priceLabel.topAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 8).isActive = true
        self.priceLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor).isActive = true
        self.priceLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, multiplier: 0.85).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.containerView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 8).isActive = true
        
        self.priceLabel.backgroundColor = Colors.marvelYellow
        self.priceLabel.layer.cornerRadius = 8
        self.priceLabel.layer.masksToBounds = true
        self.priceLabel.textAlignment = .center
        
    }
    
    func setupContainerView() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.containerView)
        self.containerView.isHidden = true
        
        self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.containerView.backgroundColor = .clear
    }
    
    func bindUI() {
        viewModel.rx_retrievePriciestHQ(characterId).observeOn(MainScheduler.instance).map {[weak self] (hq) -> MarvelHQ in
            guard let self = self else {return hq}
            self.bindImage(byObservable: hq.image())
            return hq
        }.subscribe(onNext: { [weak self] (hq) in
            guard let self = self else {return}
            self.fillScreen(withHQ: hq)
        }, onError: { (error) in
            debugPrint(error)
        }).disposed(by: disposeUIBag)
    }
    
    func fillScreen(withHQ hq: MarvelHQ) {
        self.waitLabel.isHidden = true
        self.containerView.isHidden = false
        
        self.titleLabel.text = hq.title
        
        self.descriptionLabel.text = hq.description
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.currencySymbol = "R$ "
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let currency: String
        if let floatLiteralSelf = formatter.string(from: NSNumber(floatLiteral: hq.price)) {
            currency = floatLiteralSelf
        } else {
            currency = ""
        }
        
        
        self.priceLabel.text = currency
    }
    
    func bindImage(byObservable observable: Observable<UIImage?>) {
        observable.subscribe { (event) in
            guard let image = event.element else {return}
            self.imageView.image = image
        }.disposed(by: self.disposeUIBag)
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
