//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "a@b.com", body: "Hello!"),
        Message(sender: "1@2.com", body: "What's up?")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.delegate = self //this is for the bottom delegate protocol
        tableView.dataSource = self
        title = K.appName //display the name at the navigation bar using title.
        navigationItem.hidesBackButton = true //hides the back button on the navigation bar menu
        
        //register the custom desgin message bubble cell . xib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()

    }
    
    func loadMessages(){
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField) //order the messages shown based on the date they were created.
            .addSnapshotListener { (QuerySnapshot, error) in //since the completion function is in a closure, then all these things run in the background.
            // .addSnapshot Listener will allows firebase to rerun these codes whenever there is an update to the collection. Sort of like a event listener, waiting for things to trigger it.
            
            self.messages = [] //whenver there is a new message added to the collection, we want to begin with an empty array so that the previous messages gets deleted and are re-retrieve from the database to load up again.
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = QuerySnapshot?.documents { //if the documents exist, then assign it to snapshotDocuments
                    for doc in snapshotDocuments { //looping through all the documents in the array result
                        let data = doc.data() //this data() will give back a key: value pair
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String { //retrieving the data by passing in the key so that we can get the value
                            //downcast to a string type
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            //Then add the Message model into the array
                            self.messages.append(newMessage)
                            //Then the app will display all the results that are stored inside this messages array.
                            
                            DispatchQueue.main.async { //have to fetch the main thread (which is running in the foreground) and update the data
                                self.tableView.reloadData() // tap into the tableview and re-trigger the data source again. Becuz if the internet speed is slow, then the data may not be able to be stored in the array in time for display. Hence we want to call the tableView again to re-run its datasource method.
                                
                                //The code below will allow the screen to always load and show the last message instead of the first message at the top.
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) //scroll to the top so that we can see the very bottom of the tableView
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //if messagebody and messagesender is not nil, then we can refer to them to get the value
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,
                                                                      K.FStore.bodyField: messageBody,
                                                                      K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async { //since we're inside a closure and we're trying to update the user interface then we need to call this method so that this actually happens on the main thread, rather than on a background thread.
                        //Codes in clousure tend to take place in the background.
                        self.messageTextfield.text = "" //to clear the textfield whenever the user press the send button.
                    }
                }
            }
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            
            //if sign out process is successful
            //pop to route view controller method
            navigationController?.popToRootViewController(animated: true) //this method get rid of all the view controllers on the stack except the very root view controller.
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}

extension ChatViewController: UITableViewDataSource {//when the tableview loads up its gonna make a request for data under this protocol
    //UITableViewDataSource protocol is responsible for populating the table view, so telling it how many cells it needs and which cells that put into the tableview.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //how many rows you want ?
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //indexPath is the position
        //this method is asking for a UITableViewCell that it should display in each and every row of our table view.
        //This method is gonna get called for as many rows as you have in your tableview and each time its asking for a cell for a particular row.
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        //give the cell some data
        cell.label.text = message.body //indexPath.row will get you the row index number.
        //the .body is needed becuz messages containts an array of Message model. then using .body will aceess the value in each Message model.
        
        //This is a message from the current user.
        if message.sender == Auth.auth().currentUser?.email { //check if the message sender is the same as the current log in user
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //This is a message from another sender.
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
       
        return cell //this will slot the cell inside the tableview with the information you provide.
    }
    
}

//For performing actions after selecting a cell
//extension ChatViewController: UITableViewDelegate { //hears for interaction from the user
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row) //when you tap on this cell, then its gonna print the index of the cell that you press.
//    }
//}
