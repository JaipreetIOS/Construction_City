//
//  ChatViewController.swift
//  ConstructionCity
//
//  Created by Apple on 28/10/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var DataMessages : NSMutableArray! = []
    var match_id : String = ""

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var c_table_h: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var txtMeg: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSend.layer.cornerRadius = 4
        scrollView.isScrollEnabled = true
        tableView.estimatedRowHeight = 100
//                tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillClose(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        self.title = "Chat"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        tableView.register(UINib.init(nibName: "LeftTableViewCell", bundle: nil), forCellReuseIdentifier: "left")
          tableView.register(UINib.init(nibName: "RightTableViewCell", bundle: nil), forCellReuseIdentifier: "right")
        getmsg()
        // Do any additional setup after loading the view.
    }
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
             self.c_table_h.constant = self.view.frame.size.height - 134 - keyboardHeight
        }
    }
    func keyboardWillClose(_ notification: Notification) {
            self.c_table_h.constant = self.view.frame.size.height - 134
        
    }
    func getmsg()  {
   
        self.scrollView.scrollsToTop = false
//        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
//        self.scrollView.setContentOffset(bottomOffset, animated: true)
                        self.c_table_h.constant = self.view.frame.size.height - 134

        
        let  messageRef = databaseRef.child("message").child(UserDefaults.standard.value(forKey: "UID") as! String)
        let messageQuery = messageRef.queryLimited(toLast: 1000)
        
        _ = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! NSDictionary
            print(messageData)
            self.DataMessages.add(messageData)
            self.tableView.reloadData()
            

            
            self.tableView.scrollToRow(at: IndexPath.init(row: self.DataMessages.count - 1, section: 0), at: .bottom, animated: true)
            
        })
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SendMessage(_ sender: Any) {
        if txtMeg.text?.characters.count == 0 {
            
        }
        else{
            let itemRef = databaseRef.child("message").child(UserDefaults.standard.value(forKey: "UID") as! String).childByAutoId()
            
            let messageItem = [
                "customerMsg": true,
                "message": txtMeg.text!,
                "timestamp": Int(Date().timeIntervalSince1970) * 1000,
                ] as [String : Any]
            itemRef.setValue(messageItem, withCompletionBlock: { (error, response) in
                
                if (error != nil) {
                    
                }
                else{
                    self.UpdateLastMess(mess: self.txtMeg.text!)
                    self.txtMeg.text = ""
                    
                }
            })
            
        }
        
    }
    
    func UpdateLastMess(mess : String)  {
        let itemRef = databaseRef.child("chat_profile").child(UserDefaults.standard.value(forKey: "UID") as! String)
        
        let messageItem = [
            "lastMessage": mess,
            "resentTimeStamp": Int(Date().timeIntervalSince1970) * 1000,

            ] as [String : Any]
        itemRef.updateChildValues(messageItem, withCompletionBlock: { (error, response) in
            
            if (error != nil) {
                
            }
            else{
             
                
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = DataMessages[indexPath.row] as! NSDictionary
        print(data)
        if data.value(forKey: "customerMsg") as! Bool != true{
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "left", for: indexPath) as! LeftTableViewCell
            cell.selectionStyle = .none
            cell.myMsg.text = data.value(forKey: "message") as? String
//            cell.myMsg.layer.cornerRadius = 6
//            cell.myMsg.layer.masksToBounds = false
//            cell.myMsg.layer.shadowColor = UIColor.black.cgColor
//            cell.myMsg.layer.shadowOffset = CGSize(width: -1, height: 3)
//            cell.myMsg.layer.shadowRadius = 3
//            cell.myMsg.layer.shadowOpacity = 0.2
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "right", for: indexPath) as! RightTableViewCell
            cell.selectionStyle = .none
            cell.myMsg.text = data.value(forKey: "message") as? String
//            cell.myMsg.layer.cornerRadius = 6
//            cell.myMsg.layer.masksToBounds = false
//            cell.myMsg.layer.shadowColor = UIColor.black.cgColor
//            cell.myMsg.layer.shadowOffset = CGSize(width: -1, height: 3)
//            cell.myMsg.layer.shadowRadius = 3
//            cell.myMsg.layer.shadowOpacity = 0.2
            
            return cell
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
