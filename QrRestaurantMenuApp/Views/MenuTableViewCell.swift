//
//  MenuTableViewCell.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 03.06.2021.
//

import UIKit
import Firebase
import SnapKit


protocol MenuTableViewCellDelegate: class {
    func plusButtonTapped(menuItem: MenuItem, count: Int)
    func minusButtonTapped(menuItem: MenuItem, count: Int)
    func smallButtonTapped(menuItem: MenuItem, count: Int)
}

class MenuTableViewCell: UITableViewCell {
    static let identifier = "productCell"
    var count = 0 {
        didSet {
            countLabel.text = "\(count)"
        }
    }
    weak var delegate: MenuTableViewCellDelegate?
    
    var menuItem: MenuItem? {
        didSet {
            if let image = menuItem?.imageUrl {
                downloadImage(from: URL(string: image))
            }
            if let name = menuItem?.name {
                nameLabel.text = name
            }
            if let price = menuItem?.price {
                priceLabel.text = String(price) + " \u{20B8}"
            }
            if let description = menuItem?.description {
                descriptionLabel.text = description
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let menuImageView: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    let countView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.668738544, green: 0.6788057089, blue: 0.6612537503, alpha: 1)
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        view.isHidden = true
        return view
    }()
    
    let buttonStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.isUserInteractionEnabled = true
        stackView.axis = .horizontal
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(plusCount), for: .touchUpInside)
        return button
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(minusCount), for: .touchUpInside)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.isHidden = true
        return button
    }()
    
    
    lazy var smallButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.layer.cornerRadius = 11
        button.backgroundColor = #colorLiteral(red: 0.668738544, green: 0.6788057089, blue: 0.6612537503, alpha: 1)
        button.addTarget(self, action: #selector(smallButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.contentView.isUserInteractionEnabled = true
        isUserInteractionEnabled = true
    }
    
    private func setupViews(){
        
        contentView.addSubview(countView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(menuImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(smallButton)
        
        [minusButton, countLabel, plusButton].forEach{
            buttonStackView.addArrangedSubview($0)
        }
        countView.addSubview(buttonStackView)
    }
    
    
    
    @objc private func plusCount() {
            count += 1
            delegate?.plusButtonTapped(menuItem: menuItem!, count: count)
        }
        @objc private func minusCount() {
            count -= 1
            if count == 0 {
                minusButton.isHidden = true
                countLabel.isHidden = true
                plusButton.isHidden = true
                countView.isHidden = true
                smallButton.isHidden = false
            }
            delegate?.minusButtonTapped(menuItem: menuItem!, count: count)
        }
        
        @objc private func smallButtonAction() {
            count = 1
            smallButton.isHidden = true
            countView.isHidden = false
            minusButton.isHidden = false
            countLabel.isHidden = false
            plusButton.isHidden = false
            delegate?.smallButtonTapped(menuItem: menuItem!, count: count)
        }
    
    func downloadImage(from url: URL?) {        
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.menuImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setupConstraints(){
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(10)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(menuImageView.snp.left).offset(7)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(12)
        }
        menuImageView.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().inset(5)
            make.width.equalTo(103)
            make.height.equalTo(90)
        })
        
        countView.snp.makeConstraints { make in
            make.top.equalTo(menuImageView.snp.bottom).offset(6)
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(22)
            make.width.equalTo(103)
        }
        smallButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.top.equalTo(menuImageView.snp.bottom).offset(6)
            make.width.height.equalTo(22)
        }
        minusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        plusButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.right.left.bottom.equalToSuperview()
        }
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
