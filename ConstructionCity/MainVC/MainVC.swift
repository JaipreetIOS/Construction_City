//
//  MainVC.swift
//  ConstructionCity
//
//  Created by Apple on 19/07/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView


class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate , NVActivityIndicatorViewable {
   
    
    // MARK: -  Outlets And Variable Declaration 
    @IBOutlet weak var collectionviewParentMenu: UICollectionView!
    @IBOutlet weak var collectionViewChildMenu: UICollectionView!
    @IBOutlet var tblTilesAndDetails: UITableView!
    @IBOutlet var lblEmptyMessage: ZWLabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tblSearchList: UITableView!
    
    @IBOutlet weak var collView2: UICollectionView!
    
    var arrOfParentMenu = NSMutableArray()
    var arrOfChildMenu = NSMutableArray()

    var arrOfItemsDescription = NSMutableArray()
    var arrOfTilesAndDiscription = NSMutableArray()
    
    // To get all tiles images
//    var arrOfAllTilesImages = NSMutableArray()
    
    // To Display Particular Tiles Images In TableView From arrOfAllTilesImages
    var arrOfParticularTileimages = NSMutableArray()
    
    // get From MenuViewController in GetParentId() Method
    var dictMenu = NSDictionary()
    
    var issearch = false
    
    
    // MARK:  Arrays For Seaching 
    var arrOfItemTypesHeirarchy = NSMutableArray()
    var arrOfItemHierarchy = NSMutableArray()
    var arrOfAllSearchHierarchy = NSMutableArray()
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alldelegate()
        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)

        // Not Display Other Image Like Cache
        _ = SDImageCacheType.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: .UIKeyboardDidShow , object: nil)
        self.title = "Search"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // Get All Data From JsonFile
        
