//
//  CardViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 9.06.2021.
//

import UIKit
import FirebaseFirestore
import SnapKit

class CardViewController: UIViewController {

    private var db = Firestore.firestore()
   // weak var footerView: FooterView?
    var cards: [Card]?
    var uid: String?
    private let cardTableView: UITableView = {
        let table = UITableView()
        table.register(CardCellTableViewCell.self, forCellReuseIdentifier: CardCellTableViewCell.cardCell)
        table.register(FooterView.self, forHeaderFooterViewReuseIdentifier: "footerID")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        setupTableView()
        setupConstraintsTableView()
        title = "Мои карты"
    }       
    
    private func setupTableView() {
        view.addSubview(cardTableView)
        cardTableView.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        cardTableView.delegate = self
        cardTableView.dataSource = self
    }
    
    private func setupConstraintsTableView() {
        cardTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.right.left.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    private func moveToAddCards() {
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nудалить карту?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
            // let addCardVC = AddCardViewController()
            // self?.navigationController?.present(addCardVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
extension CardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCellTableViewCell.cardCell, for: indexPath) as! CardCellTableViewCell
        cell.card = cards?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterView.footerID) as! FooterView
        footer.addCard = { [weak self] in self?.moveToAddCards() }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
