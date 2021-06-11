//
//  QRFirebaseDatabase.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 10.06.2021.
//

import Foundation
import Firebase
import UIKit


class QRFirebaseDatabase {
    
    static let shared = QRFirebaseDatabase()
    
    private func configureFB() -> Firestore{
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getUser(uid: String, completion: @escaping (User?) -> Void ){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { document, error in
            guard error == nil else { completion(nil); return }
            if let document = document, document.exists {
                let data = document.data()
                var userCards: [Card] = []
                let name = data?["name"] as? String ?? "No"                
                let surname = data?["surname"] as? String ?? "Name"
                let phone = data?["phone"] as? String ?? ""
                let gender = data?["gender"] as? String ?? ""
                let birthDate = data?["birthDate"] as? String ?? ""
                let cards = data?["cards"] as! [String : [Any]]
                cards.forEach { cardInfo, arrayInfo in
                    let arr = arrayInfo as [Any]
                    let cardName = arr[0] as? String
                    let cardNumber = arr[1] as? String
                    let date = arr[2] as? String
                    let card = Card(cardName: cardName, cardNumber: cardNumber, date: date)
                    userCards.append(card)
                    }
                let user = User(name: name, surname: surname, phone: phone, gender: gender, birthDate: birthDate, cards: userCards)
                completion(user)
            }
        }
    }
    
    func getCategories() -> [Category] {
        var categories: [Category] = []
        configureFB().collection("category").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? Int ?? 0
                let name = data["name"] as? String ?? ""
                categories.append(Category(id: id, name: name))
            }
        }
        return categories
    }
    
    func getMenuItems() -> [Int : [MenuItem]]{
        var menuItems: [Int : [MenuItem]] = [:]
        configureFB().collection("menu").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("No Documents")
                return
            }
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let categoryId = data["categoryID"] as? Int ?? -1
                let description = data["description"] as? String ?? ""
                let imageUrl = data["image"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Double ?? -1
                let restaurantId = data["restoranId"] as? Int ?? -1
                let id = data["id"] as? Int ?? -1
                let menuItem = MenuItem(id: id, categoryId: categoryId, description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId)
                if menuItems[categoryId] == nil {
                    menuItems[categoryId] = []
                }
                menuItems[categoryId]?.append(menuItem)
            }
        }
        return menuItems
    }
    
    func authentication(phoneNumber: String, verificationId: String) -> String?{
        var errorDescription: String?
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, error in
            if error != nil {
                errorDescription = error?.localizedDescription
            }
        }
        return errorDescription
    }
    
    func verification(verificationId: String, code: String)->String?{
        var errorDescription: String?
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        Auth.auth().signIn(with: credetional) { _, error in
            if error != nil {
                errorDescription = error?.localizedDescription
            }
        }
        return errorDescription
    }
       
}
