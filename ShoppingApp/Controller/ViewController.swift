//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import UIKit

enum itemsValidations: String {
    case itemName = "Please enter item name."
    case category = "Please select category"
    case price = "Please enter item price."
    case numberOfItem = "Please enter item quentity."
    case shopName = "Please enter shop name."
}

class ViewController: UIViewController
{
    
    @IBOutlet weak var viewItenName: UIView!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var viewPrice: UIView!
    @IBOutlet weak var viewWeight: UIView!
    @IBOutlet weak var viewShop: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblShop: UILabel!
    
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtCagegory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtShop: UITextField!
    
    let categories = ["Grocery", "Furniture", "Cloths", "Electronics"]
    var categoryPicker: UIPickerView!
    var dbHelperObj: DBHelper = DBHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
        // categoryPicker
        categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        txtCagegory.inputView = categoryPicker
        txtCagegory.text = categories.first
        txtCagegory.delegate = self
        
        categoryPicker.backgroundColor = UIColor(named: "colour=3")
    }
    
    @IBAction func onClickSaveBtn(_ sender: Any) {
        
        let validation = doValidation()
        if validation.0 {
            dbHelperObj.insertData(itenList: ItemsModel(id: Int.random(in: 0..<6), itemName: txtItemName.text ?? "", weight: txtWeight.text ?? "", category: txtCagegory.text ?? "", shopName: txtShop.text ?? "", price: txtPrice.text ?? ""))
            print(dbHelperObj.featchItemList())
            showAlert(title: "Success", message: "Add item successfully") { (action) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Error", message: validation.1, hendler: nil)
        }
    }
    
    @IBAction func onClickCancleBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
// Extension

// pickerView configration

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate  {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.inputView = categoryPicker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCagegory.text = categories[row]
        if txtCagegory.text == "Grocery" {
            lblWeight.text = "Weight*"
        } else {
            lblWeight.text = "Number of items*"
        }
        self.view.endEditing(true)
    }
    
    // custom function
    
    func initialSetUp() {
        viewItenName.clipsToBounds = true
        viewItenName.layer.cornerRadius = 20
        
        viewCategory.clipsToBounds = true
        viewCategory.layer.cornerRadius = 20
        
        viewPrice.clipsToBounds = true
        viewPrice.layer.cornerRadius = 20
        
        viewWeight.clipsToBounds = true
        viewWeight.layer.cornerRadius = 20
        
        viewShop.clipsToBounds = true
        viewShop.layer.cornerRadius = 20
        //        viewShop.layer.shadowColor = UIColor(named: "colour=3")?.cgColor
        //        viewShop.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        //        viewShop.layer.shadowRadius = 0.5
        //        viewShop.layer.shadowOpacity = 0.5
        //        viewShop.layer.masksToBounds = false
        
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 25
        btnSave.layer.borderWidth = 1.5
        btnSave.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    func doValidation() -> (Bool, String) {
        if (txtItemName.text?.isEmpty ?? false) {
            return (false, itemsValidations.itemName.rawValue)
        } else if (txtCagegory.text?.isEmpty ?? false) {
            return (false, itemsValidations.category.rawValue)
        } else if (txtWeight.text?.isEmpty ?? false) {
            return (false, itemsValidations.numberOfItem.rawValue)
        } else if (txtPrice.text?.isEmpty ?? false) {
            return (false, itemsValidations.price.rawValue)
        } else if (txtShop.text?.isEmpty ?? false) {
            return (false, itemsValidations.shopName.rawValue)
        }
        return (true, "")
    }
    
    func clearTextField() {
        txtItemName.text = ""
        txtWeight.text = ""
        txtCagegory.text = ""
        txtPrice.text = ""
        txtShop.text = ""
    }
    
}
