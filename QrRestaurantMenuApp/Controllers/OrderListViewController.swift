//
//  OrderListViewController.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//

import UIKit
import FloatingPanel
import Firebase

class OrderListViewController: UIViewController {

    var order: Order? {
        didSet {
            assignOrderItems()            
        }
    }
    
    var restaurants: [Restaurant] = []
    
    var orderItems: [OrderItem] = []
    
    var floationgPanel = FloatingPanelController()
    
    private let orderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        tableView.register(OrderHeaderView.self, forHeaderFooterViewReuseIdentifier: "orderHeaderID")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()


    private let orderView: UIView = {
        let view = UIView()
        //view.backgroundColor = #colorLiteral(red: 0.2784313725, green: 0.2784313725, blue: 0.2784313725, alpha: 1)
        view.layer.cornerRadius = 10
        view.isHidden = true
        view.isUserInteractionEnabled = true
        return view
    }()

    private let orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .none
        button.setTitle("Заказать снова", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(orderAgain), for: .touchUpInside)
        return button
    }()

    private let orderNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let orderCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.7332600355, green: 0.7333846688, blue: 0.7332436442, alpha: 1)
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    func parseOrderToMenu(order: Order) -> [MenuItem]{
        var menuItems: [MenuItem] = []
        order.orderItems?.forEach({ key, orderItem in
            menuItems.append(MenuItem(id: orderItem.id, categoryId: orderItem.categoryId, description: orderItem.description, imageUrl: orderItem.imageUrl, name: orderItem.name, price: orderItem.price, restaurantId: orderItem.restaurantId))
        })
        return menuItems
    }

    func parseOrderToBasket(order: Order) -> [MenuItem : Int]{
        var menuItems: [MenuItem : Int] = [:]
        order.orderItems?.forEach({ key, orderItem in
            menuItems[MenuItem(id: orderItem.id, categoryId: orderItem.categoryId, description: orderItem.description, imageUrl: orderItem.imageUrl, name: orderItem.name, price: orderItem.price, restaurantId: orderItem.restaurantId)] = orderItem.count
        })
        return menuItems
    }
    
    private func getRestaurants(){
        Firestore.firestore().collection("restoran").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            var arr: [Restaurant] = []
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let id = data["id"] as? Int ?? 0
                let desc = data["rest_description"] as? String ?? ""
                let restLoc = data["rest_locations"] as? [String] ?? []
                let name = data["rest_name"] as? String ?? ""
                let restImg = data["rest_image_url"] as? String ?? ""
                var locArr: [String] = []
                restLoc.forEach { location in
                    locArr.append(location)
                }
                let restorant = Restaurant(id: id, rest_name: name, rest_description: desc, rest_image_url: restImg, rest_location: locArr)
                arr.append(restorant)
            }
            
            DispatchQueue.main.async {
                self.restaurants = arr
            }
            
        }
    }
    
    @objc func orderAgain() {
        let selectVC = SelectCardViewController()
        guard let order = order else {return}
        selectVC.totalPrice = order.totalPrice
        selectVC.menuItems = parseOrderToMenu(order: order)
        selectVC.orderItems = parseOrderToBasket(order: order)
        selectVC.result = "1_5"
        selectVC.restaurants = restaurants
        floationgPanel.addPanel(toParent: self, at: 3, animated: true) {
            self.floationgPanel.set(contentViewController: selectVC)
        }
    }

    func assignOrderItems(){
        order?.orderItems?.forEach({ key, orderItem in
            orderItems.append(orderItem)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        getRestaurants()
        setupTableView()
        setupConstraintsTableView()
        tabBarController?.navigationItem.rightBarButtonItem = nil
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        tabBarController?.navigationItem.title = "История заказов"        
    }

    private func setupConstraintsTableView() {
        view.addSubview(orderButton)
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(100)
            $0.right.left.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }

    }
    
    @objc private func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }

    private func setupTableView(){
        view.addSubview(orderTableView)
        orderTableView.frame = view.bounds
        orderTableView.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        orderTableView.delegate = self
        orderTableView.dataSource = self
    }

}


extension OrderListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell
        cell.orderItem = orderItems[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderHeaderView.headerID) as! OrderHeaderView
        header.order = order
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
