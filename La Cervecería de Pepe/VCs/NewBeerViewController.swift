//
//  NewBeerViewController.swift
//  La Cervecería de Pepe
//
//  Created by Carlos Martín on 15/1/21.
//

import UIKit
import ImagePicker

class NewBeerViewController: UIViewController {
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldType: UITextField!
    @IBOutlet weak var textFieldManufacturer: UITextField!
    @IBOutlet weak var textFieldNacionality: UITextField!
    @IBOutlet weak var textFieldCapacity: UITextField!
    @IBOutlet weak var textFieldIngestion: UITextField!
    @IBOutlet weak var textFieldCateNote: UITextField!
    @IBOutlet weak var textFieldIBU: UITextField!
    @IBOutlet weak var textFieldAlcohol: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    var beer: Beer?
    let datePicker = UIDatePicker()
    
    fileprivate var imagePickerController: ImagePickerController!
    fileprivate var selectedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let beer = beer {
            fillViews(beer: beer)
        }
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dateSelected));
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: false)
        
        textFieldIngestion.inputAccessoryView = toolbar
        
        if #available(iOS 13.4, *) {
           datePicker.preferredDatePickerStyle = .wheels
        }
        
        textFieldIngestion.inputView = datePicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func fillViews(beer: Beer) {
        textFieldName.text = beer.name
        textFieldType.text = beer.type.rawValue
        textFieldManufacturer.text = beer.manufacturer
        textFieldNacionality.text = beer.nationality
        textFieldCapacity.text = "\(beer.capacity)"
        textFieldIngestion.text = beer.preferentialIngestion
        textFieldCateNote.text = beer.cateNote
        textFieldIBU.text = "\(beer.ibu)"
        textFieldAlcohol.text = "\(beer.alcohol)"
        
        selectImageButton.isHidden = true
    }
    
    @objc func dateSelected() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldIngestion.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
        _ = textFieldShouldReturn(textFieldIngestion)
    }
    
    
    @IBAction func addPicture(_ sender: Any) {
        let configuration = Configuration()
        configuration.doneButtonTitle = "Finalizar"
        configuration.noImagesTitle = "No has selccionado imagenes"
        configuration.recordLocation = false
        
        imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController!, animated: true, completion: nil)
    }
    
    fileprivate func getBeerFromData() -> Beer? {
        guard
            let name = textFieldName.text,
            let type = textFieldType.text,
            let manufacturer = textFieldManufacturer.text,
            let nationality = textFieldNacionality.text,
            let capacityString = textFieldCapacity.text, let capacity = Int(capacityString),
            let ingestion = textFieldIngestion.text,
            let cateNote = textFieldCateNote.text,
            let ibuString = textFieldIBU.text, let ibu = Int(ibuString),
            let alcoholString = textFieldAlcohol.text, let alcohol = Float(alcoholString),
            let selectedImage = selectedImage, let png = selectedImage.pngData()
        else {
            print("Parámetros incompletos")
            return nil
        }
        
        var id = (name+type).replacingOccurrences(of: " ", with: "")
        if let beer = self.beer {
            id = beer.id
        }
        
        return Beer(id: id,
                    name: name,
                    type: ContainerType(rawValue: type)!,
                    manufacturer: manufacturer,
                    nationality: nationality,
                    capacity: capacity,
                    preferentialIngestion: ingestion,
                    cateNote: cateNote,
                    ibu: ibu,
                    alcohol: alcohol,
                    imagePath: png.base64EncodedString())
    }
    
    @IBAction func saveBeer(_ sender: Any) {
        guard let newBeer = getBeerFromData() else {
            print("Error al obtener datos")
            return
        }
        
        if let _ = self.beer {
            // Se está modificando.
            WebRequests.editBeer(beer: newBeer) { (success) in
                print("Resultado: \(success)")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EditedBeer"), object: newBeer)
                
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            // Nueva.
            WebRequests.newBeer(beer: newBeer) { (success) in
                print("Resulado: \(success)")

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewBeer"), object: newBeer)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func makeTextFieldVisible() {
        let kbSize: CGFloat = 336

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        var aRect = self.view.frame;
        aRect.size.height -= kbSize

        let activeField: UITextField? = [textFieldName, textFieldType, textFieldManufacturer, textFieldNacionality, textFieldCapacity, textFieldIngestion, textFieldCateNote, textFieldIBU, textFieldAlcohol].first { $0.isFirstResponder }
        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

extension NewBeerViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {}
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count == 1 else { return }
        self.selectedImage = images[0]
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.imagePickerController!.dismiss(animated: true, completion: nil)
    }
}


extension NewBeerViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        makeTextFieldVisible()
        
        if textField == textFieldType {
            let alert = UIAlertController(title: "Selecciona una opción", message: "\n\n\n\n\n\n", preferredStyle: .alert)
            
            let pickerView = UIPickerView(frame: CGRect(x: 5, y: 25, width: 250, height: 140))
            
            alert.view.addSubview(pickerView)
            pickerView.dataSource = self
            pickerView.delegate = self
            
            alert.addAction(UIAlertAction(title: "Done", style: .default) { action in
                textField.text = ContainerType.allItems[pickerView.selectedRow(inComponent: 0)].rawValue
                
                _ = self.textFieldShouldReturn(textField)
            })
            self.present(alert, animated: true)

            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTF = view.viewWithTag(textField.tag + 1) {
            nextTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }

}

extension NewBeerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ContainerType.allItems[row].rawValue
    }

}
