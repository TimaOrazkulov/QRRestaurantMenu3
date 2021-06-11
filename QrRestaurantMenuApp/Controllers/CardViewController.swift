//
//  CardViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 10.06.2021.
//

import UIKit

class CardViewController: UIViewController {
            
    var cards: [Card]?
    
    private let cardTableView: UITableView = {
        let table = UITableView()
        table.register(CardCellTableViewCell.self, forCellReuseIdentifier: CardCellTableViewCell.cardCell)
        table.register(FooterView.self, forHeaderFooterViewReuseIdentifier: "footerID")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = "Мои карты"
    }
    
    private func setupTableView() {
        view.addSubview(cardTableView)
        cardTableView.frame = view.bounds
        cardTableView.delegate = self
        cardTableView.dataSource = self
    }
    
    
    private func moveToAddCards() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nудалить карту?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
            // let addCardVC = AddCardViewController()
            // self?.navigationController?.present(addCardVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
extension CardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCellTableViewCell.cardCell, for: indexPath) as! CardCellTableViewCell
        cell.card = cards?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterView.footerID) as! FooterView
        footer.addCard = { [weak self] in self?.moveToAddCards() }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}

import UIKit
import SnapKit

class CardCellTableViewCell: UITableViewCell {
    
    static var cardCell = "cardCell"
    
    private let iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "masterCardIcon")
        return image
    }()
    private let dotIcon: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.image = UIImage(named: "dotIcon")
        return icon
    }()
    lazy var removeButton: UIButton = {
        let removeBtn = UIButton()
        removeBtn.setImage(
            UIImage(named: "CloseButton"), for: .normal)
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
            if let icon = UIImage(named: "masketCardIcon") {
                iconImage.image = icon
            }
            if let brandCard = card?.cardName {
                nameCardLabel.text = brandCard
            }
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
