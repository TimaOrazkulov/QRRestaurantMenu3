//
//  OrderSuccessfulViewController.swift
//  QrRestaurantMenuApp
//
//  Created by Temirlan Orazkulov on 17.06.2021.
//

import UIKit

class OrderSuccessfulViewController: UIViewController {

    var orderItems: [MenuItem : Int] = [:]
    var menuItems: [MenuItem] = []
    var totalPrice: Double?
    var totalCount: Int?
    
    private let doneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "doneIcon")
        return imageView
    }()
    
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ успешно оплачен!"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let orderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderSuccessfulTableViewCell.self, forCellReuseIdentifier: OrderSuccessfulTableViewCell.identifier)
        tableView.register(OrderSuccessfulTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "tableHeader")
        tableView.register(OrderSuccessfulTableViewFooter.self, forHeaderFooterViewReuseIdentifier: "tableViewFooter")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .none
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
        
    private lazy var exitButton: UIButton = {
        var button = UIButton()
        button.setTitle("На главную", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = #colorLiteral(red: 0.4862297773, green: 0.4863032103, blue: 0.4862136245, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        orderTableView.dataSource = self
        orderTableView.delegate = self
        dataParseToMenuItems()
        view.backgroundColor = #colorLiteral(red: 0.7958194613, green: 0.7514733672, blue: 0.7521334291, alpha: 1)
        setupConstraints()
    }
    
    func setupViews(){
        view.addSubview(doneImageView)
        view.addSubview(doneLabel)
        view.addSubview(orderTableView)
        view.addSubview(exitButton)
    }
    
    func setupConstraints(){
        doneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(250)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        doneLabel.snp.makeConstraints { make in
            make.top.equalTo(doneImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        orderTableView.snp.makeConstraints { make in
            make.top.equalTo(doneLabel.snp.bottom).offset(30)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(250)
        }
        exitButton.snp.makeConstraints { make in
            make.top.equalTo(orderTableView.snp.bottom).offset(50)
            make.right.left.equalToSuperview().inset(30)
            make.height.equalTo(55)
        }
    }
    
    func dataParseToMenuItems(){
        orderItems.keys.forEach { menuItem in
            menuItems.append(menuItem)
        }
    }
}


extension OrderSuccessfulViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderSuccessfulTableViewCell.identifier, for: indexPath) as! OrderSuccessfulTableViewCell
        cell.count = orderItems[menuItems[indexPath.row]]
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderSuccessfulTableViewFooter.identifier) as! OrderSuccessfulTableViewFooter
        if let price = totalPrice {
            view.totalPrice = price
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderSuccessfulTableViewHeader.identifier) as! OrderSuccessfulTableViewHeader
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
