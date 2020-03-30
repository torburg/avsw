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
        Storage.instance.load()
        personList = Storage.instance.elements.sorted{ $0.updatedAt > $1.updatedAt }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusableIndentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        Storage.instance.load()
        personList = Storage.instance.elements.sorted{ $0.updatedAt > $1.updatedAt }
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
        let editViewController = tabBarController?.viewControllers![0] as! EditViewController
        let person = personList[indexPath.row]
        editViewController.setData(person)
        tabBarController?.selectedIndex = 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        addButton.addTarget(self, action: #selector(createNewPerson), for: .touchUpInside)
        addButton.setTitle("Add new one", for: .normal)
        addButton.setTitleColor(.systemBlue, for: .normal)
        return addButton
    }

    @objc func createNewPerson(_ sender: UIButton) {
        let editViewController = tabBarController?.viewControllers![0] as! EditViewController
        editViewController.setData(nil)
        tabBarController?.selectedIndex = 0
    }
}
