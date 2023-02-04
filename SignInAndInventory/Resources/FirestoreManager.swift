//
//  FirestoreManager.swift
//  SignInAndInventory
//
//  Created by OPSolutions on 2/4/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

public class FirestoreManager {
    let database = Firestore.firestore()
    let encoderHelper = EncoderHelper()
    
    func retrieveAllItems(completion: @escaping ([InventoryItem]?, String?) ->() ) {
        var inventoryItems = [InventoryItem]()
        let collectionReference = database.collection("InventoryItems")
        collectionReference.getDocuments() { snapshot, error in
            guard let snapshotDocuments = snapshot?.documents, error == nil else {
                completion(nil, error?.localizedDescription)
                return
            }
            inventoryItems = snapshotDocuments.map { doc in
                return InventoryItem(id: doc.documentID,
                                     productName: doc["productName"] as? String,
                                     stock: doc["stock"] as? Int)
            }
            completion(inventoryItems, nil)
        }
    }
    

    
    func saveItem(item: InventoryItem, mode: DetailsMode, completion: @escaping (String?) ->()) {
        let document = encoderHelper.encodeItem(inputItem: item)
        let collectionReference = database.collection("InventoryItems")
        switch mode {
        case .add:
            collectionReference.document(item.id!).setData(document){ error in
                guard error == nil else {
                    completion(error?.localizedDescription)
                    return
                }
                completion(nil)
            }
        case .edit:
            collectionReference.document(item.id!).updateData(document){ error in
                guard error == nil else {
                    completion(error?.localizedDescription)
                    return
                }
                completion( nil)
            }
        }
    }
    
    
    
    func deleteItem(item: InventoryItem?, completion: @escaping (String?) ->()) {
        if let item = item {
            let documentReference = database.collection("InventoryItems").document(item.id!)
            documentReference.delete() { error in
                guard error == nil else {
                    completion(error?.localizedDescription)
                    return
                }
                completion(nil)
            }
        } else {
            completion("No Item to Delete")
        }
       
    }
    
    func createNewItem(name: String, stock: String?) -> InventoryItem{
        var newItem = InventoryItem()
        newItem.id = UUID().uuidString
        newItem.productName = name
        let stockInt = (stock as? NSString)?.integerValue
        newItem.stock = stockInt
        return newItem
    }
    
    func updateItem(item: InventoryItem, name: String, stock: String?) -> InventoryItem {
        var updatedItem = InventoryItem()
        updatedItem.id = item.id
        updatedItem.productName = name
        let stockInt = (stock as? NSString)?.integerValue
        updatedItem.stock = stockInt
        return updatedItem
    }
    
    func isDuplicate(item: InventoryItem, inventoryItems: [InventoryItem]) -> Bool{
        var isDuplicate = false
        for currentItem in inventoryItems {
            if item.productName == currentItem.productName {
                isDuplicate = true
            }
        }
        return isDuplicate
    }
}
