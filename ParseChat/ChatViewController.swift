//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Martin Landin on 2/28/19.
//  Copyright © 2019 Martin Landin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatTableView: UITableView!
    
    var messages:[PFObject] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        queryMessages()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(queryMessages), userInfo: nil, repeats: true)

    }
    
    @IBAction func onSendButton(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageTextField.text ?? ""
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageTextField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        let message = messages[indexPath.row]
        
        cell.messageLabel.text = message["text"] as? String
        
        return cell
    }
    
    @objc func queryMessages() {
        // construct query
        let query = PFQuery(className: "Messages")
        query.addDescendingOrder("createdAt")
        
        // fetch data asynchronously
        query.findObjectsInBackground { (response, error) in
            if let posts = response {
                // do something with the array of object returned by the call
                self.messages = posts
                self.chatTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
