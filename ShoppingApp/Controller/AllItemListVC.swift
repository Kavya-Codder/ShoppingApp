//
//  AllItemListVC.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import UIKit

class AllItemListVC: UIViewController {
    var dbHelperObj: DBHelper = DBHelper()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var itemListTV: UITableView!
    
    var itemArray: [ItemsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
        itemListTV.delegate = self
        itemListTV.dataSource = self
        itemListTV.register(UINib(nibName: ItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.identifier)
        
        itemArray = dbHelperObj.featchItemList()
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemArray = dbHelperObj.featchItemList()
        itemListTV.reloadData()
    }
    
}

// Extenstion
extension AllItemListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemListTV.dequeueReusableCell(withIdentifier: ItemTableViewCell.identifier, for: indexPath) as! ItemTableViewCell
        let itemObj = itemArray[indexPath.row]
        cell.lblItenName.text = "Item Name: \(itemObj.itemName)"
        cell.lblCategory.text = "Category: \(itemObj.category)"
        cell.lblShopName.text = "Shop Name: \(itemObj.shopName) "
        cell.lblPrice.text = "Price: ₹\(itemObj.price) "
        if itemObj.category == "Grocery" {
            cell.lblweight.text = "Weight: \(itemObj.weight) "
        } else {
            cell.lblweight.text = "Number of items: \(itemObj.weight)"
        }
        
        cell.layer.shadowColor = UIColor(named: "bgColour")?.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func initialSetUp() {
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 30
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner,  .layerMinXMaxYCorner]
    }
    
}
