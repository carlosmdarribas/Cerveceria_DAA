//
//  NewBeerViewController.swift
//  La Cervecería de Pepe
//
//  Created by Carlos Martín on 15/1/21.
//

import UIKit

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
    
    var beer: Beer?
    
    let datePicker = UIDatePicker()

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
    }
    
    @objc func dateSelected() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldIngestion.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
        
        _ = textFieldShouldReturn(textFieldIngestion)
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
