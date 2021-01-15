//
//  BeerCollectionViewCell.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var alcoholLabel: PaddingLabel!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerCateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.alcoholLabel.layer.cornerRadius = self.alcoholLabel.frame.height/2
    }

}
