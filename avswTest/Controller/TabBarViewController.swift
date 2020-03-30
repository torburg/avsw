//
//  TabBarViewController.swift
//  avswTest
//
//  Created by Maksim Torburg on 27.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    lazy var editViewController: EditViewController = {
        let editViewController = EditViewController()
        let tabBarItem = UITabBarItem(title: "Edit", image: nil, tag: 0)
        editViewController.tabBarItem = tabBarItem
        return editViewController
    }()

    lazy var listViewController: ListViewController = {
        let listViewController = ListViewController()
        let tabBarItem = UITabBarItem(title: "List", image: nil, tag: 1)
        listViewController.tabBarItem = tabBarItem
        return listViewController
    }()

    lazy var aboutViewController: AboutViewController = {
        let aboutViewController = AboutViewController()
        let tabBarItem = UITabBarItem(title: "About", image: nil, tag: 2)
        aboutViewController.tabBarItem = tabBarItem
        return aboutViewController
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)

        self.viewControllers = [editViewController, listViewController, aboutViewController]
        self.selectedViewController = listViewController
    }
}
