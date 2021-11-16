//
//  ViewController.swift
//  BeltExam
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var familyLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        //when the user clicked to sign up button  it shoud be go to to sign up page
        let vs = self.storyboard?.instantiateViewController(withIdentifier: "signUp")as!signUPViewController
        self.navigationController?.pushViewController(vs, animated: true)
        
       
}
    
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        guard
          let email = emailTextField.text,
          let password = passwordTextField.text,
          !email.isEmpty,
          !password.isEmpty
        else { return }
        // for sign in firebase
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
          // error checked and show alert
          if let error = error, user == nil {
            let alert = UIAlertController(
              title: "Sign In Failed",
              message: error.localizedDescription,
              preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
          }
            //when the user enters correct sign in data it shoud be go to grocery page
            let vs = self.storyboard?.instantiateViewController(withIdentifier: "grocery")as!groceryViewController
            self.navigationController?.pushViewController(vs, animated: true)
            
        }
        
       
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   

}

