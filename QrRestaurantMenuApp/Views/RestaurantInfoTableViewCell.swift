//
//  RestaurantInfoTableViewCell.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class RestaurantInfoTableViewCell: UITableViewCell {

    static let identifier = "tableViewCell"
   
    
    var addressText: String? {
        didSet{
            addressLabel.text = addressText
        }
    }
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()       
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(addressLabel)
        backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
