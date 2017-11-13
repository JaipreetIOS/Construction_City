//
//  FirstVC.swift
//  ConstructionCity
//
//  Created by Apple on 17/01/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit

class FirstVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collVIewFirst: UICollectionView!
    @IBOutlet weak var collVIew3: UICollectionView!
    
    @IBOutlet weak var collView2: UICollectionView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var scrllView: UIScrollView!
    @IBOutlet weak var viewOuter: UIView!

    var arrCollViewData  = NSArray()
    var arrCollView2Data = NSArray()
    var arrCollView3Data = NSArray()
    
    var arrDetailGolbal = NSMutableArray()
    var arrProviderData = NSArray()
    
    var arrTypes = NSArray()
    
    var arrData1 = NSMutableArray()
    var arrData2 = NSMutableArray()
    
    var intCount1 = 0
    var intCount2 = 0
    var menuId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        collView2.dataSource = self
        collView2.delegate = self
        
        // hide status bar
        self.navigationController?.navigationBar.isHidden = true
        
    
        // Fetch data from Item_type.json file
        FetchDataFromItem_type_json_File()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Fetch Provider Data
        if let path = Bundle.main.path(forResource: "items_repository-2", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do{
                    let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                    // Store Provider data
                    arrProviderData = jsonResult
                }catch let error {
                    print(error.localizedDescription)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    func FetchDataFromItem_type_json_File() {
    
        // Fetch data from Item_type.json file
        if let path = Bundle.main.path(forResource: "item_type", ofType: "json") {
            do {
    
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
    
                do{
                    let jsonResult: NSArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
    
                    // store data in Array type
                    arrTypes = jsonResult
                   
                    // Reload collection view
                    arrCollViewData = jsonResult
                    
                    collVIewFirst.reloadData()
    
                }catch let error {
    
                    print(error.localizedDescription)
    
                }
    
                } catch let error {
    
                    print(error.localizedDescription)
                }
    
        } else {
    
            print("Invalid filename/path.")
        }

    }
    
    // Button clicked eventt
    @IBAction func btnCrossClicked(_ sender: Any) {
        
        // Make Null Arrays and reaload collection view
        arrCollView3Data = []
        collVIew3.reloadData()
        
        arrCollViewData = arrTypes
        collVIewFirst.reloadData()
        
        arrCollView2Data = []
        arrDetailGolbal = []
        collView2.reloadData()
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collView2){
            return arrCollView2Data.count
        }
        else if(collectionView == collVIew3){
            return arrCollView3Data.count
        }
        else{
            return arrCollViewData.count
        }
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == collView2){
        
            let cell = collView2.dequeueReusableCell(withReuseIdentifier: "FirstCCC2", for: indexPath) as! FirstCCC2
            let strURL = ((arrCollView2Data[indexPath.row] as! NSDictionary).value(forKey: "secure_url") as! String?)!
            cell.lblTitle1.text = ((arrDetailGolbal[0] as! NSDictionary).value(forKey: "item_title") as! String?)!
            cell.lblTitle2.text = ((arrDetailGolbal[0] as! NSDictionary).value(forKey: "item_tags") as! String?)!
            
            // Set Images
            let url = URL(string: strURL)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.imgViewMain.image = UIImage(data: data!)
            return cell
        }
        
        else if(collectionView == collVIew3){
            
            let cell = collVIew3.dequeueReusableCell(withReuseIdentifier: "FirstCCC", for: indexPath) as! FirstCCC
            
            cell.lblName.text = (arrCollView3Data[indexPath.row] as! NSDictionary).value(forKey: "type") as! String?
            cell.lblName.layer.borderWidth = 1
            cell.lblName.layer.borderColor = UIColor.white.cgColor
            cell.lblName.layer.cornerRadius = 15
            cell.lblName.clipsToBounds = true
            
            return cell
        }
        else{
            
            let cell = collVIewFirst.dequeueReusableCell(withReuseIdentifier: "FirstCCC", for: indexPath) as! FirstCCC
            
            cell.lblName.text = (arrCollViewData[indexPath.row] as! NSDictionary).value(forKey: "type") as! String?
            cell.lblName.layer.borderWidth = 1
            cell.lblName.layer.borderColor = UIColor.white.cgColor
            cell.lblName.layer.cornerRadius = 15
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // handle tap events
        if(collectionView == collView2){
            let objSecondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
            //objSecondVC.arrCollviewData = arrCollView2Data
            //objSecondVC.arrdata = arrDetailGolbal
            self.navigationController?.pushViewController(objSecondVC, animated: true)
        }
        else if(collectionView == collVIew3){
            
        }
        else{
            arrData2 = []
            arrData1 = []
            intCount1 = 0
            intCount2 = 0
            arrCollViewData = []
            arrCollView3Data = []
            
            // for collection view hirarchi collection3
            let strParantId = ((arrTypes[indexPath.row] as! NSDictionary).value(forKey: "parent") as! String?)!
            
            arrData1[intCount1] = (arrTypes[indexPath.row] as! NSDictionary)
            
            intCount1 += 1
            
            if (strParantId == "-1"){
               
                arrData1[0] = (arrTypes[indexPath.row] as! NSDictionary)
                arrCollView3Data = NSArray(array: arrData1)
                collVIew3.reloadData()
                
            }else{
                
                self.Recorsive(parantId: strParantId)
                arrCollView3Data = NSArray(array: arrData1)
                collVIew3.reloadData()
                
            }
            
            // for collection view types
            let strKey = ((arrTypes[indexPath.row] as! NSDictionary).value(forKey: "key") as! String?)!
            
            if(strKey == "70"){
                
                arrData2[0] = (arrTypes[indexPath.row] as! NSDictionary)
                arrCollViewData = NSArray(array: arrData2)
                collVIewFirst.reloadData()
                
            }else{
                
                self.Recorsive2(key: strKey)
                arrCollViewData = NSArray(array: arrData2)
                collVIewFirst.reloadData()
                
            }
            
            //collection view provider  data
            let strKey2 = ((arrTypes[indexPath.row] as! NSDictionary).value(forKey: "key") as! String?)!
            //print(strKey2)
            for i in 0 ..< arrProviderData.count {
                let strKeyTest = ((arrProviderData[i] as! NSDictionary).value(forKey: "key") as! String?)!
                if (strKey2 == strKeyTest){
                    arrDetailGolbal[0] = (arrProviderData[i] as! NSDictionary)
                    break
                }
            }
            arrCollView2Data = (arrDetailGolbal[0] as! NSDictionary).value(forKey: "item_img_file")  as! NSArray
            collView2.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == collView2){
            return CGSize(width: self.collView2.frame.size.height / 3, height: self.collView2.frame.size.height / 3)
        }
        else if(collectionView == collVIew3){
            return CGSize(width:120, height: 30)
        }
        else{
            return CGSize(width:120, height: 30)
        }
    }

    
    // Custon Function
    
    // Recorsive Function For getting Parent
    func Recorsive(parantId:String){
        var nextId = ""
        for i in 0 ..< arrTypes.count {
            let key = ((arrTypes[i] as! NSDictionary).value(forKey: "key") as! String?)!
            if(key == parantId ){
                arrData1[intCount1] = (arrTypes[i] as! NSDictionary)
                intCount1 += 1
                nextId = ((arrTypes[i] as! NSDictionary).value(forKey: "parent") as! String?)!
            }
        }
        if(nextId == "-1"){
            
        }else{
            
            self.Recorsive(parantId: nextId)
        }
    }
    
    // Recorsive function for getting Childs
    func Recorsive2(key:String){
        var nextId = ""
        for i in 0 ..< arrTypes.count {
            let parantId = ((arrTypes[i] as! NSDictionary).value(forKey: "parent") as! String?)!
            if(key == parantId ){
               
                arrData2[intCount2] = (arrTypes[i] as! NSDictionary)
                
                intCount2 += 1
                
                nextId = ((arrTypes[i] as! NSDictionary).value(forKey: "key") as! String?)!
                
                if(nextId == "70"){
                    
                }else{
                    
                    self.Recorsive2(key: nextId)
                }
            }
        }
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
}

