//
//  SubCatViewController.swift
//  ConstructionCity
//
//  Created by Apple on 28/10/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit

class SubCatViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ViewSetting: UIView!
    var DataCat : NSMutableArray = []
    var Selected_Index : Int = -1
    var parCat : String = ""

    @IBOutlet weak var c_viewSetting_h: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        ViewSetting.isHidden = true
        c_viewSetting_h.constant = 0
        
        self.title = parCat
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

        getParentId(strMenuName: (dict.value(forKey: "type") as? String)!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
