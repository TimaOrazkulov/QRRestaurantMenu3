//
//  MainPageViewController.swift
//  QRRestarantMenuApp
//
//  Created by Temirlan Orazkulov on 30.05.2021.
//

import UIKit
import SnapKit

class MainTabBar: UITabBarController {

    let errorMessage: UILabel = {
        let label = UILabel()
        label.text = "Ошибка при сканировании, попробуйте еще раз"
        return label
    }()
    private lazy var searchBar = UISearchBar()
    
    
    let qrImage = UIImage(named: "qr-code")
    let profileImage = UIImage(named: "profile")
    let homeImage = UIImage(named: "home")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate = self
        setupTabBar()
        view.backgroundColor = #colorLiteral(red: 0.7890606523, green: 0.7528427243, blue: 0.7524210811, alpha: 1)
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabBar.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        tabBar.layer.borderWidth = 0.50
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        let qrVC = UINavigationController(rootViewController:QRScannerViewController())
        qrVC.tabBarItem.image = qrImage
        qrVC.tabBarItem.title = "Заказать"

        let restVC = UINavigationController(rootViewController:RestaurantsViewController())
        restVC.tabBarItem.image = homeImage
        restVC.tabBarItem.title = "Рестораны"

        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        profileVC.tabBarItem.image = profileImage
        profileVC.tabBarItem.title = "Профиль"
        profileVC.tabBarController?.title = "Профиль"
        viewControllers = [restVC, qrVC, profileVC]

        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
        }

    }
}
