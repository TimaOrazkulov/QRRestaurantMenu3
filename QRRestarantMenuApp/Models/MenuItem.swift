//
//  MenuItem.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 04.06.2021.
//

import Foundation

//struct MenuItem {
//    var id: Int?
//    var categoryId: Int?
//    var description: String?
//    var imageUrl: String?
//    var name: String?
//    var price: Double?
//    var restaurantId: Int?
//
//    var dictionary: [String: Any] {
//        return [
//            "id": id as Any,
//            "categoryId": categoryId as Any,
//            "description": description as Any,
//            "imageUrl": imageUrl as Any,
//            "name": name as Any,
//            "price": price as Any,
//            "restaurantId": restaurantId as Any
//        ]
//    }
//}
//extension MenuItem {
//    init?(dictionary: [String: Any], id: String) {
//        guard let id = dictionary["id"] as? Int,
//              let categoryId = dictionary["categoryId"] as? Int,
//              let description = dictionary["description"] as? String,
//              let imageUrl = dictionary["imageUrl"] as? String,
//              let name = dictionary["name"] as? String,
//              let price = dictionary["price"] as? Double,
//              let restaurantId = dictionary["restaurantId"] as? Int
//        else { return nil }
//
//        self.init(id: id, categoryId: categoryId, description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId)
//    }
//}
struct MenuItem : Codable {
    var id: Int?
    var categoryId: Int?
    var description: String?
    var imageUrl: String?
    var name: String?
    var price: Double?
    var restaurantId: Int?
}

