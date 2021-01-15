//
//  ViewController.swift
//  La Cervecería de Pepe
//
//  Created by Carlos on 12/01/2021.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var sectionSelectorCollection: UICollectionView!
    @IBOutlet weak var beersCollection: UICollectionView!
    
    fileprivate var sections = [Section]()
    fileprivate var beers = [Beer]()
    fileprivate var shownBeers = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initCVs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let gotBeers = CMFileManager.getBeersFromFile() {
            self.beers += gotBeers
        }
        
        WebRequests.updateBeers { (gotBeers) in
            gotBeers.forEach({
                if !self.beers.contains($0) { self.beers.append($0) }
            })
            
            self.beers.uniqueTitles().forEach({self.sections.append(Section(title: $0))})
            self.updateBeersInScreen(withManufacturerName: self.sections[0].title)
            self.sections.first?.active = true
            
            [self.beersCollection, self.sectionSelectorCollection].forEach({$0.reloadData()})
        }
    }
    
    func initCVs() {
        self.sectionSelectorCollection.register(UINib.init(nibName: "SectionSellectorCVCell", bundle: nil), forCellWithReuseIdentifier: "sectionCell")
        self.beersCollection.register(UINib.init(nibName: "BeerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "beerCell")
        
        if let flowLayout = sectionSelectorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        self.beersCollection.collectionViewLayout = getLayout(size: CGSize(width: self.beersCollection.frame.width/1.5, height: self.beersCollection.frame.height))
    }
    
    @objc func appMovedToBackground() {
        if CMFileManager.saveToFile(beers: self.beers) {
            print("Guardado OK")
        } else {
            print("Error al guardar")
        }
    }
    
    func getLayout(size: CGSize) -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = size
        
        return layout

    }
    
    func updateBeersInScreen(withManufacturerName name: String) {
        self.shownBeers = self.beers.filter({$0.manufacturer == name})
        self.beersCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard segue.identifier == "showBeer", let beer = sender as? Beer else { return }
        
        let newBeerVC = segue.destination as! ProductViewController
        newBeerVC.beer = beer
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case sectionSelectorCollection: return sections.count
            case beersCollection: return shownBeers.count
                
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case sectionSelectorCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath) as! SectionSellectorCVCell
            cell.setTitle(newTitle: sections[indexPath.row].title)
            cell.setActive(active: sections[indexPath.row].active)
            
            return cell
            
            
        case beersCollection:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "beerCell", for: indexPath) as! BeerCollectionViewCell
            
            let currentBeer = shownBeers[indexPath.row]
            
            if let url = URL(string: currentBeer.imagePath) {
                print("URL: \(url.absoluteString)")
                cell.productImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "cerve"), options: .allowInvalidSSLCertificates, context: nil)
            }
            
            cell.alcoholLabel.text = "\(currentBeer.alcohol)º"
            cell.beerNameLabel.text = currentBeer.name
            cell.beerCateLabel.text = currentBeer.cateNote
            
            return cell
            
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case sectionSelectorCollection:
                sections.forEach({$0.active = ($0 == sections[indexPath.row]) ? true : false})
                self.updateBeersInScreen(withManufacturerName: self.sections[indexPath.row].title)
                collectionView.reloadData()
         
        case beersCollection:
            self.performSegue(withIdentifier: "showBeer", sender: self.shownBeers[indexPath.row])
        default: break
        }
    }
}
