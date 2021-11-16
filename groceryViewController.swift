//
//  groceryViewController.swift
//  BeltExam
//
//  Created by administrator on 10/11/2021.
//

import UIKit
import Firebase


class groceryViewController: UIViewController {
    let userRef = Database.database().reference(withPath: "online")
    var userRefObservers : [DatabaseHandle] = []
    let userEmail = Auth.auth().currentUser?.email
    let userUid =   Auth.auth().currentUser?.uid
    
    
    
    var itemsArray = [groceryItems]()
   
    @IBAction func onlineUser(_ sender: Any) {
        let vs = self.storyboard?.instantiateViewController(withIdentifier: "online")as!OnlineViewController
        self.navigationController?.pushViewController(vs, animated: true)
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var onlineUserCount: UIBarButtonItem!
    override func viewDidLoad()  {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        fetchItem()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        let currentUserRef = self.userRef.child(userUid!)
        currentUserRef.setValue(userEmail)
        currentUserRef.onDisconnectRemoveValue()
        let users = userRef.observe(.value){snapShot in
            if snapShot.exists(){
                self.onlineUserCount.title = snapShot.childrenCount.description
            }
            else {
                self.onlineUserCount.title = "0"
            }
        }
        userRefObservers.append(users)
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userRefObservers.forEach(userRef.removeObserver(withHandle:))
        userRefObservers = []

    }
     
   
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        //when user clicked to add button it will be show alert to add grocery item
        
    let alertController = UIAlertController(title: "Grocery Item", message: "add an Item", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Add grocery"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            print("saving to database")
            let groceryTextField = alertController.textFields![0] as UITextField
            print(groceryTextField.text!)
            // add to data base
            guard let textToSend = groceryTextField.text else{
                print("you can't send an empty text")
                return
            }
            // to get the email of user
            guard let userEmail = Auth.auth().currentUser?.email else {
                return
            }
            //calling the mothed creat in class DatabaseManager to creat item in firebase
        DatabaseManager.shared.creatGroceryItems(createdBy: userEmail , isDone:false, item:textToSend){success in
                if success{
                    print("item added to realtime database")
                  
                }else{
                    print("Error did not add to database")
                }
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("Cancelled")
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
        
        
    }
   

   
// to fetch data from firebase and saved in itemsArray
    func fetchItem (){
       
        DatabaseManager.shared.observeItem{ result in
            switch result{
            case.success(let items):
                DispatchQueue.main.async {
                    self.itemsArray = items
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension groceryViewController : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        
    cell.textLabel?.text = itemsArray[indexPath.row].name
    let det = itemsArray[indexPath.row].addedbyuser
    cell.detailTextLabel?.text = det
        print (det)
       
        
        return cell
        
        
    }
    // this mothed when the user swipe will be see the delete and update
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delet") { (action, view, CompletionHandler) in
            let deleteItem = self.itemsArray[indexPath.row].name
            // delete item from firebase
            DatabaseManager.shared.database.child("groceryItems").child(deleteItem).setValue(nil)
           
            // delete item from tabelView
            self.itemsArray.remove(at: indexPath.row)
           
            tableView.beginUpdates()
           tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.endUpdates()
            
            CompletionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit"){
            (_,_,_) in
            print ("edit ")
            
            let alertController = UIAlertController(title: "Edit Item", message: "Do you want edit item ", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "edit item "
                }
                
            let saveAction = UIAlertAction(title: "Save", style: .default) { [self]action in
                    print("saving to database")
                    let editgroceryTextField = alertController.textFields![0] as UITextField
                    print(editgroceryTextField.text!)
                    // add to data base
                    guard let textToSend = editgroceryTextField.text else{
                        print("you can't send an empty text")
                        
                        return
                    }
                    let userEmail = Auth.auth().currentUser?.email
                    let oldItem = itemsArray[indexPath.row].name
                DatabaseManager.shared.updateItem(oldItem : oldItem ,createdBy: userEmail!, isDone: false, item: textToSend )
                    
                }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                        print("Cancelled")
                    }
                    
                    alertController.addAction(saveAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
            
            
            
                
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        editAction.image = UIImage(systemName: "edit")
        return UISwipeActionsConfiguration(actions :[deleteAction,editAction])
    }
    
    // to chage the height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 
    }
    
    
    
    
}


