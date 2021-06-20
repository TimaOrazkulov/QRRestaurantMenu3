//
//  User.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 10.06.2021.
//

import Foundation

struct Card : Codable, Hashable{
    var cardHolderName: String?
    var cardNumber: String?
    var date: String?
    var cvv: String?
    var key: String?
    var check: Bool?
}

struct User : Codable {
    var name: String?
    var profileURL: String?
    var surname: String?
    var phone: String
    var gender: String?
    var birthDate: String?
    var cards: [Card]?
}

struct Order: Codable {
    
}
