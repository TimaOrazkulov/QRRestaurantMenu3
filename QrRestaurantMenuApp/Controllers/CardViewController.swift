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
    var cards: [Card]? {
        didSet {
            cardTableView.reloadData()
        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Карты"
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(transitionToProfile))
    }
    
    @objc private func transitionToProfile(){
        _ = navigationController?.popViewController(animated: true)
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
        let alert = UIAlertController(title: "", message: "Вы действительно хотите \nдобавить карту?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
            self?.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { [weak self]  action in
             let addCardVC = AddCardViewController()
             self?.navigationController?.present(addCardVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

}
extension CardViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CardCellTableViewCell.cardCell, for: indexPath) as! CardCellTableViewCell
        cell.card = cards?[indexPath.row]
        cell.delegate = self
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

extension CardViewController: CardCellDelegate {
    func deleteCard(itemCard: Card) {
        db.collection("users").document("wTkLYYvYSYaH3DClKLxG").updateData([
            "cards": FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
            self.cards?.removeAll { item in
                if item == itemCard {
                    return true
                }
                return false
            }
        }
        
       
    }
}
