//
//  ItemModel.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import Foundation
class ItemsModel {
    var id: Int = 0
    var itemName: String = ""
    var weight: String = ""
    var category: String = ""
    var shopName: String = ""
    var price: Double = 0
    
    init(id: Int, itemName: String, weight: String, category: String, shopName: String, price: Double) {
        self.id = id
        self.itemName = itemName
        self.weight = weight
        self.category = category
        self.shopName = shopName
        self.price = price
    }
}
