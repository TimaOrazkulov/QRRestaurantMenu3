//
//  OrdersHistoryViewController.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 20.06.2021.
//

import UIKit

class OrdersHistoryViewController: UIViewController {
    
    var order: [Order]? {
        didSet {
            orderList.reloadData()
        }
    }
    private let orderList: UITableView = {
        let table = UITableView()
        table.register(OrderCell.self, forCellReuseIdentifier: OrderCell.orderID)
        table.register(OrderFooter.self, forHeaderFooterViewReuseIdentifier: "footerID")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(orderList)
        orderList.dataSource = self
        orderList.delegate = self
        
        orderList.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(10)
        }
    }

}
extension OrdersHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.orderID, for: indexPath) as! OrderCell
        cell.order = order?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderFooter.footerID) as! OrderFooter
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
}
extension OrdersHistoryViewController: UITableViewDelegate {
    
}
