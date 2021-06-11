//
//  User.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 10.06.2021.
//

import Foundation

struct Card : Codable, Hashable{
    var cardName: String?
    var cardNumber: String?
    var date: String?
}

struct User : Codable {
    var name: String?
    var surname: String?
    var phone: String
    var gender: String?
    var birthDate: String?
    var cards: [Card]?
}
