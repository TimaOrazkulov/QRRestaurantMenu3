//
//  ProfileViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let genders = ["Женский", "Мужской"]
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.axis = .vertical
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Нурай Киматова"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+7 (747) 190 77 50"
        label.textColor = .black
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата рождения"
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let datePicker = UIDatePicker()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.text = "10 марта 2000"
        textField.textColor = .black
        textField.font = .boldSystemFont(ofSize: 14)
        textField.placeholder = "Дата рождения"
        return textField
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.text = "Пол"
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        return label
    }()

    private let genderTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Женский"
        textField.textColor = .black
        textField.font = .boldSystemFont(ofSize: 14)
        textField.placeholder = "Пол"
        return textField
    }()
    
    let pickerView = UIPickerView()
    
    private let cardLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои карты"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    
    private let dateView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let genderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle( "Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6274509804, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle( "Сохранить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        navigationItem.title = "Профиль"
        setupViews()
        setupConstraints()
        createDatePicker()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @objc func logOutPressed(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.tabBarController?.tabBar.isHidden = true
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDatePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        toolbar.setItems([cancelBtn,spaceButton,doneBtn], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        genderTextField.inputView = pickerView
        genderTextField.textAlignment = .center
        
    }
    
    @objc func doneDatePressed(){
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy"
        
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(){
        self.view.endEditing(true)
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genders[row]
        genderTextField.resignFirstResponder()
    }
    
    func setupViews(){
        profileView.addSubview(profileImageView)
        profileView.addSubview(nameLabel)
        profileView.addSubview(phoneLabel)
        dateView.addSubview(dateLabel)
        dateView.addSubview(dateTextField)
        genderView.addSubview(genderLabel)
        genderView.addSubview(genderTextField)
        cardView.addSubview(cardLabel)
        [profileView,dateView,genderView,cardView].forEach{
            stackView.addArrangedSubview($0)
        }
        view.addSubview(stackView)
        view.addSubview(saveButton)
        view.addSubview(logOutButton)
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        profileView.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        dateView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        genderView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        cardView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(15)
            make.top.equalToSuperview().inset(30)
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(profileImageView.snp.right).offset(15)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(11)
        }
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(20)
        }
        genderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(11)
        }
        genderTextField.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(20)
        }
        cardLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        logOutButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(52)
        }
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(logOutButton.snp.top).offset(-10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(52)
        }
    }
}


