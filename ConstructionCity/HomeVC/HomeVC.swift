//
//  HomeVC.swift
//  ConstructionCity
//
//  Created by Apple on 17/07/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth
// To get all tiles images
// To get all tiles images

var arrOfAllTilesImages = NSMutableArray()
var arrOfAllMenus = NSMutableArray()


class HomeVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , NVActivityIndicatorViewable {
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var pager: UIPageControl!
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var scrollview: UIScrollView!
 
    @IBOutlet weak var tblhieht: NSLayoutConstraint!
    @IBOutlet weak var collectionviewItems: UICollectionView!
    @IBOutlet weak var btnSideMenu: UIButton!
    
    @IBOutlet weak var collectionviewHome: UICollectionView!
    
    
    let arrOfItemsImagesName: NSArray = ["product_btn.png",
                                         "tool_btn.png",
                                         "furniture_btn.png",
                                         "design_work_btn.png",
                                         "contracting_work_btn.png",
                                         "licencing_service_btn.png",
                                         "news_btn.png",
                                         "contact_btn.png"]
    
    let arrOfItemName: NSArray = ["Product","Tool","Furniture","Design Work","Contracting","Licencing Services","News","Contact"]
    
    var arrOfItemData = [NSDictionary]()
    
    var arrOfAdvertiseImagesName = NSMutableArray()
    
    
    var arrOfItemDescription = NSMutableArray()
    
    // To get all tiles images
//    var arrOfAllTilesImages = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = SDImageCacheType.none
       
        btnLogout.isHidden = true

        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)

        
        btnLogout.layer.cornerRadius = 20
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8260540962, green: 0.2374212444, blue: 0.204682529, alpha: 1)
        
        
        let leftItem = UIBarButtonItem(title: "Construction City",
                                       style: .plain,
                                       target: self,
                                       action: nil)
