//
//  RestScrollViewController.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 14.06.2021.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore


class RestScrollViewController: UIViewController, UIScrollViewDelegate {
    
    private var restaurant: [Restaurant] = []
    var ref: DatabaseReference!
    
    private var db = Firestore.firestore()
    
    
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
 
    
    
    
    let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width:375,height: 300))
    //var colors:[UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow]
    var pageViews:[UIImageView?] = []
   
        var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
        var pageControl : UIPageControl = UIPageControl(frame: CGRect(x:80,y: 290, width:200, height:50))
        var pageImages: [UIImage] = [
             UIImage(named:"club1")!,
             UIImage(named:"club2")!,
             UIImage(named:"club3")!,
             UIImage(named:"club4")!,
            ]
    

        override func viewDidLoad() {
            super.viewDidLoad()
            configurePageControl()
            scrollView.delegate = self
            scrollView.isPagingEnabled = true
            view.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.7529411765, alpha: 1)
            setupViews()
            setupConstraints()
            self.view.addSubview(scrollView)
            for index in 0..<4 {
                

                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size
                self.pageControl.numberOfPages = self.pageImages.count
               // self.pageControl.currentPage = self.firstToShow

                let subView = UIView(frame: frame)
                //subView.backgroundColor = colors[index]
                //var imageView: UIImageView = UIImageView()
                self.scrollView .addSubview(subView)
            }

            self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
           //pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)

        }
    
    
    var restItem: Restaurant? {
        didSet {
            guard let restItem = restItem else {return}
            if let image = restItem.rest_image_url {
                downloadImage(from: URL(string: image))
            }
            if let restName = restItem.rest_discription {
                descLabel.text = restName
            }
//            if let restLocFirst = restItem.rest_locations {
//                locFirstLabel.text = restLocFirst
//            }
//            if let restLocSecond = restItem.rest_locations {
//                locSecondLabel.text = restLocSecond
//            }
            
        }
    }
    
    

        func configurePageControl() {
            // The total number of pages that are available is based on how many available colors we have.
            //self.pageControl.numberOfPages = colors.count
            self.pageControl.currentPage = 0
            self.pageControl.tintColor = UIColor.red
            self.pageControl.pageIndicatorTintColor = UIColor.white
            self.pageControl.currentPageIndicatorTintColor = UIColor.darkGray
            self.view.addSubview(pageControl)

        }

        // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
        func changePage(sender: AnyObject) -> () {
            let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
            scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
    func retrieveProducts(){
        ref.child("restoran").child("friends").observe(.value, with: {
                      (snapshot) in

                   print(snapshot)
                   print("HERE IS SNAPSHOT")
                   let value = snapshot.value as? NSDictionary
                   let icon  = value?["icon"] as? String ?? ""
                   let price = value?["price"] as? String ?? ""
                   let name  = value?["name"] as? String ?? ""
                   let structure = value?["structure"] as? String ?? ""
//                   let product = Product(name: name, icon: icon, price: price, structure: structure)
                   //self.products.append(product)

           })

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
                //self?.restImage.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
                let id = data["id"] as? Int ?? 0
                let desc = data["rest_discription"] as? String ?? ""
                let restLoc = data["rest_locations"] as? Array<Location> ?? []
                let name = data["rest_name"] as? String ?? ""
                let restImg = data["rest_image_url"] as? String ?? ""
                let restorant = Restaurant(id: id, rest_name: name, rest_discription: desc, rest_image_url: restImg, rest_locations: restLoc)
                arr.append(restorant)
                print(arr)
            }
            
            DispatchQueue.main.async {
                self.restaurant = arr
            }
            
        }
    }
    
    
    func setupViews(){
     
        view.addSubview(descLabel)
        view.addSubview(addressLabel)
        view.addSubview(locFirstLabel)
        view.addSubview(locSecondLabel)
    }
    func setupConstraints(){
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
    
    }
}
    
    
    
    

