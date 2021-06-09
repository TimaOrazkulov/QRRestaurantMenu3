//
//  BasketViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 07.06.2021.
//

import UIKit
import FirebaseFirestore

class BasketViewController: UIViewController {

    var basketMenu: [MenuItem : Int] = [:]
    var menuItems: [MenuItem] = []
    
    var counter = 0 {
        didSet{
            basketCountLabel.text = String(counter)
        }
    }
    
    var totalPrice: Double = 0 {
        didSet{
            basketTotalPriceLabel.text = "\(totalPrice) \u{20B8}"
        }
    }
    
    private lazy var searchBar = UISearchBar()

    private let basketTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BasketTableViewCell.self, forCellReuseIdentifier: BasketTableViewCell.identifier)
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
        view.isHidden = false
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
        label.text = "Оплатить"
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
        setupNavigationController()
        setupBasketView()
        setupConstraints()
        parseMenuData()
    }
    
    func setupBasketView(){
        view.addSubview(basketView)
        basketView.addSubview(basketNameLabel)
        basketView.addSubview(basketCountLabel)
        basketView.addSubview(basketTotalPriceLabel)
        basketView.addSubview(basketButton)
    }
    
    
    private func setupNavigationController(){
        searchBar.sizeToFit()
        navigationItem.title = "Корзина"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
    }
    
    @objc func handleSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    @objc func basketViewOnTapped(){
        
    }

    private func parseMenuData() {
        
    }
    
    private func setupTableView() {
        view.addSubview(basketTableView)
    
        basketTableView.delegate = self
        basketTableView.dataSource = self
    }
    
    private func setupConstraints() {
        basketTableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
        basketView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(80)
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
}
extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketTableViewCell.identifier, for: indexPath) as! BasketTableViewCell
        cell.menuItem = menuItems[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension BasketViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
    }
}

extension BasketViewController: BasketTableViewCellDelegate{
    
    func plusButtonTapped(tableViewCell: BasketTableViewCell, quantityCounter: Int) -> Int {
        guard let basketItem = tableViewCell.menuItem else {return quantityCounter}
        guard let price = basketItem.price else {return quantityCounter}
        totalPrice += price
        counter += 1
        return quantityCounter + 1
    }
    func minusButtonTapped(tableViewCell: BasketTableViewCell, quantityCounter: Int) -> Int {
        guard let menuItem = tableViewCell.menuItem else {return quantityCounter}
        guard let price = menuItem.price else {return quantityCounter}
        counter -= 1
        totalPrice -= price
        if (quantityCounter - 1) == 0 {
            tableViewCell.minusButton.isHidden = true
            tableViewCell.countLabel.isHidden = true
            tableViewCell.plusButton.isHidden = true
            tableViewCell.countView.isHidden = true
            tableViewCell.smallButton.isHidden = false
        }
        return quantityCounter - 1
    }
    
    func smallButtonTapped(tableViewCell: BasketTableViewCell, quantityCounter: Int) -> Int {
        guard let basketItem = tableViewCell.menuItem else {return quantityCounter}
        guard let price = basketItem.price else {return quantityCounter}
        tableViewCell.smallButton.isHidden = true
        tableViewCell.countView.isHidden = false
        tableViewCell.minusButton.isHidden = false
        tableViewCell.countLabel.isHidden = false
        tableViewCell.plusButton.isHidden = false
        basketView.isHidden = false
        totalPrice += price
        counter += 1
        return quantityCounter + 1
    }
}
