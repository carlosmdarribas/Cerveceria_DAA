//
//  ViewController.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 12/01/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sectionSelectorCollection: UICollectionView!
    @IBOutlet weak var beersCollection: UICollectionView!
    
    fileprivate var sections = [Section]()
    fileprivate var beers = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