//        leftItem.isEnabled = false
    
        leftItem.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.title = " "

        let category =  UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_action_menu"), style: .plain, target: self, action: #selector(Category(_:)))
        let search = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_action_search"), style: .plain, target: self, action: #selector(btnSearchCliked(_:)))

     
        let fav = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_action_star-1"), style: .plain, target: self, action: #selector(Favourite(_:)))
        
        category.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        search.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        fav.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        navigationItem.rightBarButtonItems = [fav, search, category]

    }
    
    override func viewDidLayoutSubviews() {
        
        scrollview.layoutIfNeeded()
        
        
        tblHome.frame = CGRect(x: 0, y: 430, width: view.frame.size.width, height: tblHome.contentSize.height)
        tblhieht.constant = tblHome.contentSize.height + 50

        scrollview.contentSize = CGSize(width: view.frame.size.width, height: tblHome.contentSize.height +
        430)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        collectionviewHome.reloadData()
        collectionviewItems.reloadData()
        
        getAdvertImagesNamesFromFireBaseDatabase()
        fetchDataFromjsonFile()
        getAdvertImagesBaseDatabase()
        
        
        if UserDefaults.standard.value(forKey: "isLogged") != nil{
            if UserDefaults.standard.value(forKey: "isLogged") as! Bool == true{
                btnLogout.isHidden = false
            }
        }
    }
    func getAdvertImagesNamesFromFireBaseDatabase() {
        
        
        databaseRef.child("0").child("adverts").observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot)
            
            self.arrOfAdvertiseImagesName = snapshot.value as! NSMutableArray
            //print(self.arrOfAdvertiseImagesName)
  
            // To Remove "<null>" Value
            self.arrOfAdvertiseImagesName.removeObject(identicalTo: NSNull())
            self.stopAnimating()

            //print(self.arrOfAdvertiseImagesName)
            
            self.pager.numberOfPages = self.arrOfAdvertiseImagesName.count
            self.collectionviewHome.reloadData()
            
        })
    }
    func getAdvertImagesBaseDatabase() {
        

        databaseRef.child("itemType").observe( .value, with: { (snapshot) in
//            print(snapshot)
            let messageData = snapshot.value
            
            arrOfAllMenus = NSMutableArray.init(array: messageData as! NSArray)
//            arrOfItemsDescription = NSMutableArray.init(array: messageData.value(forKey: "item") as! NSArray)

           self.stopAnimating()
            
            self.arrOfItemData = [NSDictionary()]
            // Arrange Menu In Display Menu Items like on Type Id Of Item
            for i in 0..<arrOfAllMenus.count {
                
                let type_id = (arrOfAllMenus[i] as! NSDictionary).value(forKey: "_type_id") as! String
                
                //print(type_id)
                switch type_id {
                case "0":
                    
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 0)
                    break
                case "51":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 1)
                    break
                case "71":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 2)
                    break
                case "52":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 3)
                    break
                case "37":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 4)
                    break
                case "33":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 5)
                    break
                case "49":
                    self.insertElementAtIndex(element: arrOfAllMenus[i] as! NSDictionary, index: 6)
                    break
                default:
                    break
                }
            }
            
            
            // Arrang Array in Collection View Display Order Like First Product,Tool,Furniture and So On....
            self.arrOfItemData.remove(at: 3)
            self.arrOfItemData.remove(at: 4)
            self.arrOfItemData.remove(at: 4)
            self.arrOfItemData.remove(at: 5)
            self.arrOfItemData.remove(at: 7)
            
            let arrtemp = NSMutableArray()
            arrtemp[0] = self.arrOfItemData[6]
            self.arrOfItemData[6] = self.arrOfItemData[5]
            self.arrOfItemData[5] = arrtemp[0] as! NSDictionary
            
            
            self.tblHome.reloadData()
            
        })
        
        
        
        
        databaseRef.child("image").observe( .value, with: { (snapshot) in
            //            print(snapshot)
            let messageData = snapshot.value
            
            //            arrOfItemsDescription = NSMutableArray.init(array: messageData.value(forKey: "item") as! NSArray)
            arrOfAllTilesImages = NSMutableArray.init(array: messageData as! NSArray)
            
//            self.stopAnimating()
            
      
            
            
            self.tblHome.reloadData()
            
        })
        
        
        
        
    }

    func fetchDataFromjsonFile() {
        
        self.arrOfItemDescription.removeAllObjects()
        _ = databaseRef.child("newItems").queryOrdered(byChild: "this_week_top").queryEqual(toValue: 1).observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
//
            let messageData = snapshot.value as! NSDictionary
            self.stopAnimating()

            
            self.arrOfItemDescription.add(messageData)
            print(self.arrOfItemDescription)
            
            self.scrollview.layoutIfNeeded()
            
            
            self.tblHome.frame = CGRect(x: 0, y: 380, width: Int(self.view.frame.size.width), height: self.arrOfItemDescription.count * 150)
            
            self.scrollview.contentSize = CGSize(width: self.view.frame.size.width, height: self.tblHome.contentSize.height +
                380)
            
            self.tblhieht.constant = self.tblHome.contentSize.height
            self.tblHome.reloadData()
            
        })
        
  
        
        
      
        
    }
    func getThisWeekTopTiles(array: NSArray){
        
        for i in 0..<array.count {
            
            let thisweektop = (array[i] as! NSDictionary).value(forKey: "this_week_top") as! NSNumber
            
            if thisweektop == 1 {
                
                arrOfItemDescription.add(array[i] as! NSDictionary)
            }
        }
//        print(arrOfItemDescription)
    }
    func insertElementAtIndex(element: NSDictionary, index: Int) {
        
        
        while arrOfItemData.count < index + 1 {
            arrOfItemData.append(NSDictionary())
        }
        if element.allKeys.count > -1 {
            
            arrOfItemData.insert(element, at: index)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        collectionviewHome.delegate = self
        collectionviewHome.dataSource = self
        
        collectionviewItems.delegate = self
        collectionviewItems.dataSource = self
    }
    // MARK: -  UITableViewDataSource Methods 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        print(arrOfItemDescription.count)
        
        return arrOfItemDescription.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tblhieht.constant = tblHome.contentSize.height + 100
        scrollview.contentSize = CGSize(width: view.frame.size.width, height: tblHome.contentSize.height +
            470)
        let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeTableVCell", for: indexPath) as! HomeTableVCell
        
        let dictOfDescription = arrOfItemDescription[indexPath.row] as! NSDictionary
        let serialno = dictOfDescription.value(forKey: "item_serial_no") as? String
        
        cell.lblSerialNo.text = serialno
        
        
        cell.lblTileTitle.text = dictOfDescription.value(forKey: "item_title") as? String
        
        let dictofImage = getImageOfTiles(serialno: serialno!)
        
        if dictofImage.allKeys.count > 0 {
            
            let strimgRef = storageRef.child("mid").child(dictofImage.value(forKey: "item_serial_no") as! String).child((dictofImage.value(forKey: "item_img_list") as! NSArray)[0] as! String)
            
            strimgRef.downloadURL { (downloadUrl, err) in
                
                if err != nil {
                    
                    print(err?.localizedDescription ?? "")
                    return
                } else {
                    
                    cell.imgTile.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                }
            }
        }
        cell.lblHeightWidth.text = dictOfDescription.value(forKey: "item_width_height") as? String
        
        cell.lblColor.text = dictOfDescription.value(forKey: "item_color") as? String
        
        cell.lblTileFinish.text = dictOfDescription.value(forKey: "item_finish") as? String
        
        return cell
    }
    // MARK: -  UICollectionViewDelegate 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let secondvc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        
        // get dicdtionary
        let dictOfData = arrOfItemDescription[indexPath.row] as! NSDictionary
        
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
        
        secondvc.dictOfDetail = arrOfItemDescription[indexPath.row] as! NSDictionary
        navigationController?.pushViewController(secondvc, animated: true)
        
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
    // MARK: -  UICollectionViewDelegateFlowLayout Mehtod 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collectionviewItems {

            //print(collectionviewItems.frame.size)
            return CGSize(width: (collectionviewItems.frame.size.width - 25 ) / 4, height: (collectionviewItems.frame.size.height - 5) / 2)
            
        } else {
            
            return CGSize(width: view.frame.width, height: collectionviewHome.frame.size.height)
        }
        
    }
    // MARK: -  UICollectionViewDataSource Methods 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionviewHome {
            
            return arrOfAdvertiseImagesName.count
            
        } else {
            
            return arrOfItemsImagesName.count
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionviewHome {
            
            let cell = collectionviewHome.dequeueReusableCell(withReuseIdentifier: "HomeCollectionVCell", for: indexPath) as! HomeCollectionVCell
            
            
            let strimgRef = storageRef.child("advert/").child(arrOfAdvertiseImagesName[indexPath.row] as! String)
            
            strimgRef.downloadURL { (downloadUrl, err) in
                
                if err != nil {
                    
                    print(err?.localizedDescription ?? "")
                    return
                } else {
                    
                    cell.imgFurniture.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                }
            }
            //cell.imgFurniture.image = UIImage(named: arrOfAdvertiseImagesName[indexPath.row] as! String)
            
             return cell
            
        } else {
            
            let cell = collectionviewItems.dequeueReusableCell(withReuseIdentifier: "HomeCollectionVCell", for: indexPath) as! HomeCollectionVCell
            
            cell.imgAllItems.image = Helper.cropImageToSquare(image: UIImage(named: arrOfItemsImagesName[indexPath.row] as! String)!)
            
            cell.lblItemName.text = arrOfItemName[indexPath.row] as? String
            
            if indexPath.row == 5 {
                
//                cell.lblItemName.font = UIFont.systemFont(ofSize: 7)
                
            }
            
             return cell
        }
       
    }
    // MARK: -  UICollectionViewDelegate Methods 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionviewItems {
            
            // because We Can't select Contact
            if indexPath.row < 7 {
            
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainvc.dictMenu = arrOfItemData[indexPath.row] 
                navigationController?.pushViewController(mainvc, animated: true)
                
            } else {
                
                CallOnNumber()
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionviewHome.contentOffset
        visibleRect.size = collectionviewHome.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        let visibleIndexPath: IndexPath = collectionviewHome.indexPathForItem(at: visiblePoint)!

        if let isCollectionview = collectionviewHome {
            
            pager.currentPage = visibleIndexPath.row
        }
    }
    // When Click On PhoneButton to call on given number
    @IBAction func btnPhoneCallClicked(_ sender: Any) {
        
        CallOnNumber()
    }
    func CallOnNumber(){
        
        if let phoneCallURL:URL = URL(string: "tel:+85260744893") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "MyApp", message: "Are you sure you want to call \n+85260744893 ?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.open(phoneCallURL)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func btnSearchCliked(_ sender: Any) {
        
        let mainvc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        mainvc.issearch = true
        navigationController?.pushViewController(mainvc, animated: true)
    }
    @IBAction func Favourite(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "isLogged") != nil{
            if UserDefaults.standard.value(forKey: "isLogged") as! Bool == true{
        let mainvc = storyboard?.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
        navigationController?.pushViewController(mainvc, animated: true)
            }
            else{
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
                navigationController?.pushViewController(mainvc, animated: true)
            }
        }
        else{
            let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
            navigationController?.pushViewController(mainvc, animated: true)
        }
    }
    @IBAction func Logout(_ sender: Any) {
//        let firebaseAuth = FIRAuth.auth()
        do {
            try Auth.auth().signOut()
            
                      UserDefaults.standard.set(false, forKey: "isLogged")
            btnLogout.isHidden = true
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func Category(_ sender: Any) {
        let mainvc = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        navigationController?.pushViewController(mainvc, animated: true)
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionviewHome.reloadData()
        collectionviewItems.reloadData()

        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //        setupFab()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
        
        
        
        
    }
}
