//
//  RestDetViewCont.swift
//  QRRestarantMenuApp
//
//  Created by Алишер Батыр on 10.06.2021.
//

import UIKit
import Firebase
import SnapKit
import FirebaseFirestore

class RestDetViewCont: UIViewController {
    
    lazy var view0: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        let label = UILabel()
        label.text = "Page 0"
        label.textAlignment = .center
        view.addSubview(label)
        //label.edgeTo(view: view)
        return view
    }()
    lazy var view1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        let label = UILabel()
        label.text = "Page 1"
        label.textAlignment = .center
        view.addSubview(label)
        //label.edgeTo(view: view)
        return view
    }()
    lazy var view2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        let label = UILabel()
        label.text = "Page 2"
        label.textAlignment = .center
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
            views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        
        //scrollView.delegate = self
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTaphandler(sender:)), for: .touchUpInside)
        return pageControl
    }()
    
    @objc func pageControlTaphandler(sender: UIPageControl){
        //scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
       
        navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        //scrollView.edgeTo(view: view)
        view.addSubview(pageControl)
        //pageControl.pinTo(view)
    }

}

extension RestDetViewCont: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
