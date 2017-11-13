//
//  FacebookLoginVC.swift
//  ConstructionCity
//
//  Created by Apple on 25/10/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase
class FacebookLoginVC: UIViewController , FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    var dictOfDetail         = NSDictionary()

    var ComingFrom : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
//        loginButton.setBackgroundImage(#imageLiteral(resourceName: "ic_action_star_border.png"), for: .normal)
        loginButton.setTitle("", for: .normal)
        loginButton.frame = CGRect.init(x: view.frame.size.width/2 - 120, y: view.frame.size.height/2 - 35, width: 240, height: 70)
        view.addSubview(loginButton)
        
        
                do {
                    try Auth.auth().signOut()
                    
                    UserDefaults.standard.set(false, forKey: "isLogged")
                    
                    
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
        
        
        self.title = " "
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print(result)
        if result.isCancelled {
            return

        }
        
        if  FBSDKAccessToken.current() != nil{
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print(error)

                return
            }
            
            // User is signed in
            // ...
            let uid = user?.uid
            print(uid!)
            UserDefaults.standard.set(uid, forKey: "UID")
            UserDefaults.standard.set(user?.displayName, forKey: "userName")

            UserDefaults.standard.set(true, forKey: "isLogged")
            UserDefaults.standard.synchronize()
            if self.ComingFrom == "Detail"{
                self.navigationController?.popViewController(animated: true)
            }
            else{
            let secondvc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
//                secondvc.dictOfDetail = dictOfDetail

            self.navigationController?.pushViewController(secondvc, animated: true)
            }
            }
        }
    }
        // ...
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
