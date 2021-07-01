//
//  UserProfileViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 29.06.2021.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    // MARK: -Public properties
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
            guard let genderText = gender else {return}
            if !genderText.isEmpty {
                genderLabel.isHidden = false
            } else {
                genderLabel.isHidden = true
            }
            genderUserLabel.text = genderText
        }
    }
    var birthDate: String?{
        didSet{
            guard let dateText = birthDate else {return}
            if !dateText.isEmpty {
                dateLabel.isHidden = false
            } else {
                dateLabel.isHidden = true
            }
            dateUserLabel.text = dateText
        }
    }
    var uid = "wTkLYYvYSYaH3DClKLxG"
    var user: User?
    var uploadImage: UIImage?
    
    // MARK: -Private properties
    
    private let profileView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "profileImage"), for: .normal)
        button.layer.cornerRadius = 50
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "Ваше Имя"
        return label
    }()
    
    private lazy var editButton: UIButton = {
        var button = UIButton()
        button.setTitle("Редактировать профиль", for: .normal)
        button.setTitleColor(UIColor(red: 0.102, green: 0.667, blue: 0.545, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.text = "Номер телефона"
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+7 (747) 190 77 50"
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        return label
    }()
    
    private let spaceView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.text = "Дата рождения"
        label.isHidden = true
        return label
    }()
    
    private let dateUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "Дата рождения"
        return label
    }()
    
    private let spaceView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.353, green: 0.38, blue: 0.404, alpha: 1)
        label.font = UIFont(name: "Inter-Regular", size: 11.5)
        label.text = "Пол"
        label.isHidden = true
        return label
    }()
    
    private let genderUserLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "Пол"
        return label
    }()
    
    private let spaceView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.954, green: 0.954, blue: 0.954, alpha: 1)
        return view
    }()
    
    private let historyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var historyButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(transitionToHistory), for: .touchUpInside)
        return button
    }()
    
    private let historyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "История заказов"
        return label
    }()
    
    private let historyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NextArrowIcon")
        return imageView
    }()
    
    private let spaceView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cardButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(transitionToCardVC), for: .touchUpInside)
        return button
    }()
    
    private let cardLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.071, green: 0.2, blue: 0.298, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "Мои карты"
        return label
    }()
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NextArrowIcon")
        return imageView
    }()
    
    private let spaceView5: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.854, green: 0.854, blue: 0.854, alpha: 1)
        return view
    }()
    
    private let exitView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var exitButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .none
        return button
    }()
    
    private let exitLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.863, green: 0.103, blue: 0, alpha: 1)
        label.font = UIFont(name: "Inter-Medium", size: 17.5)
        label.text = "Выйти"
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let titleStackView = TabBarTitleView()
        titleStackView.title = "Профиль"
        tabBarController?.navigationItem.titleView = titleStackView
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        QRFirebaseDatabase.shared.getUser(uid: uid) { [weak self] user in
            DispatchQueue.main.async { [self] in
                guard user != nil else {return}
                self?.user = user
                self?.assignValues()
                guard let url = user?.profileURL else {return}
                self?.downloadImage(from: URL(string: url))
            }
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func profileButtonTapped(){
        presentActionSheet()
    }
    
    func downloadImage(from url: URL?) {
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.profileImageButton.setImage(UIImage(data: data), for: .normal)
            }
        }
    }
    
    func assignValues(){
        fullName = "\(user?.name ?? "Ваше") \(user?.surname ?? "Имя")"
        phoneNumber = user?.phone
        gender = user?.gender
        birthDate = user?.birthDate
    }
    
    @objc private func transitionToHistory(){
        let vc = OrdersHistoryViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func transitionToCardVC(){
        let vc = CardViewController()
        vc.cards = user?.cards
        vc.uid = uid
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @objc func editButtonTapped(){
        let vc = EditProfileViewController()
        vc.phoneNumber = phoneNumber
        vc.profilePhoto = profileImageButton.currentImage
        vc.uid = uid
        vc.birthDate = dateUserLabel.text
        vc.gender = genderUserLabel.text
        guard let fullName = fullName else {return}
        vc.name = String(fullName.split(separator: " ")[0])
        vc.surname = String(fullName.split(separator: " ")[1])
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func savePhotoInFirestore(){
        let docRef = Firestore.firestore().collection("users").document(uid)
        if let imageSelected = self.uploadImage {
            guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
            let storageRef = Storage.storage().reference(forURL: "gs://arcanaqrmenu.appspot.com")
            let storageProfileRef = storageRef.child("profilePictures").child(uid)
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageProfileRef.putData(imageData, metadata: metaData) { storageMetaData, error in
                guard let error = error else {return}
                print(error.localizedDescription)
            }
            storageProfileRef.downloadURL { url, error in
                if let imageURL = url?.absoluteString {
                    docRef.updateData(["profileURL" : imageURL])
                }
            }
        }
    }
    
    func setupViews(){
        [profileView, phoneLabel, phoneNumberLabel, spaceView1, dateLabel, dateUserLabel, spaceView2, genderLabel, genderUserLabel, spaceView3, historyView, spaceView4, cardView, spaceView5, exitView].forEach {
            view.addSubview($0)
        }
        [profileImageButton, nameLabel, editButton].forEach {
            profileView.addSubview($0)
        }
        historyView.addSubview(historyButton)
        historyView.addSubview(historyLabel)
        historyView.addSubview(historyImageView)
        cardView.addSubview(cardButton)
        cardView.addSubview(cardLabel)
        cardView.addSubview(cardImageView)
        exitView.addSubview(exitButton)
        exitView.addSubview(exitLabel)
    }
    
    func setupConstraints(){
        profileView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
            make.top.equalToSuperview().inset(120)
        }
        profileImageButton.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(profileImageButton.snp.right).offset(15)
        }
        editButton.snp.makeConstraints { make in
            make.left.equalTo(profileImageButton.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }
        phoneLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(profileView.snp.bottom).offset(20)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
        }
        spaceView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(18)
        }
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(spaceView1.snp.bottom).offset(18)
        }
        dateUserLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
        }
        spaceView2.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(dateUserLabel.snp.bottom).offset(18)
        }
        genderLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(spaceView2.snp.bottom).offset(18)
        }
        genderUserLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(genderLabel.snp.bottom).offset(5)
        }
        spaceView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(10)
            make.top.equalTo(genderUserLabel.snp.bottom).offset(18)
        }
        historyView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(spaceView3.snp.bottom)
            make.height.equalTo(75)
        }
        historyButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        historyLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        historyImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(27)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        spaceView4.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(historyView.snp.bottom)
        }
        cardView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(75)
            make.top.equalTo(spaceView4.snp.bottom)
        }
        cardButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        cardImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(27)
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        spaceView5.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview()
            make.top.equalTo(cardView.snp.bottom)
        }
        exitView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(75)
            make.top.equalTo(spaceView5.snp.bottom)
        }
        exitButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        exitLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentActionSheet(){
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would you like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        if profileImageButton.currentImage != UIImage(named: "profileImage") {
            actionSheet.addAction(UIAlertAction(title: "Delete photo", style: .default, handler: { [weak self] _ in
                self?.deletePhoto()
            }))
        }
        present(actionSheet, animated: true)
    }
    
    func deletePhoto(){
        profileImageButton.setImage(UIImage(named: "profileImage"), for: .normal)
        Firestore.firestore().collection("users").document(uid).updateData(["profileURL" : ""])
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
        uploadImage = selectedImage
        self.profileImageButton.setImage(selectedImage, for: .normal)
        savePhotoInFirestore()
    }
}
extension UserProfileViewController: EditProfileViewControllerDelegate {
    func saveButtonTapped(name: String, surname: String, gender: String, date: String) {
        fullName = "\(name) \(surname)"
        self.gender = gender
        birthDate = date        
    }
}
