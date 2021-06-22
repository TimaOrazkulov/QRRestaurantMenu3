//
//  RestoranInfoViewController.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 10.06.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class RestoranInfoViewController: UIViewController, UIScrollViewDelegate {
    
    private var db = Firestore.firestore()
    
    var restaurant: Restaurant? {
        didSet {
            downloadImage(from: URL(string: restaurant?.rest_image_url ?? ""))
            descLabel.text = restaurant?.rest_description
            addressTableView.reloadData()
        }
    }
                    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.layer.cornerRadius = 10
        scrollView.contentMode = .scaleAspectFit
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        // pageControl.numberOfPages = scrollView.accessibilityElementCount()
        // pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        return pageControl
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Luckee Yu - здесь должно быть какое-то описание. Например, какая кухня или как тут вкусно и красиво. Пока."
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Адреса:"
        label.textColor = .black
        return label
    }()
    
    private let addressTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(RestaurantInfoTableViewCell.self, forCellReuseIdentifier: RestaurantInfoTableViewCell.identifier)
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
        addressTableView.dataSource = self
        addressTableView.delegate = self
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Описание"
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(popVC))
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
       
    func setupViews(){
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(descLabel)
        view.addSubview(addressLabel)
        view.addSubview(addressTableView)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(200)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom).offset(10)
        }
        descLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(pageControl.snp.bottom).offset(25)
        }
        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.top.equalTo(descLabel.snp.bottom).offset(15)
        }
        addressTableView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(250)
        }
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        
        pageControl.currentPage = Int(page)
    }

    func downloadImage(from url: URL?) {
        print("Download Started")
       guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
           print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
    
            DispatchQueue.main.async() { [weak self] in
                guard let image = UIImage(data: data) else {return}
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                self?.scrollView.addSubview(imageView)
            }
        }
    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }

}

extension RestoranInfoViewController: UITableViewDataSource, UITableViewDelegate{
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurant?.rest_location.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantInfoTableViewCell.identifier) as! RestaurantInfoTableViewCell
        cell.addressText = restaurant?.rest_location[indexPath.row]
        return cell
    }
    
}
