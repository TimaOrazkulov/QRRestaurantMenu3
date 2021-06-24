//
//  OrdersHistoryViewController.swift
//  QrRestaurantMenuApp
//
//  Created by IOS-Developer on 20.06.2021.
//

import UIKit
import Firebase

class OrdersHistoryViewController: UIViewController {
    
    var uid: String = "wTkLYYvYSYaH3DClKLxG"
    
    var orders: [Order]? {
        didSet {
            orderList.reloadData()
        }
    }
    
    private let orderList: UITableView = {
        let table = UITableView()        
        table.register(OrderCell.self, forCellReuseIdentifier: OrderCell.orderID)
        table.separatorStyle = .none
        let viewForTableBackground: UIView = {
            let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
            return view
        }()
        table.backgroundView = viewForTableBackground
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        getOrdersOfUser()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        tabBarController?.navigationItem.title = "История заказов"
    }
    
    private func setupTableView() {
        view.addSubview(orderList)
        orderList.dataSource = self
        orderList.delegate = self
        orderList.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    @objc private func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func getOrdersOfUser() {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.getDocument { documentSnapshot, _ in
            if let document = documentSnapshot, document.exists {
                guard let data = document.data() else { return }
                var orderList: [Order] = []
                let orders = data["orders"] as! [String : Any]
                orders.forEach { key, order in
                    let orderData = orders[key] as! [String : Any]
                    let date = orderData["date"] as? String ?? ""
                    let restaurantName = orderData["restaurantName"] as? String ?? ""
                    let seatNumber = orderData["seatNumber"] as? String ?? ""
                    let totalPrice = orderData["totalPrice"] as? Double ?? 0
                    let orderItems = orderData["orderItems"] as! [String : Any]
                    var orderItemList: [String : OrderItem] = [:]
                    orderItems.forEach { key, orderItem in
                        let orderItemData = orderItems[key] as! [String : Any]
                        let description = orderItemData["description"] as? String ?? ""
                        let name = orderItemData["name"] as? String ?? ""
                        let imageUrl = orderItemData["imageUrl"] as? String ?? ""
                        let count = orderItemData["count"] as? Int ?? 0
                        let price = orderItemData["price"] as? Double ?? 0
                        let restaurantId = orderItemData["restaurantId"] as? Int ?? 0
                        let orderItem = OrderItem(description: description, imageUrl: imageUrl, name: name, price: price, restaurantId: restaurantId , count: count)
                        orderItemList[key] = orderItem
                    }
                    let order = Order(restaurantName: restaurantName, date: date, totalPrice: totalPrice, seatNumber: seatNumber, orderItems: orderItemList)
                    orderList.append(order)
                }
                
                DispatchQueue.main.async {
                    self.orders = orderList
                }
            }
        }
    }
}

extension OrdersHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.orderID, for: indexPath) as! OrderCell
        cell.order = orders?[indexPath.row]
        return cell
    }
}
extension OrdersHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
