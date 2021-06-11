//
//  ProfileViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import SnapKit
import Firebase

class ProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let genders = ["Женский", "Мужской"]
    
    var fullName: String? {
        didSet{
            nameLabel.text = fullName
        }
    }
    var phoneNumber: String?{
        didSet{
            phoneNumberLabel.text = phoneNumber
        }
    }
    var gender: String?{
        didSet{
            genderTextField.text = gender
        }
    }
    var birthDate: String?{
        didSet{
            dateTextField.text = birthDate
        }
    }
    
    var qrUser: User?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 1
        stackView.axis = .vertical
        return stackView
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
    
    private let phoneView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let historyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 40
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
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
        textField.textColor = .black
        textField.font = .boldSystemFont(ofSize: 14)
        textField.placeholder = "Пол"
        return textField
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер телефона"
        label.textColor = .black
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let phoneEditButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "EditIcon"), for: .normal)
        // button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
    }()
    
    let pickerView = UIPickerView()
    
    private let cardLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои карты"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var cardbutton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(transitionToCardVC), for: .touchUpInside)
        return button
    }()
    
    private let cardNextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NextArrowIcon")
        return imageView
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "История заказов"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let historyNextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NextArrowIcon")
        return imageView
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
        button.alpha = 0.5
        button.isEnabled = false
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
        QRFirebaseDatabase.shared.getUser(uid: "wTkLYYvYSYaH3DClKLxG") { [weak self] user in
            DispatchQueue.main.async {
                guard user != nil else {return}
                self?.qrUser = user
                self?.assignValues()
            }
        }
    }
    
    @objc func logOutPressed(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func profileButtonTapped(){
        presentActionSheet()
    }
    
    @objc func transitionToCardVC(){
        let vc = CardViewController()
        vc.cards = qrUser?.cards
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func assignValues(){
        
        fullName = "\(qrUser?.name ?? "No") \(qrUser?.surname ?? "Name")"
        phoneNumber = qrUser?.phone
        gender = qrUser?.gender
        birthDate = qrUser?.birthDate
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
        view.addSubview(stackView)
        view.addSubview(saveButton)
        view.addSubview(logOutButton)
        profileView.addSubview(profileImageButton)
        profileView.addSubview(nameLabel)
        dateView.addSubview(dateLabel)
        dateView.addSubview(dateTextField)
        genderView.addSubview(genderLabel)
        genderView.addSubview(genderTextField)
        historyView.addSubview(historyLabel)
        historyView.addSubview(historyNextImageView)
        cardView.addSubview(cardLabel)
        cardView.addSubview(cardNextImageView)
        cardView.addSubview(cardbutton)
        phoneView.addSubview(phoneLabel)
        phoneView.addSubview(phoneNumberLabel)
        phoneView.addSubview(phoneEditButton)
        [profileView,phoneView,dateView,genderView,historyView,cardView].forEach{
            stackView.addArrangedSubview($0)
        }
    }
    
    func setupConstraints(){
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        profileView.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        phoneView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        dateView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        genderView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        historyView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        cardView.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        profileImageButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageButton.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        phoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(11)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(4)
        }
        phoneEditButton.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
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
        cardNextImageView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
        cardbutton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        historyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        historyNextImageView.snp.makeConstraints { make in
            make.height.width.equalTo(15)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentActionSheet(){
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete photo", style: .default, handler: { [weak self] _ in
            self?.deletePhoto()
        }))
        present(actionSheet, animated: true)
    }
    
    func deletePhoto(){
        self.profileImageButton.setBackgroundImage(nil, for: .normal)
        self.profileImageButton.backgroundColor = .white
    }
    
    func presentCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        self.profileImageButton.backgroundColor = .none
        self.profileImageButton.setBackgroundImage(selectedImage, for: .normal)
    }
}


