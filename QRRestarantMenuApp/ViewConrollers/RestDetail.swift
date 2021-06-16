//
//  RestDetail.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 07.06.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class RestDetail: UIViewController {
    
    private var restaurant: [Restaurant] = []
    
    private var db = Firestore.firestore()
    
    private let restDetailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var view0: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        let label = UILabel()
        label.text = "Page 1"
        label.textAlignment  = .center
        view.addSubview(label)
       //label.edgeTo(view: view)
        return view
    }()
    lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        let label = UILabel()
        label.text = "Page 2"
        label.textAlignment  = .center
        view.addSubview(label)
        //label.edgeTo(view: view)
        return view
    }()
    lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        let label = UILabel()
        label.text = "Page 3"
        label.textAlignment  = .center
        view.addSubview(label)
        //label.edgeTo(view: view)
        return view
    }()
    
    lazy var views = [view0, view1, view2]
    
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)

        for i in 0..<views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0 , width: view.frame.width, height: view.frame.height)
        }

        scrollView.delegate = self
        return scrollView
    }()
    
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.numberOfPages = views.count
        //pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
        return pageControl
    }()


    let descLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
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
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    let locSecondLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
        view.addSubview(scrollView)
      
        setupConstraints()
        getRestourans()
        
    }
    
    func setupConstraints(){
//  contentView.addSubview(restImage)
//        contentView.addSubview(restNameLabel)
//
//        restImage.snp.makeConstraints { make in
//            make.top.left.right.equalToSuperview().inset(10)
//            make.width.equalTo(355)
//            make.height.equalTo(150)
//        }
//        restNameLabel.snp.makeConstraints { make in
//            make.top.equalTo(restImage.snp.bottom).offset(7)
//            make.left.equalToSuperview().inset(10)
//
//        }
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
                let restorant = Restaurant(id: id, rest_name: name, rest_discription: desc, rest_image_url: restImg, rest_locations: restLoc)
                arr.append(restorant)
               
            }

    func downloadImage(from url: URL?) {
        print("Download Started")
        guard let url = url else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.restDetailImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }
    }
  }
}
extension RestDetail: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
     }
    
}
