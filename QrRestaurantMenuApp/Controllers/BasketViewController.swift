//
//  BasketViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 07.06.2021.
//

import UIKit
import FirebaseFirestore
import SnapKit
import FloatingPanel


class BasketViewController: UIViewController {

    var baskeView: BasketViewController!
    var floationgPanel = FloatingPanelController()
    var basketMenu: [MenuItem : Int] = [:] {
        didSet {
            basketTableView.reloadData()
        }
    }
    var menuItems: [MenuItem] = [] {
        didSet {
            basketTableView.reloadData()
        }
    }
    
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
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4195685685, green: 0.4196329713, blue: 0.4195545018, alpha: 1)
        view.layer.cornerRadius = 10
        view.isHidden = false
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.2784037888, green: 0.2784489989, blue: 0.2783938646, alpha: 1)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(basketViewOnTapped), for: .touchUpInside)
        return button
    }()
    
    private let basketNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого"
        label.textColor = #colorLiteral(red: 0.7175832391, green: 0.717688024, blue: 0.7175602913, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let basketCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 12)
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
        floationgPanel.delegate = self
        setupTableView()
        setupNavigationController()
        setupBasketView()
        setupConstraints()
        parseMenuData()
    }
    
    private func setupBasketView() {
        view.addSubview(basketView)
        basketView.addSubview(basketNameLabel)
        basketView.addSubview(basketCountLabel)
        basketView.addSubview(basketTotalPriceLabel)
        basketView.addSubview(basketButton)
    }
    
    
    private func setupNavigationController() {
        searchBar.sizeToFit()
        navigationItem.title = "Корзина"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
    }
    
    @objc func handleSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    @objc func basketViewOnTapped() {
        let selectVC = SelectCardViewController()
        floationgPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floationgPanel.set(contentViewController: selectVC)
            
        }
    }

    private func parseMenuData() {
        menuItems = Array(basketMenu.keys)
    }
    
    private func setupTableView() {
        view.addSubview(basketTableView)
        basketTableView.dataSource = self
        basketTableView.delegate = self
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
            $0.height.equalTo(60)
        }
        basketButton.snp.makeConstraints{
            $0.right.bottom.top.equalToSuperview().inset(10)
            $0.width.equalTo(135)
        }
        basketTotalPriceLabel.snp.makeConstraints{
            $0.left.equalToSuperview().inset(15)
            $0.top.equalToSuperview().inset(10)
        }
        basketNameLabel.snp.makeConstraints{
            $0.left.equalToSuperview().inset(15)
            $0.top.equalTo(basketTotalPriceLabel.snp.bottom)
            $0.bottom.equalToSuperview().inset(10)
        }
        basketCountLabel.snp.makeConstraints{
            $0.left.equalTo(basketNameLabel.snp.right).offset(5)
            $0.bottom.equalToSuperview().inset(10)
            $0.top.equalTo(basketTotalPriceLabel.snp.bottom)
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
        if let count = basketMenu[cell.menuItem!]{
        if count > 0  {
            cell.count = count
            cell.makeButtonBig()
            }
        }
        cell.delegate = self
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
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
    func plusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        counter += 1
        basketMenu[menuItem]! += 1
    }
    
    func minusButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice -= price
        counter -= 1
        if count == 0 {
            basketMenu[menuItem] = nil
            if basketMenu.isEmpty {
                basketView.isHidden = true
            }
        } else {
            basketMenu[menuItem]! -= 1
        }
    }
    
    func smallButtonTapped(menuItem: MenuItem, count: Int) {
        guard let price = menuItem.price else {return}
        totalPrice += price
        counter += 1
        basketMenu[menuItem] = 1
        basketView.isHidden = false
    }
    
    func closeButtonTapped(menuItem: MenuItem, count: Int) {
        menuItems.removeAll { item in
            if item == menuItem {
                return true
            }
            return false
        }
        basketMenu[menuItem] = nil
        guard let price = menuItem.price else {return}
        totalPrice -= price * Double(count)
        counter -= count
        if menuItems.isEmpty {
            basketView.isHidden = true
        }
    }
}
extension BasketViewController: FloatingPanelControllerDelegate {
    
}
