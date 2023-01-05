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
    
     let colourArray = ["colour-1", "colour-2", "colour-4","colour-5"]
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSeUp()
    }
    func initialSeUp() {
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 10
    }
    
}
