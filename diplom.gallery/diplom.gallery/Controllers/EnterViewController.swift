//
//  EnterViewController.swift
//  diplom.gallery
//
//  Created by Rodion Trach on 16.03.2023.
//

import UIKit

class EnterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signInButton_imao: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton_etm: UIButton!
    
    private let mainViewController = "MainViewController"
    private let storageManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func signInButtonPressed_imao(_ sender: UIButton) {
        self.signInUser()
    }
    
    @IBAction func signUpButtonPressed_etm(_ sender: UIButton) {
        self.signUpUser()
    }
    
    
    private func goToMainViewController(_ loadedUser: String?) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: mainViewController) as? MainViewController else { return }
        controller.username = loadedUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func addTapRecognizer(){
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func signInUser() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if storageManager.signIn(
            username: username,
            password: password) {
            goToMainViewController(username)
        }
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
    private func signUpUser(){
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        storageManager.signUp(
            username: username,
            password: password)
        usernameTextField.text = nil
        passwordTextField.text = nil
    }
    
}

extension EnterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
}
