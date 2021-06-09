//
//  RestaurantsViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class RestaurantsViewController: UIViewController {
    
    private var restaurant: [Restaurant]? {
        didSet {
            
        }
    }
    private var db = Firestore.firestore()   
    
    private let restarauntTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        layer.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layer)
        collection.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.restaurantId)
        return collection
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Рестораны"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(named: "searchButton"), for: .normal)
       button.addTarget(self, action: #selector(showSearchView), for: .touchUpInside)
        return button
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "searchButton")
        imageView.backgroundColor = .none
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .none
        textField.placeholder = "Поиск"
        textField.font = .systemFont(ofSize: 12)
        textField.textColor = .black
        return textField
    }()
    
    private lazy var cancelSearchButton: UIButton = {
        var button = UIButton()
        button.setTitle("Отмена", for:  .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .none
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(cancelSearchButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
    }
    
    @objc func showSearchView(){
        searchView.isHidden = false
        restaurantNameLabel.isHidden = true
        searchButton.isHidden = true
    }
    
    @objc func cancelSearchButtonAction(){
        searchView.isHidden = true
        restaurantNameLabel.isHidden = false
        searchButton.isHidden = false
    }
    
    func getRestauran() {
        
    }
    
    
    func setupViews(){
        [searchImageView, searchTextField, cancelSearchButton].forEach{
            searchView.addSubview($0)
        }
        [restaurantNameLabel, searchButton, searchView].forEach{ view.addSubview($0) }
    }
    
    func setupConstraints(){
        restaurantNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(109)
            make.centerX.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(118)
            make.right.equalToSuperview().inset(25)
            make.width.height.equalTo(15)
        }
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(109)
            make.height.equalTo(44)
        }
        searchImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(13.75)
            make.width.height.equalTo(11)
        }
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchImageView.snp.right).offset(8.45)
            make.right.equalTo(cancelSearchButton.snp.left).offset(20)
        }
        cancelSearchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(14)
        }
    }
}