//        if !issearch {
//
//            // To create Parent Menu
//            createParentMenu()
//
//            // To get TilesImages and Discription
//            getTilesImagesAndDisciption()
//
//            issearch = false
//
//        } else {
//
//            btnClearMenuClicked(UIButton.self)
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromjsonFile()

    }
    func alldelegate() {
        
        collectionViewChildMenu.delegate = self
        collectionViewChildMenu.dataSource = self
        
        collectionviewParentMenu.delegate = self
        collectionviewParentMenu.dataSource = self
        
        tblTilesAndDetails.delegate = self
        tblTilesAndDetails.dataSource = self
        
        tblSearchList.delegate = self
        tblSearchList.dataSource = self
        
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
    }
    func createParentMenu(){
    
        arrOfParentMenu = NSMutableArray()
        var menuId = ""
        var childId = ""
        arrOfParentMenu.add(dictMenu)
        
        menuId = dictMenu.value(forKey: "parent") as! String
        getParentMenuList(selectedMenuId: menuId)
        
        childId = dictMenu.value(forKey: "_type_id") as! String
        print(childId)
        getChildMenuList(selectedKey: childId)
        
        
    }
    
    func fetchDataFromjsonFile() {
        
        print("GettingDataFromfirebase")
        _ = databaseRef.child("newItems").observe(.value, with: { (snapshot) -> Void in
            
           
            
            let arr = (snapshot.value as! NSDictionary).allValues
            print(arr)
           self.arrOfItemsDescription = NSMutableArray.init(array: arr)
          
            if !self.issearch {
                
                // To create Parent Menu
                self.createParentMenu()
                
                // To get TilesImages and Discription
                self.getTilesImagesAndDisciption()
                
                self.issearch = false
                
            } else {
                
                self.btnClearMenuClicked(UIButton.self)
            }
            self.stopAnimating()
            
        })
        
    

//    
        
    }
    func getParentMenuList(selectedMenuId: String) {
        
        if selectedMenuId != "-1" {
            var nextParentId = ""
            
            for i in 0..<arrOfAllMenus.count {

                let type_id: String = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String
                //print(type_id)
                if type_id == selectedMenuId {
                
                    arrOfParentMenu.add(arrOfAllMenus[i] as! NSDictionary)
                    nextParentId = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String
                   
                }
            }
            if nextParentId == "-1" {
            
                // arrOfParentMenu In Reverse Order
                var i = 0
                for item in arrOfParentMenu.reversed() {
                   
                    arrOfParentMenu[i] = item
                    i += 1
                }
                
            } else {
                
                getParentMenuList(selectedMenuId: nextParentId)
            }
        }
        collectionviewParentMenu.reloadData()
        collectionViewChildMenu.reloadData()
        
    }
    // MARK: -  UICollectionViewDelegateFlowLayout Method 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionviewParentMenu {
            
            // set height and width on the label text
            let testString = (arrOfParentMenu[indexPath.row] as! NSDictionary).value(forKey: "type") as! String
            let calCulateSizze: CGSize = testString.size(attributes: nil)
            
            // Bcoz ThisString Length Was So Long and its not fit in Label
            if testString == "Ceramic Tile (Wooden Pattern)" {
                
                return CGSize(width: calCulateSizze.width + 70, height: 40)
                
            } else {
                
                return CGSize(width: calCulateSizze.width + 40, height: 40)
            }
            
        }
        else   if(collectionView == collView2){
             return CGSize(width: self.collView2.frame.size.height / 3, height: self.collView2.frame.size.height / 3)
     
        }
        
        else {
            
            // set height and width on the label text
            let testString = (arrOfChildMenu[indexPath.row] as! NSDictionary).value(forKey: "type") as! String
            let calCulateSizze: CGSize = testString.size(attributes: nil)
            
            // Bcoz ThisString Length Was So Long and its not fit in Label
            if testString == "Ceramic Tile (Wooden Pattern)" {
                
                return CGSize(width: calCulateSizze.width + 50, height: 40)
                
            } else {
                
                return CGSize(width: calCulateSizze.width + 40, height: 40)
            }
            
        }
        
    }

    // MARK: -  UICollectionViewDataSource Mehtods 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        if collectionView == collectionviewParentMenu {
            
            return arrOfParentMenu.count
            
        }
        else  if(collectionView == collView2){
            
            if arrOfTilesAndDiscription.count == 0 {
                
                collView2.isHidden = true
                lblEmptyMessage.isHidden = false
                
            } else {
                
                collView2.isHidden = true
                tblTilesAndDetails.isHidden = false
            }
            return arrOfTilesAndDiscription.count
            
        }
        else {
            
            return arrOfChildMenu.count
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        
        if collectionView == collectionviewParentMenu {
        
            let cell = collectionviewParentMenu.dequeueReusableCell(withReuseIdentifier: "MenuCollectionVCell", for: indexPath) as! MenuCollectionVCell
            
            cell.lblParentMenu?.text = "\((arrOfParentMenu[indexPath.row] as! NSDictionary).value(forKey: "type")!)  "
            
            return cell
            
        }
        else   if(collectionView == collView2){
            
            let cell = collView2.dequeueReusableCell(withReuseIdentifier: "FirstCCC2", for: indexPath) as! FirstCCC2
            
            let dictOfData = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String

            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                let strimgRef = storageRef.child("mid").child(dictofImage.value(forKey: "item_serial_no") as! String).child((dictofImage.value(forKey: "item_img_list") as! NSArray)[0] as! String)
                
                strimgRef.downloadURL { (downloadUrl, err) in
                    
                    if err != nil {
                        
                        print(err?.localizedDescription ?? "")
                        return
                    } else {
                        
                        
                        //  cell.imgTile.sd_setImage(with: URL.init(string: String(describing: downloadUrl)), placeholderImage: UIImage.init(named: ""))
                        
                        cell.imgViewMain.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                    }
                }
            }
            
            
            
//            cell.viewMain.layer.cornerRadius = 6
            cell.viewMain.layer.masksToBounds = false
            cell.viewMain.layer.shadowColor = UIColor.black.cgColor
            cell.viewMain.layer.shadowOffset = CGSize(width: 1, height: 3)
            cell.viewMain.layer.shadowRadius = 3
            cell.viewMain.layer.shadowOpacity = 0.2

            
//            let strURL = ((arrOfTilesAndDiscription[indexPath.row] as! NSDictionary).value(forKey: "secure_url") as! String?)!
            cell.lblTitle1.text = dictOfData.value(forKey: "item_title") as? String
            cell.lblTitle2.text = dictOfData.value(forKey: "item_serial_no") as? String
            
            // Set Images
//            let url = URL(string: strURL)
//            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//            cell.imgViewMain.image = UIImage(data: data!)
            return cell
        }
        
        else {
            
            let cell = collectionViewChildMenu.dequeueReusableCell(withReuseIdentifier: "MenuCollectionVCell", for: indexPath) as! MenuCollectionVCell
            
            cell.lblChildMenu?.text = "\((arrOfChildMenu[indexPath.row] as! NSDictionary).value(forKey: "type")!)  "
            
            return cell
           
        }
    }
    // MARK: -  UICollectionViewDelegate Mehtods 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionviewParentMenu {
            
            arrOfChildMenu = NSMutableArray()
            
            let type_id = (arrOfParentMenu[indexPath.row] as! NSDictionary).value(forKey: "_type_id")! as! String
            
            getChildMenuList(selectedKey: type_id)
            
            let parentid = (arrOfParentMenu[indexPath.row] as! NSDictionary).value(forKey: "parent") as! String
            
            let fakeArray = arrOfParentMenu[indexPath.row] as! NSDictionary
            arrOfParentMenu = NSMutableArray()
            
            if parentid == "-1" {
                
                arrOfParentMenu[0] = fakeArray
                
            } else {
                
                // Previous Menu Are Deleted For Create New Menu
                arrOfParentMenu[0] = fakeArray
                getParentMenuList(selectedMenuId: parentid)
            }
        }
        else   if(collectionView == collView2){
            let secondvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
            //objSecondVC.arrCollviewData = arrCollView2Data
            //objSecondVC.arrdata = arrDetailGolbal
            
            let dictOfData = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            
            // get Serial No From dictionary
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String
            
            // get dictionary on the Serial no From arrOfAllTilesImages Array
            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                // Pass in the SecondVC
                secondvc.arrOfImages = dictofImage.value(forKey: "item_img_list") as! NSArray
                
            } else {
                
                // Pass in the SecondVC
                secondvc.arrOfImages = NSArray()
            }
            
            secondvc.dictOfDetail = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            
            
            self.navigationController?.pushViewController(secondvc, animated: true)
        }
        
        else {
            
            
            if ((arrOfChildMenu[indexPath.row] as! NSDictionary).value(forKey: "parent") as! String) == "-1" {
                
                arrOfParentMenu = NSMutableArray()
                arrOfParentMenu.add(arrOfChildMenu[indexPath.row] as! NSDictionary)
                
            } else {
            
                // To get parent menu
                dictMenu = arrOfChildMenu[indexPath.row] as! NSDictionary
                createParentMenu()
                
                //getChildMenuList(selectedKey: (arrOfChildMenu[indexPath.row] as! NSDictionary).value(forKey: "_type_id")! as! String)
                //arrOfChildMenu = NSMutableArray()

            }
            let type_Id = (arrOfChildMenu[indexPath.row] as! NSDictionary).value(forKey: "_type_id")! as! String
            arrOfChildMenu = NSMutableArray()
            getChildMenuList(selectedKey: type_Id)
        }
        
        collectionViewChildMenu.reloadData()
        collectionviewParentMenu.reloadData()
        
        getTilesImagesAndDisciption()
        
        searchBar.resignFirstResponder()
        
    }
    func getChildMenuList(selectedKey: String){
        
        let tempArr : NSMutableArray = []
        
        for i in 0..<arrOfAllMenus.count {
            
            let parentid = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String
            
            let extractedExpr: String = selectedKey
            if extractedExpr == parentid {
                
                tempArr.add((arrOfAllMenus[i] as! NSDictionary))
                arrOfChildMenu.add((arrOfAllMenus[i] as! NSDictionary))

//                if (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String !=  (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String {
//
//                    getChildMenuList1(selectedKey: (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String)
//
//                }
                

                
                
            }
        }
        print(arrOfChildMenu)
        print(tempArr)
        
        for i in 0..<tempArr.count {
            
            let _type_id = (tempArr[i] as! NSDictionary).value(forKey: "_type_id") as! String
            
            
            
            
            for i in 0..<arrOfAllMenus.count {
                
                let parentid = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String
                
                let extractedExpr: String = _type_id
                if extractedExpr == parentid {
                    
                    arrOfChildMenu.add((arrOfAllMenus[i] as! NSDictionary))
                    
                    //                if (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String !=  (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String {
                    //
                    //                    getChildMenuList1(selectedKey: (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String)
                    //
                    //                }
                    
                    
                    
                    
                }
            }
            
            
            
            
            
    
        }
        
        print(arrOfChildMenu)
        print(arrOfChildMenu.count)


    }
    
    
    func getChildMenuList1(selectedKey: String){
        
        for i in 0..<arrOfAllMenus.count {
            
            let parentid = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String
            
            let extractedExpr: String = selectedKey
            if extractedExpr == parentid {
                
                
//                if (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String !=  (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as! String {
//
//                    getChildMenuList(selectedKey: (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String)
//
//                }
//                else{
                    arrOfChildMenu.add((arrOfAllMenus[i] as! NSDictionary))

//                }
                
            }
        }
        print(arrOfChildMenu.count)
    }
    
    func getTilesImagesAndDisciption() {

        arrOfTilesAndDiscription = NSMutableArray()
        if arrOfChildMenu.count == 0 {
            
            
            /* child menu have no menu so we select the parent menu last element and display its Tiles and descriptions */
            let parentmenuTypeId = (arrOfParentMenu[arrOfParentMenu.count - 1] as! NSDictionary).value(forKey: "_type_id") as! String
            
            for j in 0..<arrOfItemsDescription.count {
                
                if parentmenuTypeId == (arrOfItemsDescription[j] as! NSDictionary).value(forKey: "_type_id") as! String {
                    
                    arrOfTilesAndDiscription.add(arrOfItemsDescription[j] as! NSDictionary)
                }
            }
    
        } else {

            for i in 0..<arrOfChildMenu.count {
                
                let childmenuTypeId = (arrOfChildMenu[i] as! NSDictionary).value(forKey: "_type_id") as! String
                
                for j in 0..<arrOfItemsDescription.count {
                    
                    if childmenuTypeId == (arrOfItemsDescription[j] as! NSDictionary).value(forKey: "_type_id") as! String {
                        
                        arrOfTilesAndDiscription.add(arrOfItemsDescription[j] as! NSDictionary)
                    }
                }
            }
        }
        tblTilesAndDetails.reloadSections(IndexSet(integersIn: 0...0), with: .top)
        tblTilesAndDetails.reloadData()
        collView2.reloadData()
    }
    // MARK: -  UITableviewDataSource Methods 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblTilesAndDetails {
        
            if arrOfTilesAndDiscription.count == 0 {
                
                tblTilesAndDetails.isHidden = true
                lblEmptyMessage.isHidden = false
                
            } else {
                
                lblEmptyMessage.isHidden = true
                tblTilesAndDetails.isHidden = false
            }
            return arrOfTilesAndDiscription.count
            
        } else {
            
            return arrOfAllSearchHierarchy.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tblTilesAndDetails {
        
            let cell = tblTilesAndDetails.dequeueReusableCell(withIdentifier: "TailsAndDetailsTableVCell", for: indexPath) as! TailsAndDetailsTableVCell
            
            let dictOfData = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String
            
            cell.lblItemSerialNo.text = serialno
            
            
            cell.lblTileType.text = dictOfData.value(forKey: "item_title") as? String
            
            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                let strimgRef = storageRef.child("mid").child(dictofImage.value(forKey: "item_serial_no") as! String).child((dictofImage.value(forKey: "item_img_list") as! NSArray)[0] as! String)
                
                strimgRef.downloadURL { (downloadUrl, err) in
                    
                    if err != nil {
                        
                        print(err?.localizedDescription ?? "")
                        return
                    } else {
                        
                        
                      //  cell.imgTile.sd_setImage(with: URL.init(string: String(describing: downloadUrl)), placeholderImage: UIImage.init(named: ""))

                     cell.imgTile.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                    }
                }
            }
            
            
            
            cell.lblItemWidthHeight.text = dictOfData.value(forKey: "item_width_height") as? String
            
            cell.lblItemColor.text = dictOfData.value(forKey: "item_color") as? String
            
            cell.lblItemFinish.text = dictOfData.value(forKey: "item_finish") as? String
            
            //print(dictOfData)
            return cell
            
        } else {
            
            let cell = tblSearchList.dequeueReusableCell(withIdentifier: "SearchTableVCell", for: indexPath) as! SearchTableVCell
            
            if indexPath.row < arrOfItemTypesHeirarchy.count {
                
                cell.imgSearch.image = UIImage(named: "typeHierarchy.png")
                
            } else {
                
                cell.imgSearch.image = UIImage(named: "tileHierarchy.png")
            }
            cell.lblSearch.text = arrOfAllSearchHierarchy[indexPath.row] as! String
            return cell
        }
    }
    
    // MARK: -  UITableViewDelegate Mehtod
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblTilesAndDetails {
        
            let secondvc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
            
            // get dicdtionary
            let dictOfData = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            
            // get Serial No From dictionary
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String
            
            // get dictionary on the Serial no From arrOfAllTilesImages Array
            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                // Pass in the SecondVC
                secondvc.arrOfImages = dictofImage.value(forKey: "item_img_list") as! NSArray
            
            } else {
                
                // Pass in the SecondVC
                secondvc.arrOfImages = NSArray()
            }
            
            secondvc.dictOfDetail = arrOfTilesAndDiscription[indexPath.row] as! NSDictionary
            navigationController?.pushViewController(secondvc, animated: true)
            
        } else {
            
            arrOfTilesAndDiscription = NSMutableArray()
            
            if indexPath.row < arrOfItemTypesHeirarchy.count {
                
                //print(arrOfItemTypesHeirarchy[indexPath.row])
                searchBar.text = (arrOfItemTypesHeirarchy[indexPath.row] as! NSDictionary).value(forKey: "type") as? String
                arrOfChildMenu = NSMutableArray()
                dictMenu = arrOfItemTypesHeirarchy[indexPath.row] as! NSDictionary
                createParentMenu()
                getTilesImagesAndDisciption()
                
            } else {
                
                //print(arrOfItemHierarchy[indexPath.row - (arrOfItemTypesHeirarchy.count)])
                searchBar.text = (arrOfItemHierarchy[indexPath.row - (arrOfItemTypesHeirarchy.count)] as! NSDictionary).value(forKey: "item_title") as? String
                
                arrOfTilesAndDiscription = arrOfItemHierarchy
            }
            viewSearch.isHidden = true
            
            collectionViewChildMenu.reloadData()
            collectionviewParentMenu.reloadData()
            
            tblTilesAndDetails.reloadSections(IndexSet(integersIn: 0...0), with: .top)
            tblTilesAndDetails.reloadData()

        }
        // To hide Key
        searchBar.resignFirstResponder()
    }
    // get dictionary on the Serial no From arrOfAllTilesImages Array
    func getImageOfTiles(serialno: String) -> NSDictionary {
        
        
        var dictOfImages = NSDictionary()
        for i in 0..<arrOfAllTilesImages.count {
            
            let imageSerialNo = (arrOfAllTilesImages[i] as! NSDictionary).value(forKey: "item_serial_no") as! String
            
            if imageSerialNo == serialno {
                
                dictOfImages = arrOfAllTilesImages[i] as! NSDictionary
                break
            }
        }
        return dictOfImages
    }
    @IBAction func btnBackClieked(_ sender: Any) {
        
       _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func btnClearMenuClicked(_ sender: Any) {
        
        searchBar.resignFirstResponder()
        
        arrOfParentMenu = NSMutableArray()
        arrOfChildMenu = NSMutableArray()
        
        arrOfChildMenu = arrOfAllMenus
        
        collectionViewChildMenu.reloadData()
        collectionviewParentMenu.reloadData()
        
        getTilesImagesAndDisciption()
        tblTilesAndDetails.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        viewSearch.isHidden = true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        arrOfItemTypesHeirarchy = NSMutableArray()
        arrOfItemHierarchy = NSMutableArray()
        arrOfAllSearchHierarchy = NSMutableArray()
        
        issearch = true
        
        if searchText.characters.count >= 1  {
            
            // To Create Like "<" Sign Heirarchy From Json File ItemType Key
            for i in 0..<arrOfAllMenus.count {
                
                let word = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "type") as! String
                
                if word.localizedCaseInsensitiveContains(searchText){
                
                   // print(i,"=",word)
                    
                    arrOfItemTypesHeirarchy.add(arrOfAllMenus[i] as! NSDictionary)
                    
                    let parentid = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "parent") as!
            
                    String
                    getParentMenuList(selectedMenuId: parentid)
                   // print(arrOfParentMenu)
                    
                    var strHierarachy = String()
                    for j in 0..<arrOfParentMenu.count {
                        
                        if strHierarachy.isEmpty {
                         
                            strHierarachy = "\((arrOfParentMenu[j] as! NSDictionary).value(forKey: "type") as! String)"
                            
                        } else {
                            
                            strHierarachy = "\(strHierarachy) < \((arrOfParentMenu[j] as! NSDictionary).value(forKey: "type") as! String)"
                        }
                    }
                    
                    strHierarachy = "\(strHierarachy) < \(word)"
                    arrOfAllSearchHierarchy.add(strHierarachy)
                    
                    arrOfParentMenu = NSMutableArray()
                    
                }
            }
            
            // To Create Heirarchy From Json File Item Key
//            for i in 0..<arrOfItemsDescription.count {
//                
//                let word = (arrOfItemsDescription[i] as! NSDictionary).value(forKey: "item_title") as! String
//                
//                if word.localizedCaseInsensitiveContains(searchText){
//                    
//                    if !arrOfAllSearchHierarchy.contains(word){
//                        
//                        arrOfItemHierarchy.add(arrOfItemsDescription[i] as! NSDictionary)
//                        arrOfAllSearchHierarchy.add(word)
//                    }
//                }
//            }
            
//            print(arrOfItemTypesHeirarchy)
//            print(arrOfItemHierarchy)
//            print(arrOfAllSearchHierarchy)
            tblSearchList.reloadData()

            if arrOfAllSearchHierarchy.count > 0 {
    
                viewSearch.isHidden = false
                tblSearchList.reloadData()
                
            } else {
                
                viewSearch.isHidden = true
            }
            
        } else {
            
            viewSearch.isHidden = true
        }
    }
    func keyboardDidShow(_ notification: NSNotification) {
     
        //tblSearchList.frame = CGRect(x: tblSearchList.frame.origin.x, y: 0, width: tblSearchList.frame.size.width, height: tblSearchList.frame.size.height - height)
        
        //print("Keyboard will show!")
        let keyboardSize:CGSize = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        //print("Keyboard size: \(keyboardSize)")
        
        let height = min(keyboardSize.height, keyboardSize.width)
        let width = max(keyboardSize.height, keyboardSize.width)
        
        tblSearchList.frame = CGRect(x: tblSearchList.frame.origin.x, y: 0, width: tblSearchList.frame.size.width, height: viewSearch.frame.size.height - height)
    }
    
    @IBAction func GridView(_ sender: UIButton) {
        if collView2.isHidden == true{
            collView2.isHidden = false
            tblTilesAndDetails.isHidden = true
            sender.setBackgroundImage(#imageLiteral(resourceName: "ic_action_grid_on"), for: .normal)
        }
        else{
            collView2.isHidden = true
            tblTilesAndDetails.isHidden = false
            sender.setBackgroundImage(#imageLiteral(resourceName: "ic_list"), for: .normal)

        }
        
    }
}
