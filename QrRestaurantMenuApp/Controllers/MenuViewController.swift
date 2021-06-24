//
//  MenuViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 03.06.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import SnapKit
import AVFoundation


class MenuViewController: UIViewController {
            
    var session: AVCaptureSession?
    
    var countOfItems = 0 {
        didSet{
            basketCountLabel.text = "\(countOfItems)"
        }
    }
    
    var totalPrice: Double = 0 {
        didSet{
            basketTotalPriceLabel.text = "\(totalPrice) \u{20B8}"
        }
    }
    
    var basketItems: [MenuItem : Int] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    var categoriesForTableView: [Category] = [] {
        didSet{
            menuTableView.reloadData()
        }
    }
    
    private var categories: [Category] = [] {
        didSet {
            categoryCollectionView.reloadData()
            menuTableView.reloadData()
        }
    }
    
    var menuItems: [Int : [MenuItem]] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    
    var menuItemsForTableView: [Int : [MenuItem]] = [:] {
        didSet {
            menuTableView.reloadData()
        }
    }
    private var db = Firestore.firestore()
    
    private lazy var searchBar = UISearchBar()
    
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
    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.addTarget(self, action: #selector(basketViewOnTapped), for: .touchUpInside)
        return button
    }()
    
    private let basketNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let basketCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7332600355, green: 0.7333846688, blue: 0.7332436442, alpha: 1)
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let basketTotalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        setupTableView()
        getCategories()
        getMenuItems()
        setupBasketView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    func setupBasketView(){
        view.addSubview(basketView)
        basketView.addSubview(basketNameLabel)
        basketView.addSubview(basketCountLabel)
        basketView.addSubview(basketTotalPriceLabel)
        basketView.addSubview(basketButton)
    }
    
    func setupNavigationController(){
        searchBar.sizeToFit()
        tabBarController?.navigationItem.title = "Ресторан"
        tabBarController?.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        tabBarController?.navigationController?.navigationBar.tintColor = .black
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSearchBar(){
        tabBarController?.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        tabBarController?.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    @objc func basketViewOnTapped(){
        let vc = BasketViewController()
        vc.basketMenu = basketItems
        vc.totalPrice = totalPrice
        vc.counter = countOfItems
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTableView() {
        view.addSubview(categoryCollectionView)
        view.addSubview(menuTableView)
        menuTableView.register(SectionView.self, forHeaderFooterViewReuseIdentifier: SectionView.identifier)
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    private func setupConstraints() {
        categoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(160)
        }
        basketView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(50)
        }
        basketButton.snp.makeConstraints{
            $0.left.right.bottom.top.equalToSuperview()
        }
        basketNameLabel.snp.makeConstraints{
            $0.centerY.equalTo(basketView.snp.centerY)
            $0.left.equalTo(basketView.snp.left).inset(15)
        }
        basketCountLabel.snp.makeConstraints{
            $0.centerY.equalTo(basketView.snp.centerY)
            $0.left.equalTo(basketNameLabel.snp.right).offset(5)
        }
        basketTotalPriceLabel.snp.makeConstraints{
            $0.right.equalTo(basketView.snp.right).inset(15)
            $0.centerY.equalTo(basketView.snp.centerY)
        }
    }
    
    private func getCategories(){
        db.collection("category").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            var categories: [Category] = []
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? Int ?? 0
                let name = data["name"] as? String ?? ""
                categories.append(Category(id: id, name: name))
            }
            categories.append(Category(id: 5, name: "Все"))
            
            DispatchQueue.main.async {
                self.categories = categories
                self.categoriesForTableView = categories
            }
            
        }
    }
    
    private func getMenuItemsByCategoryId(id: Int){
       
        var menuItems: [Int : [MenuItem]] = [:]
        self.menuItems.forEach { categoryId, menuItem in
            if id == categoryId{
                menuItems[categoryId] = menuItem
            }
        }
        
        DispatchQueue.main.async {
            self.menuItemsForTableView = menuItems
        }
    }
    
    private func getMenuItems() {
        var menuItems: [Int : [MenuItem]] = [:]
        db.collection("menu").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("No Documents")
                return
            }
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let categoryId = data["categoryID"] as? Int ?? -1
                let description = data["description"] as? String ?? ""
                let imageUrl = data["image"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let price = data["price"] as? Double ?? -1
                let restaurantId = data["restoranId"] as? Int ?? -1
                let id = data["id"] as? Int ?? -1
                let menuItem = MenuItem(id: id, categoryId: categoryId, description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId)
                if menuItems[categoryId] == nil {
                    menuItems[categoryId] = []
                }
                menuItems[categoryId]?.append(menuItem)
            }
            DispatchQueue.main.async {
                self.menuItems = menuItems
                self.menuItemsForTableView = menuItems
            }
        }
    }
}

extension MenuViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCollectionViewCell
        if cell.categoryItem?.id == 5 {
            menuItemsForTableView = menuItems
            categoriesForTableView = categories
        }else{
            guard let item = cell.categoryItem else {return}
            guard let id = item.id else {return}
            getMenuItemsByCategoryId(id: id)
            categoriesForTableView = []
            categoriesForTableView.append(item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.restaurantId, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryItem = categories[indexPath.row]
        return cell
        
    }
}
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 104, height: 30)
    }
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if categoriesForTableView.count > 1 {
            return categoriesForTableView.count - 1
        }
        return categoriesForTableView.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItemsForTableView[categoriesForTableView[section].id!]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath) as! MenuTableViewCell
        cell.menuItem = menuItemsForTableView[categoriesForTableView[indexPath.section].id!]![indexPath.row]
        cell.delegate = self
        if let count = basketItems[cell.menuItem!] {
            if count > 0 {
                cell.count = count
                cell.makeButtonBig()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionView.identifier) as! SectionView
        view.category = categoriesForTableView[section]
        return view
    }
}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension MenuViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tabBarController?.navigationItem.titleView = nil
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        menuItemsForTableView = [:]
        categoriesForTableView = []
        if searchText == "" {
            menuItemsForTableView = menuItems
            categoriesForTableView = categories
        }else{
            menuItems.forEach { key, menuItem in
                menuItem.forEach { item in
                    guard let name = item.name else {return}
                    guard let description = item.description else {return}
                    if name.lowercased().contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased()){
                        if menuItemsForTableView[key] == nil {
                            menuItemsForTableView[key] = []
                        }
                        menuItemsForTableView[key]?.append(item)
                    }
                }
            }
            let keys = menuItemsForTableView.keys
            categories.forEach { category in
                if keys.contains(where: { key in
                    if category.id == key {return true}
                    return false
                }){
                    categoriesForTableView.append(category)
                }
            }
        }
    }
}

extension MenuViewController: MenuTableViewCellDelegate {
    
    func plusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        countOfItems += 1
        basketItems[menuItem]! += 1
    }
    
    func minusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice -= price
        countOfItems -= 1
        if count == 0 {
            basketItems[menuItem] = nil
            if basketItems.isEmpty {
                basketView.isHidden = true
            }
        } else {
            basketItems[menuItem]! -= 1
        }
    }
    
    func smallButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        countOfItems += 1
        basketItems[menuItem] = 1
        basketView.isHidden = false
    }
}

