//
//  FirebaseData.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 04.06.2021.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseData {
    var categories: [Category]?
    var menuItems: [MenuItem]?
    var db = Firestore.firestore()        
    
//    func getCategories(){
//        db.collection("category").addSnapshotListener { querySnapShot, error in
//            guard let documents = querySnapShot?.documents else{
//                print("No Documents")
//                return
//            }
//            var arr: [Category] = []
//            documents.forEach { queryDocumentSnapshot in
//                let data = queryDocumentSnapshot.data()
//                let id = data["id"] as? Int ?? -1
//                let name = data["name"] as? String ?? ""
//                let category = Category(id: id, name: name)
//                arr.append(category)
//            }
//            self.categories = arr
//        }
//    }
//    
//    func getMenuItems() -> [MenuItem] {
//        var arr: [MenuItem] = []
//        db.collection("menu").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else{
//                print("No Documents")
//                return
//            }
//                documents.forEach { queryDocumentSnapshot in
//                let data = queryDocumentSnapshot.data()
//                let categoryId = data["categoryID"] as? Int ?? -1
//                let description = data["description"] as? String ?? ""
//                let imageUrl = data["image"] as? String ?? ""
//                let name = data["name"] as? String ?? ""
//                let price = data["price"] as? Double ?? -1
//                let restaurantId = data["restoranId"] as? Int ?? -1
//                let id = data["id"] as? Int ?? -1
//                let menuItem = MenuItem.init(id: id, categoryId: categoryId, description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId)
//                arr.append(menuItem)
//            }
//            self.menuItems = arr
//        
//        }
//        
//        return arr
//    }
}


