//
//  ProductViewController.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 15/01/2021.
//

import UIKit
import SDWebImage

class ProductViewController: UIViewController {
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var cateTextview: UITextView!
    @IBOutlet weak var consumtionTextView: UITextView!
    
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var alcoholLabel: UILabel!
    @IBOutlet weak var ibuLabel: UILabel!
    
    var beer: Beer! {
        didSet {
            self.fillView(beer: beer!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func fillView(beer: Beer) {
        if let url = URL(string: beer.imagePath) {
            self.beerImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "cerve"), options: .allowInvalidSSLCertificates, context: nil)
        }
            self.titleLabel.text = beer.name
        self.manufacturerLabel.text = beer.manufacturer.uppercased()
            
        self.originLabel.text = beer.nationality.uppercased()
        self.cateTextview.text = beer.cateNote
        self.consumtionTextView.text = beer.preferentialIngestion
            
        self.capacityLabel.text = "\(beer.capacity)"
        self.alcoholLabel.text = "\(beer.alcohol)"
        self.ibuLabel.text = "\(beer.ibu)"
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
