 //
//  PhoneVerificationViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 31.05.2021.
//

import UIKit
import FirebaseAuth
import SnapKit
 
class PhoneVerificationViewController: UIViewController, UITextFieldDelegate {

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.tintColor = .clear
        textField.textColor = .clear
        textField.keyboardType = .numberPad
        textField.textContentType = .oneTimeCode
        textField.backgroundColor = .clear
        textField.isOpaque = true
        return textField
    }()

    var verificationId: String?

    var didEnterLastDigit: ((String) -> Void)?

    private var isConfigured = false

    private var digitLabels = [UILabel]()

    var count = 5

    var resendTimer = Timer()

    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Введите код из СМС"
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(20)
        return label
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        //print(textField.text)
        print("SUKAAAAAAAA")
        return recognizer
    }()

    func configure() {
        guard isConfigured == false else { return }
        isConfigured.toggle()

//        let reco = UITapGestureRecognizer(target: textField, action: #selector(textDidChange))
//        textField.addGestureRecognizer(tapRecognizer)



    }

    @objc private func textDidChange() {

        guard let text = textField.text, text.count <= digitLabels.count else { return }

        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]

            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = "_"
            }
        }

        if text.count == digitLabels.count {
            didEnterLastDigit?(text)
        }
    }


    private func createLabelsStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        for _ in 1 ... 6 {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.isUserInteractionEnabled = true
            label.text = "-"
            label.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)

            stackView.addArrangedSubview(label)

            digitLabels.append(label)
        }

        return stackView
    }

    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подтвердить", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()

    lazy var changeNumber: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить номер", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(changeNumberAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()


    lazy var resendCode: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setTitle("Отправить код еще раз", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(resendCodeAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()

    @objc func resendCodeAction(){
        let phoneNumber = LoginViewController().phoneNumber
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber!, uiDelegate: nil) { verificationId, error in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
            }else {
                let verificationVC = PhoneVerificationViewController()
                verificationVC.verificationId = verificationId
                self.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
    
    lazy var timer: UIButton = {
        let button = UIButton()
        //button.setTitle("Отправка следующего кода через:", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.337254902, green: 0.337254902, blue: 0.337254902, alpha: 1), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        //button.addTarget(self, action: #selector(changeNumberAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()

    @objc func update() {
        if(count > 0) {
            count = count - 1
            print(count)
            timer.setTitle("Отправка следующего кода через: \(count)", for: .normal)
        }
        else {
            resendTimer.invalidate()
            timer.isHidden = true
            resendCode.isHidden = false
            print("call your api")
            // if you want to reset the time make count = 60 and resendTime.fire()
        }
    }

    private let transition = PanelTransition()      // 1

    @objc func changeNumberAction(){
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
        let child = SnackbarViewController()
        child.transitioningDelegate = transition   // 2
        child.modalPresentationStyle = .custom  // 3

        present(child, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
      
        setupConstraints()

        didEnterLastDigit = { code in
            print(code)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func sendButtonAction(){

        guard let code = textField.text else {return}

        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!,verificationCode: code)

        Auth.auth().signIn(with: credetional) { (_, error) in
            if error != nil {
                let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle:.alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)

                ac.addAction(cancel)
                self.present(ac, animated: true)
            } else {
                self.transitionToQR()
            }
        }
    }
    
    func transitionToQR(){
        let vc = MainTabBar()
        navigationController?.pushViewController(vc, animated: true)
    }

    func setupConstraints(){
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.addSubview(stackView)
        let labelsStackView = createLabelsStackView()

        view.addSubview(textLabel)
        view.addSubview(sendButton)
        view.addSubview(changeNumber)
        view.addSubview(labelsStackView)
        view.addSubview(textField)
        view.addSubview(timer)
        view.addSubview(resendCode)
        labelsStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
//        textField.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.right.equalToSuperview().inset(0)
//            make.height.equalTo(50)
//        }

        timer.snp.makeConstraints{ make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        resendCode.snp.makeConstraints{ make in
            make.top.equalTo(labelsStackView.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        changeNumber.snp.makeConstraints{ make in
            make.top.equalTo(timer.snp.bottom).offset(0)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        textLabel.snp.makeConstraints { make in
            make.bottom.equalTo(labelsStackView.snp.top).offset(0)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(changeNumber.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
    }
}
 
 extension PhoneVerificationViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count || string == ""
    }
 }
