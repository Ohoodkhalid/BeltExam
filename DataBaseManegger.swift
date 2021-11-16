//
//  DataBaseManegger.swift
//  BeltExam
//
//  Created by administrator on 10/11/2021.
//

import Foundation
import Firebase

struct groceryItems{
    let addedbyuser: String
    let completed: Bool
    let name : String
}

class DatabaseManager {
    //creat object from calss DatabaseManager to able access to  method from other calss
static let shared = DatabaseManager()
    //creat object from calss DatabaseManager to able access to firebase
let database = Database.database().reference()
    
   //This method to creat crocery item in firebase
    func creatGroceryItems(createdBy : String ,isDone : Bool,item : String, completion: @escaping (Bool) -> Void ){
        let item = groceryItems(addedbyuser: createdBy , completed: isDone, name: item)
        
        // Array of dictionaries
        let addItems = [
            "addedbyuser" : item.addedbyuser,
            "completed"  : item.completed,
            "name"       : item.name,
        ] as [String : Any]
        
    // the structure in firebase like this
       // groceryItems
       //    name of item
       //        created by
        //       compleate
        //       name of item
        
        database.child("groceryItems").child(item.name).setValue(addItems)
        database.child("groceryItems").observeSingleEvent(of: .value) {[weak self] snapShot in
            
            
    }
          
        
}
    
    
    //this mothod to fetch data from firebase
    
    func observeItem(completion: @escaping (Result<[groceryItems],Error>) -> Void){
            database.child("groceryItems").observe(.value) { snapShot in
                print(snapShot.childrenCount)
                var returnItem = [groceryItems]()
                for value in snapShot.children.allObjects as! [DataSnapshot] {
                    let itemDictionary = value.value as? [String:AnyObject]
                    let completed = itemDictionary?["completed"] as? Bool  ?? false
                    let addedbyuser = itemDictionary?["addedbyuser"] as? String  ?? ""
                    let nameOfItem = itemDictionary?["name"] as? String ?? ""
                    let item = groceryItems(addedbyuser: addedbyuser , completed: completed , name: nameOfItem)
                    returnItem.append(item)
                }
                completion(.success(returnItem))
            }
        }
    
    
    func updateItem (oldItem : String,createdBy : String ,isDone : Bool,item : String){
        // Array of dictionaries
        let updateItems = [
            "addedbyuser" :createdBy,
            "completed"  :isDone,
            "name"       :item
        ] as [String : Any]
        
        database.child("groceryItems/\(oldItem)").setValue(updateItems)
        
    
      
    
}

    
   
    

}
