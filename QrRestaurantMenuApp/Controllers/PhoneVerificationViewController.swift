 //
//  PhoneVerificationViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 31.05.2021.
//

import UIKit
import FirebaseAuth
import SnapKit
 
class PhoneVerificationViewController: UIViewController {
    
    var verificationId: String?
    
    var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    var textLabel: UILabel = {
        var label = UILabel()
        label.text = "Enter the code"
        label.textColor = .black
        label.font = label.font.withSize(20)
        return label
    }()
    
    var codeTextView: UITextView = {
        var textView = UITextView()
        textView.keyboardType = .numberPad
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    var sendButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отправить код", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6901960784, green: 0.662745098, blue: 0.662745098, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstaints()
        setupConfig()
        // Do any additional setup after loading the view.
    }
    
    @objc func sendButtonAction(){
        guard let code = codeTextView.text else {return}
        
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: verificationId!, verificationCode: code)
        
        Auth.auth().signIn(with: credetional) { (_, error) in
            if error != nil {
                let ac = UIAlertController(title: error?.localizedDescription, message: nil, preferredStyle: .alert)
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

    func setupConfig(){
        codeTextView.delegate = self
    }
    
    func setupConstaints(){
        view.backgroundColor = #colorLiteral(red: 0.8282918334, green: 0.798361063, blue: 0.7977046371, alpha: 1)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(100)
        }
        [textLabel, codeTextView, sendButton].forEach{
            stackView.addArrangedSubview($0)
        }
        codeTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        sendButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
    }
}
 
 extension PhoneVerificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentCharacterCount = textView.text.count
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + text.count - range.length
        return newLength <= 6
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count == 6 {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        }
        else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.5
        }
    }
 }
