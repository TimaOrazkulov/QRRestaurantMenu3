//
//  CardCellTableViewCell.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 9.06.2021.
//

import UIKit
import SnapKit

class CardCellTableViewCell: UITableViewCell {
    
    static var cardCell = "cardCell"
    
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let dotIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    lazy var removeButton: UIButton = {
        let removeBtn = UIButton()
        removeBtn.setImage(UIImage(named: "CloseButton"), for: .normal)
        removeBtn.addTarget(self, action: #selector(removeCard), for: .touchUpInside)
        return removeBtn
    }()
    private let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        return stackView
    }()
    
    private let nameCardLabel: UILabel = {
        let name = UILabel()
        name.text = "MasterCard"
        name.font = .systemFont(ofSize: 14)
        name.textColor = .black
        return name
    }()
    private let numberCardLabel: UILabel = {
        let number = UILabel()
        number.text = "5018"
        number.font = .systemFont(ofSize: 14)
        number.textColor = .black
        return number
    }()
    private let validDateLabel: UILabel = {
        let valid = UILabel()
        valid.text = "07/22"
        valid.font = .systemFont(ofSize: 14)
        valid.textColor = #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1)
        return valid
    }()
    
    var card: Card? {
        didSet {
            if let icon = UIImage(named: "masterCardIcon") {
                iconImage.image = icon
            }
//            if let brandCard = card?.cardName {
//                nameCardLabel.text = brandCard
//            }
            if let numberCard = card?.cardNumber {
                numberCardLabel.text = numberCard
            }
            if let validDate = card?.date {
                validDateLabel.text = validDate
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addToView()
        setupConstraints()
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @objc private func removeCard() {
        
    }
    private func addToView() {
        contentView.addSubview(iconImage)
        contentView.addSubview(removeButton)
        contentView.addSubview(validDateLabel)
        contentView.addSubview(cardStackView)
        
        [nameCardLabel, dotIcon, numberCardLabel].forEach { cardStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
            $0.left.equalToSuperview().inset(15)
            $0.height.width.equalTo(60)
        }
        
        cardStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15)
            $0.left.equalTo(iconImage.snp.right).offset(7)
        }
        validDateLabel.snp.makeConstraints {
            $0.top.equalTo(cardStackView.snp.bottom).offset(3)
            $0.left.equalTo(iconImage.snp.right).offset(7)
        }
        
        removeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11.5)
            $0.right.equalToSuperview().inset(14.5)
            $0.width.height.equalTo(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
