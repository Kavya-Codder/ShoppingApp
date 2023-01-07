//
//  AllItemListVC.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import UIKit

class AllItemListVC: UIViewController {
    var dbHelperObj: DBHelper = DBHelper()
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblAllItems: UILabel!
    @IBOutlet weak var lblTotalCost: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var itemListTV: UITableView!
    
    var itemArray: [ItemsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        
        var sum = dbHelperObj.getTotalSum()
        var total = dbHelperObj.getTotalCount()
        lblTotalCost.text = "Total Cost: \(sum)"
        lblAllItems.text = "All items: \(total)"
        print("sum",sum)
        
        itemListTV.delegate = self
        itemListTV.dataSource = self
        itemListTV.register(UINib(nibName: ItemTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ItemTableViewCell.identifier)
        
        itemArray = dbHelperObj.featchItemList()
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExpensesVC") as! ExpensesVC
        self.navigationController?.pushViewController(addItemVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemArray = dbHelperObj.featchItemList()
        lblTotalCost.text = "Total Cost: \(dbHelperObj.getTotalSum())"
        lblAllItems.text = "All items: \(dbHelperObj.getTotalCount())"
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
        
        // Delete item
        cell.deleteItem = {
            let alertVC = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
            let yesBtn = UIAlertAction(title: "YES", style: .destructive) { (alert) in
                
                let obj = self.itemArray[indexPath.row]
                self.dbHelperObj.deleteItem(itemId: Int32(obj.id), index: indexPath.row, completion: {
                    (msg) in
                    self.itemArray.remove(at: indexPath.row)
                    self.lblAllItems.text = "All items: \(self.dbHelperObj.getTotalCount())"
                    self.lblTotalCost.text = "Total Cost: \(self.dbHelperObj.getTotalSum())"
                    DispatchQueue.main.async {
                        self.itemListTV.reloadData()
                    }
                })
            }
            let noBtn = UIAlertAction(title: "NO", style: .default) { (alert) in
                self.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(yesBtn)
            alertVC.addAction(noBtn)
            self.present(alertVC, animated: true, completion: nil)
        }
        // edit item
        cell.editItem = {
            let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ExpensesVC") as! ExpensesVC
            editVC.obj = self.itemArray[indexPath.row]
            
            self.navigationController?.pushViewController(editVC, animated: false)
            
        }
        
        return cell
    }
    
    func initialSetUp() {
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 30
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner,  .layerMinXMaxYCorner]
        
        btnAdd.clipsToBounds = true
        btnAdd.layer.cornerRadius = 25
        
    }
    
}
