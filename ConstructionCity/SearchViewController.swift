//
//  SearchViewController.swift
//  Construction
//
//  Created by Apple on 24/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
class SearchViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , NVActivityIndicatorViewable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ViewSetting: UIView!
    var DataCat : NSMutableArray = []
    var AllDataCat : NSMutableArray = []
    
    
    var Selected_Index : Int = -1

    @IBOutlet weak var c_viewSetting_h: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        ViewSetting.isHidden = true
        c_viewSetting_h.constant = 0
        getAdvertImagesBaseDatabase()
        self.title = "Category"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    func getAdvertImagesBaseDatabase() {
        
//        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)
        
        databaseRef.child("itemType").observe( .value, with: { (snapshot) in
                        print(snapshot)
            
            let messageData = snapshot.value as! NSArray
            
            for i in 0..<messageData.count {
                let dict = messageData[i] as! NSDictionary
                if dict.value(forKey: "parent") as! String == "0"{
                    self.DataCat.add(dict)
                }
                
            }
            self.tableView.reloadData()
            self.AllDataCat = NSMutableArray.init(array: messageData)
           
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.DataCat.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        cell.selectionStyle = .none
        let dict = DataCat[indexPath.row] as! NSDictionary
        
        cell.nameTxt.text = dict.value(forKey: "type") as? String
        
        if Selected_Index == indexPath.row{
            cell.nameTxt.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.bgView.backgroundColor = #colorLiteral(red: 0.7754637599, green: 0.155043453, blue: 0.1583386958, alpha: 1)
        }
        else{
            cell.nameTxt.textColor = #colorLiteral(red: 0.7677864432, green: 0.1547290385, blue: 0.1588584781, alpha: 1)
            cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = DataCat[indexPath.row] as! NSDictionary

        
        Selected_Index = indexPath.row
        tableView.reloadData()
        if dict.value(forKey: "_type_id") as! String == "0"{
            getParentId(strMenuName: (dict.value(forKey: "type") as? String)!)

        }
        else{
            let type_id = dict.value(forKey: "_type_id") as! String
            let TempData : NSMutableArray = []
            for i in 0..<AllDataCat.count{
                let data = AllDataCat[i] as! NSDictionary
                if type_id == data.value(forKey: "parent") as? String{
                    TempData.add(data)
                }
            }
            
            if TempData.count == 0{
                getParentId(strMenuName: (dict.value(forKey: "type") as? String)!)

            }
            else{
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "SubCatViewController") as! SubCatViewController
                mainvc.DataCat = TempData
                
                let dict = DataCat[indexPath.row] as! NSDictionary
                
                
                mainvc.parCat = (dict.value(forKey: "type") as? String)!
                navigationController?.pushViewController(mainvc, animated: true)
            }
        }
        
        
    }
    func getParentId(strMenuName: String) {
        
        for i in 0..<arrOfAllMenus.count {
            
            // To Get ParentId
            if strMenuName.lowercased() == ((arrOfAllMenus[i] as! NSDictionary).value(forKey: "type") as! String).lowercased() {
                
                //print(arrOfMenu[i])
                
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainvc.dictMenu = (arrOfAllMenus[i] as! NSDictionary)
                navigationController?.pushViewController(mainvc, animated: true)
                
                break
                
            }
        }
        
        // To close Menu
   
        
    }
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func Setting(_ sender: Any) {
    }
    @IBAction func MenuSetting(_ sender: Any) {
        if ViewSetting.isHidden == true
        {
            c_viewSetting_h.constant = 120
            ViewSetting.isHidden = false

        }
        else{
            c_viewSetting_h.constant = 0
            ViewSetting.isHidden = true

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
