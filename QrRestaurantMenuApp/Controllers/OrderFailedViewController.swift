//
//  OrderFailedViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class OrderFailedViewController: UIViewController {
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Не удалось оплатить заказ"
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let tryOnceMoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Попробуйте еще раз"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var tryOnceMoreButton: UIButton = {
        var button = UIButton()
        button.setTitle("Попробовать снова", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4862297773, green: 0.4863032103, blue: 0.4862136245, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    private lazy var changePaymentButton: UIButton = {
        var button = UIButton()
        button.setTitle("Другой способ оплаты", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4862297773, green: 0.4863032103, blue: 0.4862136245, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    private lazy var cancelOrderButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отменить заказ", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4862297773, green: 0.4863032103, blue: 0.4862136245, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        [errorLabel, tryOnceMoreLabel, buttonStackView].forEach {
            view.addSubview($0)
        }
        [tryOnceMoreButton, changePaymentButton, cancelOrderButton].forEach{
            buttonStackView.addArrangedSubview($0)
        }
        
    }
    
    func setupConstraints(){
        errorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.centerX.equalToSuperview()
        }
        tryOnceMoreLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorLabel.snp.bottom).offset(10)
        }
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(tryOnceMoreLabel.snp.bottom).offset(75)
        }
        tryOnceMoreButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        changePaymentButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
        cancelOrderButton.snp.makeConstraints { make in
            make.height.equalTo(55)
        }
    }
    
}
