//
//  ListViewController.swift
//  avswTest
//
//  Created by Maksim Torburg on 26.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var personList = [Person]()

    let reusableIndentifier = "personListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.selectedViewController = self
        personList = Storage.instance.elements
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableIndentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        Storage.instance.load()
        personList = Storage.instance.elements
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reusableIndentifier)
        if personList.isEmpty {
            return cell
        }
        let person = personList[indexPath.row]
        cell.textLabel?.text = person.name
        var attributes = String()
        for attribute in person.attributes {
            attributes += "\(attribute.name); "
        }
        cell.detailTextLabel?.text = attributes
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
