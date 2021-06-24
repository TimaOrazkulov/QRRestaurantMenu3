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

    private var newCards: [String: Any]? {
        didSet {
            parseDataToCards()
        }
    }
    private var db = Firestore.firestore()
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
        QRFirebaseDatabase.shared.getCardsOfUser(uid: uid ?? "") { [weak self] cards in
            self?.newCards = cards
        }
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(popVC))
        tabBarController?.navigationItem.title = "Карты"
        
    }
    
    @objc private func popVC(){
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
            addCardVC.saveCard = { [weak self] in
                guard let uid = self?.uid else { return }
                QRFirebaseDatabase.shared.getCardsOfUser(uid: uid) { [weak self] (cards) in
                    self?.newCards = cards
                }
            }
             self?.navigationController?.present(addCardVC, animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }        
    
    private func parseDataToCards() {
        var updateCards: [Card] = []
        newCards?.forEach({ key, value in
            let info = value as? [String: Any]
            let cardNumber = info?["numberCard"] as? String
            let cardHolderName = info?["holderName"] as? String
            let cvv = info?["cvv"] as? String
            let date = info?["validDate"] as? String
            let card = Card(cardHolderName: cardHolderName, cardNumber: cardNumber, date: date, cvv: cvv, key: key)
            updateCards.append(card)
        })
        self.cards = updateCards
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
        newCards?[itemCard.key!] = nil
        cards?.removeAll(where: { card in
            if card == itemCard {
                return true
            }
            return false
        })
        db.collection("users").document("wTkLYYvYSYaH3DClKLxG").updateData([
            "cards": newCards
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
