//
//  EditViewController.swift
//  avswTest
//
//  Created by Maksim Torburg on 27.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    var person: Person?

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var attributes: UITableView!
    @IBAction func addNewAttribute(_ sender: Any) {
    }
    @IBAction func deletePerson(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    func setView() {
        let navigationItem = UINavigationItem()
        let discardChangesButton = UIBarButtonItem(title: "Discard Changes", style: .plain, target: self, action: #selector(discardChanges))
        discardChangesButton.tintColor = .systemRed
        navigationItem.leftBarButtonItem = discardChangesButton
        let saveChangesButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveChanges))
        saveChangesButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = saveChangesButton
        navigationBar.items = [navigationItem]
    }

    @objc func discardChanges() {
        print(#function)
    }
    @objc func saveChanges() {
        print(#function)
        guard let name = name.text, !name.isEmpty else {
            // TODO: Create Alert
            return
        }
        var newPerson: Person?
        if let lastPerson = person {
            newPerson = Person(id: lastPerson.id,
                                name: name,
                                attributes: [],
                                createdAt: lastPerson.createdAt,
                                updatedAt: Date())
        } else {
            newPerson = Person(id: UUID(),
                                name: name,
                                attributes: [],
                                createdAt: Date(),
                                updatedAt: Date())
        }
        do {
            try Storage.instance.save(newPerson!)
        }
        catch {
            print(error)
        }
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}
