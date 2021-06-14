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
            
    private let restarauntTableView: UITableView = {
        let table = UITableView()
        table.register(RestaurantsTableViewCell.self, forCellReuseIdentifier: RestaurantsTableViewCell.identifire)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = #colorLiteral(red: 0.7863221765, green: 0.7518113256, blue: 0.752297163, alpha: 1)
        return table
    }()
    
    private let searchBar = UISearchBar()
    
    private let categoryCollectionView: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.scrollDirection = .horizontal
        layer.minimumLineSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layer)
        collection.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collection.showsHorizontalScrollIndicator = false
        collection.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.restaurantId)
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restarauntTableView.frame = view.bounds
        restarauntTableView.delegate = self
        restarauntTableView.dataSource = self
        
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
        getRestaurants()
    }
    
    func setupNavigationController(){
        searchBar.sizeToFit()
        navigationItem.title = "Ресторан"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.delegate = self
    }
    
    @objc func handleSearchBar(){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
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
                let desc = data["rest_discription"] as? String ?? ""
                let restLoc = data["rest_locations"] as? Array<Location> ?? []
                let name = data["rest_name"] as? String ?? ""
                let restImg = data["rest_image_url"] as? String ?? ""
                let restorant = Restaurant(id: id, rest_name: name, rest_discription: desc, rest_image_url: restImg, rest_location: restLoc)
                arr.append(restorant)
                print(arr)
            }
            
            DispatchQueue.main.async {
                self.restaurant = arr
            }
            
        }
    }

    
    func setupViews(){
        view.addSubview(restarauntTableView)
        view.addSubview(categoryCollectionView)
    }
    
    func setupConstraints(){
        restarauntTableView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(20)
        }
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(150)
            make.height.equalTo(50)
        }
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
        // let menuVC = RestDetail()
        // navigationController?.pushViewController(menuVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearchBar))
        searchBar.showsCancelButton = false
    }
}
