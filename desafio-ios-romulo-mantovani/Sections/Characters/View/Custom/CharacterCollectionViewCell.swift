//
//  CharacterCollectionViewCell.swift
//  desafio-ios-romulo-mantovani
//
//  Created by Romulo Bittencourt Mantovani on 09/04/20.
//  Copyright © 2020 Romulo Bittencourt Mantovani. All rights reserved.
//

import UIKit
import RxSwift

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let apiCall = CharactersAPI()
    let cellDisposeBag = DisposeBag()
    
    var character: MarvelCharacter!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.text = character.name
        self.imageView.image = nil
        character.image().subscribe(onNext: { [weak self] image in
            guard let self = self, let image = image else {return}
            self.imageView.image = image
        }).disposed(by: self.cellDisposeBag)
    }
    
    func setup(withChar char: MarvelCharacter) {
        self.character = char
    }
}
