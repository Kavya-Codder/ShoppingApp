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
        let createTableStr = "CREATE TABLE IF NOT EXISTS itenList(id INTEGER PRIMARY KEY, itemName TEXT, weight TEXT, category TEXT, shopName TEXT, price TEXT);"
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
   
    func insertData(itenList: ItemsModel) {
        let insertQuary = "INSERT INTO itenList(id,itemName,weight,category,shopName,price) VALUES(?,?,?,?,?,?);"
        var insertStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, insertQuary, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(itenList.id))
            sqlite3_bind_text(insertStatement, 2, (itenList.itemName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (itenList.weight as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (itenList.category as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 5, (itenList.shopName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (itenList.price as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_OK {
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
        let featchQuery = "SELECT * FROM itenList"
        var featchQuaryStatement: OpaquePointer?
        var itemDetail : [ItemsModel] = []
        if sqlite3_prepare_v2(database, featchQuery, -1, &featchQuaryStatement, nil) == SQLITE_OK {
            while sqlite3_step(featchQuaryStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(featchQuaryStatement, 0))
                let itemName = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 1)))
                let weight = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 2)))
                let category = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 3)))
                let shop = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 4)))
                let price = String(describing: String(cString: sqlite3_column_text(featchQuaryStatement, 5)))
                
                itemDetail.append(ItemsModel(id: Int(id), itemName: itemName, weight: weight, category: category, shopName: shop, price: price))
//               let employeeObj = ItemsModel(id: id, name: name, age: age, mobile: mobile, address: address)
//                empDetail.append(employeeObj)
            }
        } else {
            print("select statement not prepared")
        }
        sqlite3_finalize(featchQuaryStatement)
        return itemDetail
    }
    
}
