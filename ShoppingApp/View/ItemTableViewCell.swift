//
//  ItemTableViewCell.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
static let identifier = "ItemTableViewCell"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblItenName: UILabel!
    @IBOutlet weak var lblweight: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    let colourArray = ["colour-1", "colour-2", "colour-4","colour-5"]
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSeUp()
    }
    func initialSeUp() {
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 10
        
        btnDelete.clipsToBounds = true
        btnDelete.layer.cornerRadius = 15
        btnDelete.layer.shadowColor = UIColor(named: "bgColour")?.cgColor
        btnDelete.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        btnDelete.layer.shadowRadius = 2.0
        btnDelete.layer.shadowOpacity = 1
        btnDelete.layer.masksToBounds = false
        
        btnEdit.clipsToBounds = true
        btnEdit.layer.cornerRadius = 15
        btnEdit.layer.shadowColor = UIColor(named: "bgColour")?.cgColor
        btnEdit.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        btnEdit.layer.shadowRadius = 2.0
        btnEdit.layer.shadowOpacity = 1
        btnEdit.layer.masksToBounds = false
        
    }
    var deleteItem:(()->Void)?
    @IBAction func onClickDeleteBtn(_ sender: Any) {
        deleteItem?()
    }
    
    var editItem:(()->Void)?
    @IBAction func onClickEditBtn(_ sender: Any) {
        editItem?()
    }
    
}
