//
//  DBHelper.swift
//  ShoppingApp
//
//  Created by Sunil Developer on 05/01/23.
//

import Foundation
import UIKit
import SQLite3

class DBHelper {
    let dbPath: String = "myDb.sqlite"
    var database: OpaquePointer?
    
    init() {
        database = openDatabase()
        createtable()
    }
    
    func openDatabase() -> OpaquePointer? {
        do {
            let fileUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
            var db: OpaquePointer?
            if sqlite3_open(fileUrl.path, &db) == SQLITE_OK {
                return db
            } else {
                print("error while opening the database")
                return nil
            }
        } catch(let error) {
            print(error.localizedDescription)
        }
        
        return nil
    }
    // itenList
    func createtable() {
        let createTableStr = "CREATE TABLE IF NOT EXISTS itemList(id INTEGER PRIMARY KEY, itemName TEXT, weight TEXT, category TEXT, shopName TEXT, price REAL);"
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, createTableStr, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_OK {
                print("table successfully created.")
            } else {
                print("something went wrong.")
            }
        } else {
            print("create table statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertData(itemList: ItemsModel, completion: @escaping (String) -> Void) {
        let insertQuary = "INSERT INTO itemList(id,itemName,weight,category,shopName,price) VALUES(?,?,?,?,?,?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, insertQuary, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(itemList.id))
            sqlite3_bind_text(insertStatement, 2, (itemList.itemName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (itemList.weight as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (itemList.category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (itemList.shopName as NSString).utf8String, -1, nil)
            sqlite3_bind_double(insertStatement, 6, (itemList.price))
            if sqlite3_step(insertStatement) == SQLITE_OK {
                completion("data inserted successfully")
                print("data inserted successfully.")
            } else {
                print("could not insert row.")
            }
        } else {
            print("insert statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func featchItemList() -> [ItemsModel] {
        let featchQuery = "SELECT * FROM itemList"
        var featchQuaryStatement: OpaquePointer?
        var itemDetail : [ItemsModel] = []
        if sqlite3_prepare_v2(database, featchQuery, -1, &featchQuaryStatement, nil) == SQLITE_OK {
            while sqlite3_step(featchQuaryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(featchQuaryStatement, 0))
                let itemName = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 1)))
                let weight = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 2)))
                let category = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 3)))
                let shop = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 4)))
                let price = Double(sqlite3_column_double(featchQuaryStatement, 5))
                
                itemDetail.append(ItemsModel(id: Int(id), itemName: itemName, weight: weight, category: category, shopName: shop, price: Double(price)))
                //               let employeeObj = ItemsModel(id: id, name: name, age: age, mobile: mobile, address: address)
                //                empDetail.append(employeeObj)
            }
        } else {
            print("select statement not prepared")
        }
        sqlite3_finalize(featchQuaryStatement)
        return itemDetail
    }
    
    
    func deleteItem(itemId: Int32, index: Int, completion: @escaping (String) -> Void)
    {
        let deleteQuary = "DELETE FROM itemList WHERE id = ?;"
        var deleteQuaryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, deleteQuary, -1, &deleteQuaryStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(deleteQuaryStatement, 1, itemId)
            
            if sqlite3_step(deleteQuaryStatement) == SQLITE_DONE
            {
                completion("Successfully deleted row.")
                print("Successfully deleted row.")
            }
            else
            {
                print("Could not delete row.")
            }
        }
        else
        {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteQuaryStatement)
        print("delete")
    }
    
    func updateItem(itemId: Int32, itemName: String, category: String, weight: String, price: Double, shopName: String)
    {
        let updateQuary = "UPDATE itemList SET itemName = '\(itemName)', weight = '\(weight)', category = '\(category)', shopName = '\(shopName)', price = \(price) WHERE id = \(itemId);"
        var updateQuaryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, updateQuary, -1, &updateQuaryStatement, nil) == SQLITE_OK
        {
            sqlite3_bind_int(updateQuaryStatement, 1, itemId)
            
            if sqlite3_step(updateQuaryStatement) == SQLITE_DONE
            {
                //completion("Successfully update row")
                print("Successfully update row.")
            }
            else
            {
                print("Could not update row.")
            }
        }
        else
        {
            print("UPDATE statement could not be prepared")
        }
        sqlite3_finalize(updateQuaryStatement)
        print("update")
    }
    
    
    func getTotalSum()->Int32{
        let sumquery = "SELECT SUM(price) FROM itemList"
        var sumqueryStatement: OpaquePointer?
        var sum: Int32 = 0
        
        if sqlite3_prepare_v2(database, sumquery, -1, &sumqueryStatement, nil) == SQLITE_OK{
            while sqlite3_step(sumqueryStatement) == SQLITE_ROW {
                sum = sqlite3_column_int(sumqueryStatement, 0)
                print("totalsum \(sum)")
            }
        }
        
        if sqlite3_step(sumqueryStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(sumqueryStatement)!)
            print("Error:\(errmsg)")
        }
        return sum
    }
    
    func getTotalCount()->Int32{
        let totalCountQuery = "SELECT COUNT(*) FROM itemList"
        var totalCountQueryStatement: OpaquePointer?
        var totalCount: Int32 = 0
        
        if sqlite3_prepare_v2(database, totalCountQuery, -1, &totalCountQueryStatement, nil) == SQLITE_OK{
            while sqlite3_step(totalCountQueryStatement) == SQLITE_ROW {
                totalCount = sqlite3_column_int(totalCountQueryStatement, 0)
                print("totalCount \(totalCount)")
            }
        }
        
        if sqlite3_step(totalCountQueryStatement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(totalCountQueryStatement)!)
            print("Error:\(errmsg)")
        }
        return totalCount
    }
}
