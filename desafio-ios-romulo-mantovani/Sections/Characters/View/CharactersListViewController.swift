//
//  CharactersListViewController.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit
import RxSwift

class CharactersListViewController: UIViewController {

    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var viewModel = CharactersListViewModel()
    
    var disposeUIBag = DisposeBag()
    
    var currentPage = 0
    
    var showablePages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
        self.bindUI()
        
        self.collectionView.reloadData()
    }
    
    func setupUI() {
        self.setupCollection()
        self.setupNav()
        self.view.backgroundColor = .white
    }
    
    func setupNav() {
        let image = UIImage(named: "header_title")
        let titleView = UIImageView(image: image)
        titleView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
    }
    
    func setupCollection() {
        self.view.addSubview(collectionView)
        self.collectionView.frame = self.view.bounds
        self.view.topAnchor.constraint(equalTo: self.collectionView.topAnchor).isActive = true
        self.view.leadingAnchor.constraint(equalTo: self.collectionView.leadingAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.collectionView.trailingAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        self.collectionView.layoutIfNeeded()
        
        self.collectionView.backgroundColor = Colors.lightBackground
        self.collectionView.isPagingEnabled = true
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: self.collectionView.frame.width/2,
                                               height: (self.collectionView.frame.height/10)-10)
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        self.collectionView.collectionViewLayout = collectionViewLayout
        self.collectionView.register(UINib.init(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func bindUI() {
        self.bindNextPageOfCharacters()
    }
    
    func bindNextPageOfCharacters() {
        if self.viewModel.retrievedPages < self.viewModel.totalPages ?? 1 {
            self.viewModel.rx_retrieveNextPage().observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] _ in
                guard let self = self else {return}
                self.collectionView.reloadData()
                if self.currentPage >= (self.showablePages-1){
                    self.bindNextPageOfCharacters()
                }
                self.showablePages += 1
            }, onError: { error in
                debugPrint(error)
            }).disposed(by: self.disposeUIBag)
        }
    }
}

extension CharactersListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.showablePages*viewModel.itemsForPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as? CharacterCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(withChar: viewModel.characters[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: (collectionView.frame.width/2),
                          height: (collectionView.frame.height/10)-10)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCharacter = self.viewModel.characters[indexPath.row]
        let vc = CharacterDetailViewController()
        vc.character = selectedCharacter
        
        let wrapedInNav = vc.wrapNavigation
        wrapedInNav.modalPresentationStyle = .fullScreen
        
        self.present(wrapedInNav, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.currentPage = Int(exactly: scrollView.contentOffset.x/scrollView.frame.width) ?? 0
        if self.currentPage >= (self.showablePages-1){
            self.bindNextPageOfCharacters()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = Int(exactly: scrollView.contentOffset.x/scrollView.frame.width) ?? 0
        if self.currentPage >= (self.showablePages-1){
            self.bindNextPageOfCharacters()
        }
    }
}
