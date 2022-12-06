//
//  LoginViewController.swift
//  Epark
//
//  Created by iheb mbarki on 9/11/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements () {
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    
    
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
         
           }
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate the fields
        
        let error = validateFields()
        
        if error != nil {
            //error with the fields
            showError(error!)
        }
        else {
            
            //Create cleaned version of data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Sign in the user
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    
                    let containerTabBarController =  self.storyboard?.instantiateViewController(withIdentifier:Constants.Storyboard.ContainerTabBarController) as? ContainerTabBarController
                    
                    self.view.window?.rootViewController = containerTabBarController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }

 }
