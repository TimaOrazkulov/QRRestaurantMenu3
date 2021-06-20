//
//  OrderListViewController.swift
//  QrRestaurantMenuApp
//
//  Created by ryan on 6/20/21.
//

import UIKit

class OrderListViewController: UIViewController {
//    table.register(CardCellTableViewCell.self, forCellReuseIdentifier: CardCellTableViewCell.cardCell)
//

    private let orderTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
        tableView.register(OrderHeaderView.self, forHeaderFooterViewReuseIdentifier: "orderHeaderID")
        return tableView
    }()

    var countOfItems = 0 {
        didSet{
            orderCountLabel.text = "\(countOfItems)"
        }
    }


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
        //button.frame.size.height = 100
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



    @objc func orderAgain() {

    }



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        setupTableView()
        setupConstraintsTableView()
        title = "История заказов"

    }

    private func setupConstraintsTableView() {
        view.addSubview(orderButton)
        orderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.right.left.equalToSuperview().inset(10)
        }

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
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as! OrderTableViewCell

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: OrderHeaderView.headerID) as! OrderHeaderView
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
}
