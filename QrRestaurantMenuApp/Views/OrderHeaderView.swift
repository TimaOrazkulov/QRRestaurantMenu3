//
//  OrderHeaderView.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//

import UIKit

class OrderHeaderView: UITableViewHeaderFooterView {

    static var headerID = "orderHeaderID"
    
    var order: Order? {
        didSet {
            nameOfRestoran.text = order?.restaurantName
            numberOfTable.text = order?.seatNumber
            guard let price = order?.totalPrice else {return}
            totalPrice.text = "\(price) T"
            dateOfOrder.text = order?.date
        }
    }

    private let nameOfRestoran: UILabel = {
        let label = UILabel()
        label.text = "Luckee Yu"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private let numberOfTable: UILabel = {
        let label = UILabel()
        label.text = "Стол №5"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private let totalPrice: UILabel = {
        let label = UILabel()
        label.text = "\(16970) \u{20B8}"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    private let dateOfOrder: UILabel = {
        let label = UILabel()
        label.text = "1.06.2021"
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addViewAndContstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addViewAndContstraints() {
        contentView.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        contentView.addSubview(nameOfRestoran)
        contentView.addSubview(dateOfOrder)
        contentView.addSubview(totalPrice)
        contentView.addSubview(numberOfTable)

        nameOfRestoran.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().inset(20)
        }

        numberOfTable.snp.makeConstraints {
            $0.top.equalTo(nameOfRestoran.snp.bottom).offset(10)
            $0.left.equalToSuperview().inset(20)
        }

        totalPrice.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.right.equalToSuperview().inset(20)
        }

        dateOfOrder.snp.makeConstraints {
            $0.top.equalTo(totalPrice.snp.bottom).offset(20)
            $0.right.equalToSuperview().inset(10)
        }
    }
}
