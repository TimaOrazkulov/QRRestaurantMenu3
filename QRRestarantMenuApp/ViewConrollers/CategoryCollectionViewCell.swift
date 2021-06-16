//
//  RestaurantCollectionViewCell.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 4.06.2021.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static var restaurantId = "restaurantId"
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    var categoryItem: Category? {
        didSet {
            if let categoryName = categoryItem?.name {
                categoryLabel.text = categoryName
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraint()
    }
    
    private func setupConstraint() {
        contentView.addSubview(view)
        view.addSubview(categoryLabel)
        
        view.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.right.equalTo(view.snp.right)
            $0.left.equalTo(view.snp.left)
            $0.bottom.equalTo(view.snp.bottom)
//            $0.height.equalTo(82)
//            $0.width.equalTo(30)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
