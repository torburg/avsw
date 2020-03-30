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
    var attributes: [Attribute]?

    var activeTextField: UITextField?

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var attributesView: UITableView!
    @IBOutlet weak var newAttribute: UITextField!

    @IBAction func addNewAttribute(_ sender: Any) {
        guard let name = newAttribute.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "Name of attribute is empty", message: "Please fill the attribute name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let attribute = Attribute(id: UUID(), name: name)
        if let _ = attributes {
            attributes?.append(attribute)
        } else {
            self.attributes = []
            attributes?.append(attribute)
        }
        let indexPath = IndexPath(row: attributes!.count - 1, section: 0)
        attributesView.beginUpdates()
        attributesView.insertRows(at: [indexPath], with: .automatic)
        attributesView.endUpdates()

        newAttribute.text = ""
        newAttribute.resignFirstResponder()
    }
    @IBAction func deletePerson(_ sender: Any) {
        guard let deletingPerson = person else {
            let alertController = UIAlertController(title: "Cannot delete empty person", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let alertController = UIAlertController(title: "You want to delete Person", message: "Are your sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            do {
                try Storage.instance.delete(deletingPerson)
            }
            catch {
                print(error)
            }
            self.setData(nil)
            self.tabBarController?.selectedIndex = 1
        })
        self.present(alertController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setNotifications()
        setGesturesRecogrizers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setData(_ person: Person?) {
        if let newPerson = person {
            self.person = person
            name.text = newPerson.name
            self.attributes = newPerson.attributes
        } else {
            self.person = nil
            name.text = ""
            self.attributes = []
        }
        attributesView.reloadData()
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

    func setNotifications() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func setGesturesRecogrizers() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func discardChanges() {
        guard let person = self.person else {
            setData(nil)
            return
        }
        setData(person)
    }
    @objc func saveChanges() {
        guard let name = name.text, !name.isEmpty else {
            let alertController = UIAlertController(title: "Name of person is empty", message: "Please fill the person name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        var newPerson: Person?
        let attributes = self.attributes ?? []
        if let lastPerson = person {
            newPerson = Person(id: lastPerson.id,
                                name: name,
                                attributes: attributes,
                                createdAt: lastPerson.createdAt,
                                updatedAt: Date())
        } else {
            newPerson = Person(id: UUID(),
                                name: name,
                                attributes: attributes,
                                createdAt: Date(),
                                updatedAt: Date())
        }
        do {
            try Storage.instance.save(newPerson!)
        }
        catch {
            print(error)
        }
        self.person = newPerson!
        tabBarController?.selectedIndex = 1
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let attributes = attributes else {
            return 0
        }
        return attributes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let attributes = attributes,
            !attributes[indexPath.row].name.isEmpty else {
            return cell
        }
        cell.textLabel?.text = attributes[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {_,_,_ in
            self.attributes?.remove(at: indexPath.row)
            self.attributesView.deleteRows(at: [indexPath], with: .fade)
        }
        action.backgroundColor = .red
        return action
    }
}

extension EditViewController: UITextFieldDelegate {

    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else {
            print("Can't get keyboardRect from \(notification)")
            return
        }
        if (notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification) &&
            activeTextField == newAttribute {
            view.frame.origin.y = -keyboardRect.height + (tabBarController?.tabBar.frame.height ?? 49)
        } else {
            view.frame.origin.y = 0
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
