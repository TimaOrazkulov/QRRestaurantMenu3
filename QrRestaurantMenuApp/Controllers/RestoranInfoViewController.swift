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
    
    private var restaurant: [Restaurant] = []
    
    private var db = Firestore.firestore()
    
//    private let restDetailImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleToFill
//        imageView.layer.cornerRadius = 20
//        return imageView
//    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
//        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //pageControl.numberOfPages = views.count
        //pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        return pageControl
    }()
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Luckee Yu - здесь должно быть какое-то описание. Например, какая кухня или как тут вкусно и красиво. Пока."
        label.textColor = .black
        label.numberOfLines = 3
        return label
    }()
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.text = "Адреса:"
        label.textColor = .black
        return label
    }()
    let locFirstLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Наурызбай батыра, 50"
        label.textColor = .black
        return label
    }()
    let locSecondLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.text = "Абылай хана, 175"
        label.textColor = .black
        return label
    }()
    
    let imagesArray = ["club1", "club2", "club3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        setupViews()
        setupConstraints()
        
        // Do any additional setup after loading the view.
        pageControl.numberOfPages = imagesArray.count
        
        for i in 0...imagesArray.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            //imageView.image = UIImage(named: imagesArray[i])
            let xPos = CGFloat(i)*self.view.bounds.size.width
            imageView.frame = CGRect(x: xPos, y: 0, width: view.frame.size.width, height: scrollView.frame.size.height)
            scrollView.contentSize.width = view.frame.width*CGFloat(i+1)
            scrollView.addSubview(imageView)
        }
   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.title = "Описание"
        tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(popVC))
    }
    
    @objc func popVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupViews(){
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(descLabel)
        view.addSubview(addressLabel)
        view.addSubview(locFirstLabel)
        view.addSubview(locSecondLabel)
    }
    
    func setupConstraints(){
        scrollView.snp.makeConstraints {  make in
            make.bottom.left.right.equalToSuperview().inset(30)
            make.width.equalTo(355)
            make.height.equalTo(150)
            
        }
        pageControl.snp.makeConstraints {  make in
            make.top.left.right.equalToSuperview().inset(10)
//            make.width.equalTo(355)
//            make.height.equalTo(150)
            make.bottom.equalToSuperview().offset(-180)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-60)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-20)
        }
        locFirstLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-20)
        }
        locSecondLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-20)
        }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width
        
        pageControl.currentPage = Int(page)
    }
   }
    
    private func getRestourans(){
        db.collection("restoran").addSnapshotListener { querySnapShot, error in
            guard let documents = querySnapShot?.documents else{
                print("No Documents")
                return
            }
            var arr: [Restaurant] = []
            documents.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let restImg = data["rest_image_url"] as? String ?? ""
                let id = data["id"] as? Int ?? 0
                let desc = data["rest_discription"] as? String ?? ""
                let restLoc = data["rest_locations"] as? Array<Location> ?? []
                print(restLoc)
                let name = data["rest_name"] as? String ?? ""
                let restorant = Restaurant(id: id, rest_name: name, rest_discription: desc, rest_image_url: restImg, rest_location: restLoc)
                arr.append(restorant)
               
            }

//    func downloadImage(from url: URL?) {
//        print("Download Started")
//        guard let url = url else { return }
//        getData(from: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            print(response?.suggestedFilename ?? url.lastPathComponent)
//            print("Download Finished")
//            // always update the UI from the main thread
//            DispatchQueue.main.async() { [weak self] in
//                self?.imageView.image = UIImage(data: data)
//            }
//        }
//    }

    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }
     }
    }

 }

