//
//  AuthorizationViewController.swift
//  avswTest
//
//  Created by Maksim Torburg on 26.03.2020.
//  Copyright © 2020 Maksim Torburg. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func logInButtonPressed(_ sender: Any) {
        guard let name = name.text else {
            print("Cannot get name from UITextField")
            fatalError()
        }
        let inputtedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if inputtedName.isEmpty {
            self.name.text = ""
            self.password.text = ""
            presentAlert(forEmpty: "Name")
            return
        }
        guard let password = password.text else {
            print("Cannot get password from UITextField")
            fatalError()
        }
        let inputtedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        if inputtedPassword.isEmpty {
            self.password.text = ""
            presentAlert(forEmpty: "Password")
            return
        }
        
        let group = DispatchGroup()
        runProgressBarAnimate(in: group)
        group.notify(queue: DispatchQueue.main) {
            self.logIn(name: inputtedName, password: inputtedPassword)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
    }
    
    func runProgressBarAnimate(in group: DispatchGroup) {
        group.enter()
        var progress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            self.progressBar.isHidden = false
            guard self.progressBar.progress < 1.0 else {
                timer.invalidate()
                group.leave()
                return
            }
            progress += 0.05
            self.progressBar.setProgress(Float(progress), animated: true)
        }
    }
    
    func logIn(name inputtedName: String, password inputtedPassword: String) {
        let storedUserName = Bundle.main.object(forInfoDictionaryKey: "UserName") as! String
        let storedPassword = Bundle.main.object(forInfoDictionaryKey: "UserPassword") as! String
        if inputtedName != storedUserName || inputtedPassword != storedPassword {
            self.password.text = ""
            self.progressBar.setProgress(0.0, animated: false)
            self.progressBar.isHidden = true
            let alertController = UIAlertController(title: "We haven't user with such name and/or password", message: "Please check your input data", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let tabBarViewController = TabBarViewController()
            tabBarViewController.modalPresentationStyle = .fullScreen
            present(tabBarViewController, animated: true, completion: nil)
        }
    }

    func presentAlert(forEmpty sender: String) {
        let alertController = UIAlertController(title: "\(sender) can't be empty", message: "Fill it", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
