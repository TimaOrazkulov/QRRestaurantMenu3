//
//  AddCardViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 10.06.2021.
//

import UIKit
import SnapKit
import FirebaseFirestore

class AddCardViewController: UIViewController {
    
    var saveCard: (() -> Void)?
    private let db = Firestore.firestore()
    var newCards: [String: Any]?
    var cards: [Card]? = []
    private let addCardLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить карту"
        label.textAlignment = .left
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "remove"), for: .normal)
        button.addTarget(self, action: #selector(tapDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.4862189293, green: 0.4863064885, blue: 0.4862134457, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addCard), for: .touchUpInside)
        return button
    }()
    
    private let allElements: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    private let dateAndCvv: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    private let numCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        return view
    }()
    
    private let nameCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        return view
    }()
    
    private let validDateCard: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        return view
    }()
    
    private let cvvView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8195181489, green: 0.8196596503, blue: 0.8195091486, alpha: 1)
        return view
    }()
    
    private let numberCard: CardTextField = {
        let textField = CardTextField(placeholderText: "Номер карты", keyboard: .decimalPad)
        return textField
    }()

    private let holderName: CardTextField = {
        let textField = CardTextField(placeholderText: "Имя Фамилия", keyboard: .default)
        textField.autocapitalizationType = .allCharacters
        return textField
    }()
    
    private let validDate: CardTextField = {
        let textField = CardTextField(placeholderText: "ММ/ГГ", keyboard: .decimalPad)
        return textField
    }()
    
    private let cvvCode: CardTextField = {
        let textField = CardTextField(placeholderText: "CVV", keyboard: .decimalPad)
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addElements()
        setupConstraints()
        addTextFieldDelegate()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        QRFirebaseDatabase.shared.getCardsOfUser(uid: uid) { [weak self] cards in
            self?.newCards = cards
        }
    }
    
    private func addTextFieldDelegate() {
        numberCard.delegate = self
        holderName.delegate = self
        validDate.delegate = self
        cvvCode.delegate = self
    }
    private func addElements() {
        view.addSubview(addCardLabel)
        view.addSubview(cancelButton)
        view.addSubview(addButton)
        view.addSubview(allElements)
        cvvView.addSubview(cvvCode)
        numCard.addSubview(numberCard)
        nameCard.addSubview(holderName)
        validDateCard.addSubview(validDate)
        [numCard, nameCard, dateAndCvv].forEach { allElements.addArrangedSubview($0) }
        [validDateCard, cvvView].forEach { dateAndCvv.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        addCardLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.left.equalToSuperview().inset(20)
        }
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37.75)
            $0.trailing.equalToSuperview().inset(27.75)
        }
        allElements.snp.makeConstraints {
            $0.top.equalTo(addCardLabel.snp.bottom).offset(49)
            $0.left.right.equalToSuperview().inset(20)
        }
        numberCard.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        holderName.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        validDate.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        cvvCode.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(18)
            $0.left.equalToSuperview().inset(20)
        }
        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(57)
            $0.right.left.equalToSuperview().inset(30)
            $0.height.equalTo(53)
        }
    }
  
    @objc private func tapDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let uid = "wTkLYYvYSYaH3DClKLxG"
    
    private func parseDataCard(uid: String) {
        
        let key = "card\(newCards?.count ?? 0 + 1)"
        let value = ["cvv" : cvvCode.text, "holderName" : holderName.text, "numberCard" : numberCard.text, "validDate" : validDate.text]
        
        newCards?[key] = value
        
    }
    
    @objc private func addCard() {
        let document = db.collection("users").document(uid)
        parseDataCard(uid: uid)
        document.updateData(["cards": newCards ?? 0
        ])
        saveCard?()
        dismiss(animated: true, completion: nil)
    }
}
extension AddCardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String

        if numberCard == textField {
            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            return false
        } else if validDate == textField {
            textField.text = lastText.format("XX / NN", oldString: text)
            return false
        } else if cvvCode == textField {
            textField.text = lastText.format("NNN", oldString: text)
            return false
        }
        return true
    }
}
