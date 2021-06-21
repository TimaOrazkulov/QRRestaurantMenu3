//
//  OrderCell.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 20.06.2021.
//

import UIKit
import SnapKit

class OrderCell: UITableViewCell {
    
    static var orderID = "orderID"
    
    private let resName: UILabel = {
        let label = UILabel()
        label.text = "Luckee Yu"
        label.font = .systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    private let dateOrder: UILabel = {
        let label = UILabel()
        label.text = "1.06.2021"
        label.font = .systemFont(ofSize: 12)
        label.textColor = #colorLiteral(red: 0.4195591211, green: 0.4196358919, blue: 0.4195542336, alpha: 1)
        return label
    }()
    private let totalPrice: UILabel = {
        let label = UILabel()
        label.text = "16970 T"
        label.font = .systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var order: Order? {
        didSet {
            if let restName = order?.restaurantName {
                resName.text = restName
            }
            if let orderDate = order?.date {
                dateOrder.text = orderDate
            }
            if let totPrice = order?.totalPrice {
                totalPrice.text = String(totPrice) + " \u{20B8}"
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(resName)
        contentView.addSubview(dateOrder)
        contentView.addSubview(totalPrice)
        
        resName.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        dateOrder.snp.makeConstraints {
            $0.top.equalTo(resName.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(20)
        }
        totalPrice.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(26)
            $0.right.equalToSuperview().inset(20)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
