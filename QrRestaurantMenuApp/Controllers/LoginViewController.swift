//
//  LoginViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 30.05.2021.
//

import UIKit
import SnapKit
import FlagPhoneNumber
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    var phoneNumber: String?
    private let stackViewPage: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let logoImageVew: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.image = UIImage(imageLiteralResourceName: "logo")
        return imageView
    }()
    
    private let phoneTextField: FPNTextField = {
        var textField = FPNTextField()
        textField.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.keyboardType = .phonePad
        textField.displayMode = .list
        return textField
    }()
    
    var listController: FPNCountryListViewController!
    
    private let errorLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = label.font.withSize(12)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loginButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отправить код", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        //UIColor(red: 0x7C, green: 0x7C, blue: 0x7C, alpha: 1.0)
        button.setTitleColor(.black, for: .normal)
        //button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        setupConstraints()
        setupConfig()
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func loginButtonAction() {
        guard phoneNumber != nil else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationId, error in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            }else {
                self.transitionToVerificationView(verificationId: verificationId)
            }
        }
    }
    
    private func transitionToVerificationView(verificationId: String?) {
        let verificationVC = PhoneVerificationViewController()
        verificationVC.verificationId = verificationId
        navigationController?.pushViewController(verificationVC, animated: true)
    }
    
    private func setupConfig() {
        phoneTextField.delegate = self
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = {
            country in self.phoneTextField.setFlag(countryCode: country.code)
        }
    }
    
    private func setupConstraints(){
        view.addSubview(logoImageVew)
        view.addSubview(stackViewPage)
        [phoneTextField,errorLabel,loginButton].forEach{
            stackViewPage.addArrangedSubview($0)
        }
        logoImageVew.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(130)
            make.top.equalToSuperview().offset(124)
            make.centerX.equalToSuperview()
        }
        stackViewPage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.top.equalTo(logoImageVew.snp.bottom).offset(60)
        }
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}

extension LoginViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        ///
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            loginButton.alpha = 1
            loginButton.isEnabled = true
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        }else{
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        phoneTextField.text = ""
        self.present(navigationController, animated: true)
    }
}

