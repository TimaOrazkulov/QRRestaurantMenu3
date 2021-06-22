//
//  RestaurantsViewController.swift
//  QRRestarantMenuApp
//
//  Created by IOS-Developer on 31.05.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class RestaurantsViewController: UIViewController  {

    private var restaurant: [Restaurant] = [] {
        didSet {
            restarauntTableView.reloadData()
        }
    }
    
    private var db = Firestore.firestore()
            
    private lazy var searchBar = UISearchBar()
    
    private let restarauntTableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantsTableViewCell.self, forCellReuseIdentifier: RestaurantsTableViewCell.identifire)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = #colorLiteral(red: 0.7863221765, green: 0.7518113256, blue: 0.752297163, alpha: 1)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        restarauntTableView.delegate = self
        restarauntTableView.dataSource = self
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
        getRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
      
    func setupNavigationController(){
        searchBar.sizeToFit()
        tabBarController?.navigationItem.title = "Ресторан"
        tabBarController?.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        tabBarController?.navigationController?.navigationBar.tintColor = .black
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
    }
    
    @objc func handleSearchBar(){
        tabBarController?.navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        tabBarController?.navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
    }
    
    private func getRestaurants(){
        db.collection("restoran").addSnapshotListener { querySnapShot, error in
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
                self.restaurant = arr
            }
            
        }
    }

    
    func setupViews(){
        view.addSubview(restarauntTableView)
    }
    
    func setupConstraints(){
        restarauntTableView.frame = view.bounds
    }
}

extension RestaurantsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant.count        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantsTableViewCell.identifire, for: indexPath) as! RestaurantsTableViewCell
        
        cell.restItem = restaurant[indexPath.row]
       
        return cell
        
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuVC = RestoranInfoViewController()
        menuVC.restaurant = restaurant[indexPath.row]
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200        
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tabBarController?.navigationItem.titleView = nil
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
    }
}

