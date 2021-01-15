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
        
        self.sectionSelectorCollection.register(UINib.init(nibName: "SectionSellectorCVCell", bundle: nil), forCellWithReuseIdentifier: "sectionCell")
        self.beersCollection.register(UINib.init(nibName: "BeerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "beerCell")
        
        sections.append(Section(title: "Seccion 1"))
        sections.append(Section(title: "Seccion 2"))
        sections.append(Section(title: "Seccion 3"))
        sections.append(Section(title: "Seccion 4"))
        sections.append(Section(title: "Seccion 5"))
        sections.first?.active = true
        
        beers.append(Beer(id: "lagallolocajunio21", name: "asdasd", type: .bottle, manufacturer: "Lasd Calsda", nationality: "ES", capacity: 12, preferentialIngestion: Date(), cateNote: "Esta mu wena", ibu: "12", alcohol: 5, imagePath: ""))
        beers.append(Beer(id: "lagallolocajunio21", name: "asdasd", type: .bottle, manufacturer: "Lasd Calsda", nationality: "ES", capacity: 12, preferentialIngestion: Date(), cateNote: "Esta mu wena", ibu: "12", alcohol: 5, imagePath: ""))

        
        if let flowLayout = sectionSelectorCollection.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        
        if let flowLayout = beersCollection.collectionViewLayout as? UICollectionViewFlowLayout {
              flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        self.sectionSelectorCollection.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
            case sectionSelectorCollection: return sections.count
            case beersCollection: return beers.count
                
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
            
            let currentBeer = beers[indexPath.row]
            cell.alcoholLabel.text = "\(currentBeer.alcohol)º"
            cell.beerNameLabel.text = currentBeer.name
            cell.beerCateLabel.text = currentBeer.cateNote
            cell.productImageView.image = #imageLiteral(resourceName: "cerve")
            
            return cell
            
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            case sectionSelectorCollection:
                sections.forEach({$0.active = ($0 == sections[indexPath.row]) ? true : false})

                collectionView.reloadData()
                
        default: break
        }
    }
}
