//
//  signUPViewController.swift
//  BeltExam
//
//  Created by administrator on 12/11/2021.
//

import UIKit
import Firebase

class signUPViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUp(_ sender: UIButton) {
        //creat user in firebase
        
       FirebaseAuth.Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { authResult , error  in
            guard let result = authResult, error == nil else {
                print("Error creating user")
                return
            }
        
    })
        // after the  user create account shoud be go to the sign in page
        let vs = self.storyboard?.instantiateViewController(withIdentifier: "Login")as!LoginViewController
        self.navigationController?.pushViewController(vs, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
   


}
