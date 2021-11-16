//
//  OnlineViewController.swift
//  BeltExam
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import Firebase

class OnlineViewController: UIViewController {
    let usersRef = Database.database().reference(withPath: "online")
    var usersRefObservers: [DatabaseHandle] = []
    var currentUsers = [String]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        // 1
        let childAdded = usersRef
          .observe(.childAdded) { [weak self] snap in
            // 2
            guard
              let email = snap.value as? String,
              let self = self
            else { return }
            self.currentUsers.append(email)
              print (self.currentUsers)
            // 3
            let row = self.currentUsers.count-1
            // 4
            let indexPath = IndexPath(row: row, section: 0)
              print (indexPath)
            // 5
            self.tableView.insertRows(at: [indexPath], with: .top)
          }
        usersRefObservers.append(childAdded)
        let childRemoved = usersRef
          .observe(.childRemoved) {[weak self] snap in
            guard
              let emailToFind = snap.value as? String,
              let self = self
            else { return }

            for (index, email) in self.currentUsers.enumerated()
            where email == emailToFind {
              let indexPath = IndexPath(row: index, section: 0)
              self.currentUsers.remove(at: index)
              self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
          }
        usersRefObservers.append(childRemoved)


    }
    
    override func viewDidDisappear(_ animated: Bool) {
        usersRefObservers.forEach(usersRef.removeObserver(withHandle:))
        usersRefObservers = []

    }
    

    @IBAction func signOut(_ sender: UIBarButtonItem) {
        
        do{
            try Auth.auth().signOut()
            
           let vc = storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            
        }catch{
            print("Could not sign out")
        }
    }
    
}
extension OnlineViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyOnline",for: indexPath)
        cell.textLabel?.text = currentUsers[indexPath.row]
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 
    }
    
    
}
