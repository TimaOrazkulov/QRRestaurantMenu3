//
//  SnackbarViewController.swift
//  QRRestarantMenuApp
//
//  Created by ryan on 6/12/21.
//
import Foundation
import UIKit
import SnapKit
import FlagPhoneNumber
import FirebaseAuth
import Firebase

import UIKit

class SnackbarViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var phoneNumber: String?
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var listController: FPNCountryListViewController!

    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    private var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Войти в аккаунт"
        label.textColor = .black
        label.font = label.font.withSize(20)
        return label
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

    private var sendButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отправить код", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 1
        return button
    }()

    @objc private func sendButtonAction() {
        guard phoneNumber != nil else {return}
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationId, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            }else {
                self.transitionToVerificationView(verificationId: verificationId)
            }
        }
    }
    private let transition = PanelTransition()

    private func transitionToVerificationView(verificationId: String?) {
        let child = PhoneVerificationViewController()
        child.transitioningDelegate = transition   // 2
        child.modalPresentationStyle = .custom  // 3
        child.verificationId = verificationId
        present(child, animated: true)
//        let verificationVC = ProfilePhoneVerificationViewController()
//        verificationVC.verificationId = verificationId
//        navigationController?.pushViewController(verificationVC, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.isHidden = true
        
//        let slideVC = OverlayView()
//        slideVC.modalPresentationStyle = .custom
//        slideVC.transitioningDelegate = self
//        self.present(slideVC, animated: true, completion: nil)
//
        setupConfig()
        setupConstraints()

        // Do any additional setup after loading the view.
    }
    private func setupConfig() {
        phoneTextField.delegate = self
        listController = FPNCountryListViewController(style: .grouped)
        listController?.setup(repository: phoneTextField.countryRepository)
        listController.didSelect = {
            country in self.phoneTextField.setFlag(countryCode: country.code)
        }
    }

    func setupConstraints(){

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
        }
        [textLabel, phoneTextField, sendButton].forEach{
            stackView.addArrangedSubview($0)
        }
        textLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(124)
            make.centerX.equalToSuperview()
        }

        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        
    }
}

extension SnackbarViewController: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {

    }

    func fpnDisplayCountryList() {
        let navigationController = UINavigationController(rootViewController: listController)
        listController.title = "Countries"
        phoneTextField.text = ""
        self.present(navigationController, animated: true)
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            sendButton.alpha = 1
            sendButton.isEnabled = true
            phoneNumber = textField.getFormattedPhoneNumber(format: .International)
        }else{
            sendButton.alpha = 0.5
            sendButton.isEnabled = false
        }
    }
}
//
//extension SnackbarViewController: UIViewControllerTransitioningDelegate {
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        PresentationController(presentedViewController: presented, presenting: presenting)
//    }
//}
//

//
//    let viewModel: SnackbarViewModel
//    private func checkAuth() {
//        if Auth.auth().currentUser?.uid == nil {
//            print("Salamaleikum")
//        }
//    }
//
//    private lazy var label1 = UILabel = {
//        let label = UILabel()
//        label.textColor = .label
//    }
//    private func configure(){
//        switch viewModel.type {
//
//        case .action(let handler):
//            self.handler = handler
//            isUserInteractionEnabled = true
//            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSnackbar))
//        case .info:
//            break
//        }
//    }
//
//    init(viewModel: SnackbarViewModel) {
//        self.viewModel = viewModel
//        super.init(frame: .zero)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
