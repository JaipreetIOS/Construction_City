//
//  SecondVC.swift
//  ConstructionCity
//
//  Created by Apple on 17/01/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import MessageUI
import Lottie
import FirebaseDynamicLinks
import Firebase
import NVActivityIndicatorView
//import DynamicLinks
import Crashlytics


var TempdictOfDetail         : NSDictionary!


class SecondVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate, NVActivityIndicatorViewable {
    
    fileprivate var fab: MIFab!
    static let DYNAMIC_LINK_DOMAIN = "d5q2p.app.goo.gl"

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewFav: UIView!
    @IBOutlet weak var myScrollview: UIScrollView!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblLeadtime    : UILabel!
    @IBOutlet weak var lblOrigin      : UILabel!
    @IBOutlet weak var lblFinish      : UILabel!
    @IBOutlet weak var lblSerialNo    : UILabel!
    @IBOutlet weak var collViewSecond2: UICollectionView!
    @IBOutlet weak var pageCntroller  : UIPageControl!
    @IBOutlet weak var collViewSecond : UICollectionView!
    @IBOutlet weak var btnFav: UIButton!
    
    var arrOfImages = NSArray()
    var dictOfDetail         : NSDictionary!
    var serialNo = String()
    
    var arrOfItemsDescription = NSMutableArray()
    var arrFavList = NSMutableArray()
    var isFav : Bool = false
    var animationView = LOTAnimationView(name: "star")
    var imageUrl : String = ""
    var DynamicLink : String = ""

//    var arrOfAllTilesImages = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FirebaseCrashMessage("Firebase_Key miss for Serial No :\(dictOfDetail.value(forKey: "item_serial_no") as! String)")

        self.automaticallyAdjustsScrollViewInsets = false
        navigationController?.hidesBarsOnSwipe = false

        
        collViewSecond.delegate = self
        collViewSecond.dataSource = self
        
        collViewSecond2.delegate = self
        collViewSecond2.dataSource = self
      animationView.frame = CGRect.init(x: view.frame.size.width - 66, y: 78, width: 50, height: 50)
        self.view.addSubview(self.animationView)
        self.view.bringSubview(toFront: btnFav)
        
        
        // Third Party
        setupFab()
        if UserDefaults.standard.value(forKey: "isLogged") != nil{
            if UserDefaults.standard.value(forKey: "isLogged") as! Bool == true{
        fetchDataFav()
            }
        }
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        SecondVC.attemptRotationToDeviceOrientation()
        self.title = "Detail"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    private func shouldAutorotate() -> Bool {
        return false
    }
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    private func preferredInterfaceOrientationForPresentation()-> UIInterfaceOrientation{
    return .portrait
}
    override func viewWillAppear(_ animated: Bool) {
        print(dictOfDetail)
        
        fetchDataFromjsonFile()

 animationView.frame = CGRect.init(x: view.frame.size.width - 66, y: 78, width: 50, height: 50)
        animationView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        if dictOfDetail.value(forKey: "firebase_key") is String{
            
        }
        else{
//            dictOfDetail = TempdictOfDetail
            
        }
        
        
        if arrOfImages.count > 1 {
            
            // set Number of Pages
            pageCntroller.numberOfPages = arrOfImages.count
            
        } else {
            
            pageCntroller.numberOfPages = 0
        }

        // Set Serial No
        if dictOfDetail.value(forKey: "item_serial_no") != nil {
            lblSerialNo.text  = dictOfDetail.value(forKey: "item_serial_no") as? String
        }
        else{
           lblSerialNo.text  = "none"
        }
        // Set Finsh
        if let finish = dictOfDetail.value(forKey: "item_finish") {
            lblFinish.text  = String(describing: finish)
        }else{
            lblFinish.text  = "none"
        }
        // Set Origin
        if let origin = dictOfDetail.value(forKey: "item_place_of_origin") {
            lblOrigin.text  = String(describing: origin)
        }else{
            lblOrigin.text  = "none"
        }
        // Set Time
        if let time = dictOfDetail.value(forKey: "item_lead_time") {
            lblLeadtime.text  = String(describing: time)
        }else{
           lblLeadtime.text  = "none"
        }
        // Set Description
        if let des = dictOfDetail.value(forKey: "item_extra_description") {
            lblDescription.text  = String(describing: des)
        }else{
           lblDescription.text  = "none"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchDataFav() {
        
        FirebaseCrashMessage("Firebase_Key miss for Serial No :\(dictOfDetail.value(forKey: "item_serial_no") as! String)")
//        fatalError()
//        Crashlytics.sharedInstance().crash()

        _ = databaseRef.child("favorite").child(UserDefaults.standard.value(forKey: "UID") as! String).observe(.value, with: { (snapshot) -> Void in
            print(snapshot)
            //
            if snapshot.value is NSDictionary{
            
                 let messageData = snapshot.value as! NSDictionary
            
            
            self.arrFavList = NSMutableArray.init(array: messageData.allKeys as NSArray)
            let firebase_key = self.dictOfDetail.value(forKey: "firebase_key") as? String
             
            if self.arrFavList.contains(firebase_key!){
//                self.btnFav.setBackgroundImage(#imageLiteral(resourceName: "ic_action_star.png") , for: .normal)
               
                self.animationView.play()
                self.isFav = true
//notasecret
            }
            else{
                self.animationView.stop()
                self.isFav = false
            }
            }
            else{
//                self.btnFav.setBackgroundImage(#imageLiteral(resourceName: "ic_action_star_border") , for: .normal)
                self.animationView.stop()

                }
            
        })
        
    }
    func fetchDataFromjsonFile() {
        
        
        _ = databaseRef.child("newItems").queryOrdered(byChild: "_type_id").queryEqual(toValue: dictOfDetail.value(forKey: "_type_id") as! String).observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
            //
            let messageData = snapshot.value as! NSDictionary
            
            self.arrOfItemsDescription.add(messageData)


            self.collViewSecond2.reloadData()

            
           
        })
        
        
        
        
     
    }
    func getRelatedTilesOnTheTypeId(array: NSArray,typeid: String){
        
        for i in 0..<array.count {
            
            let tileTypeId = (array[i] as! NSDictionary).value(forKey: "_type_id") as! String
            
            if tileTypeId == typeid {
                
                arrOfItemsDescription.add(array[i] as! NSDictionary)
            }
        }
        
    }
    // Scroll View Delegates
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // set Cuurent Page
        let pagewidth = collViewSecond.frame.size.width
        let currentPage = collViewSecond.contentOffset.x / pagewidth
        pageCntroller.currentPage = Int(currentPage)
    }
    // MARK: -  UICollectionViewDelegateFlowLayout 
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(collectionView == collViewSecond){
            
            return CGSize(width: self.collViewSecond.frame.size.width, height: self.collViewSecond.frame.size.height)
        }
        else{
            return CGSize(width:116, height: 136)
        }
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == collViewSecond){
          return arrOfImages.count
        }
        else{
            return arrOfItemsDescription.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == collViewSecond){
            
            let cell = collViewSecond.dequeueReusableCell(withReuseIdentifier: "SecondCCC1", for: indexPath) as! SecondCCC1
            
            let strimgRef = storageRef.child("mid").child("\(lblSerialNo.text!)").child(arrOfImages[indexPath.row] as! String)
            
            strimgRef.downloadURL { (downloadUrl, err) in
                
                if err != nil {
                    
                    print(err?.localizedDescription ?? "")
                    return
                    
                } else {
                    if indexPath.row == 0{
                    self.imageUrl = String(describing: downloadUrl!)
                    }
                    cell.imgViewMain.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                }
            }
            return cell
        }
        else{
            
            let cell = collViewSecond2.dequeueReusableCell(withReuseIdentifier: "SecondCCC2", for: indexPath) as! SecondCCC2

            let dictOfData = arrOfItemsDescription[indexPath.row] as! NSDictionary
            
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String
            
            cell.lblTileSerialNo.text = serialno
            cell.bgView.layer.cornerRadius = 4
            cell.bgView.layer.cornerRadius = 6
            cell.bgView.layer.masksToBounds = false
            cell.bgView.layer.shadowColor = UIColor.black.cgColor
            cell.bgView.layer.shadowOffset = CGSize(width: 1, height: 3)
            cell.bgView.layer.shadowRadius = 3
            cell.bgView.layer.shadowOpacity = 0.2

            
            cell.lblTileTitle.text = dictOfData.value(forKey: "item_title") as? String
            
            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                let strimgRef = storageRef.child("mid").child(dictofImage.value(forKey: "item_serial_no") as! String).child((dictofImage.value(forKey: "item_img_list") as! NSArray)[0] as! String)
                
                strimgRef.downloadURL { (downloadUrl, err) in
                    
                    if err != nil {
                        
                        print(err?.localizedDescription ?? "")
                        return
                    } else {
                        
                        cell.imgViewMain.reloadImageProgress(withUrl: String(describing: downloadUrl!))
                    }
                }
            }
            return cell
        }   
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
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
    
        if collectionView == collViewSecond2 {
            
            // get dicdtionary
            let dictOfData = arrOfItemsDescription[indexPath.row] as! NSDictionary
            
            // get Serial No From dictionary
            let serialno = dictOfData.value(forKey: "item_serial_no") as? String
            
            // get dictionary on the Serial no From arrOfAllTilesImages Array
            let dictofImage = getImageOfTiles(serialno: serialno!)
            
            if dictofImage.allKeys.count > 0 {
                
                // Pass in the arrOfImages
                arrOfImages = dictofImage.value(forKey: "item_img_list") as! NSArray
                
            } else {
                
                // Pass in the arrOfImages
                arrOfImages = NSArray()
            }
            dictOfDetail = arrOfItemsDescription[indexPath.row] as! NSDictionary
        }
        viewDidLoad()
        viewWillAppear(true)
        collViewSecond.reloadData()
        Helper.gotoTopInScrollview(scrollview: myScrollview)
        
    }
    @IBAction func btnBackClicked(_ sender: Any) {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    fileprivate func setupFab() {
        
        var fabConfig = MIFab.Config()
        
        
        fabConfig.buttonImage = #imageLiteral(resourceName: "ic_more_vert")
        fabConfig.buttonBackgroundColor = #colorLiteral(red: 0.1654347479, green: 0.7299206257, blue: 0.8347867131, alpha: 1)
        
        fab = MIFab(
            parentVC: self,
            config: fabConfig,
            options: [
                MIFabOption(
                    title: "Call",
                    image: #imageLiteral(resourceName: "ic_launcher-1"),
                    backgroundColor: #colorLiteral(red: 0.1642496586, green: 0.7259336114, blue: 0.8350980282, alpha: 1),
                    tintColor: UIColor.white,
                    actionClosure: {
                        
                        self.CallOnNumber()

                }
                ),
                MIFabOption(
                    title: "Chat",
                    image: #imageLiteral(resourceName: "ic_launcher-2"),
                    backgroundColor: #colorLiteral(red: 0.1647058824, green: 0.7254901961, blue: 0.8352941176, alpha: 1),
                    tintColor: UIColor.white,
                    actionClosure: {
                        
                        self.SendMail(tileSerialNo: self.lblSerialNo.text!)
                        
                }
                )
            ]
        )
        
        fab.showButton(animated: true)
        
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
    func SendMail(tileSerialNo: String){
        if UserDefaults.standard.value(forKey: "isLogged") != nil{
            if UserDefaults.standard.value(forKey: "isLogged") as! Bool == true{
          AddToChat()
                
            }
            else{
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
                mainvc.ComingFrom = "Detail"
                mainvc.dictOfDetail = dictOfDetail
                TempdictOfDetail = dictOfDetail
                
                navigationController?.pushViewController(mainvc, animated: true)
            }
        }
        else{
            let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
            mainvc.ComingFrom = "Detail"
            mainvc.dictOfDetail = dictOfDetail
            TempdictOfDetail = dictOfDetail
            navigationController?.pushViewController(mainvc, animated: true)
        }
    }
    func AddToChat()  {
        let itemRef = databaseRef.child("chat_profile").child(UserDefaults.standard.value(forKey: "UID") as! String)
        
        let messageItem = [
            "displayUserName": UserDefaults.standard.value(forKey: "userName") as! String,
            "uid": UserDefaults.standard.value(forKey: "UID") as! String,
            "resentTimeStamp": Int(Date().timeIntervalSince1970) * 1000,
            ] as [String : Any]
        itemRef.updateChildValues(messageItem, withCompletionBlock: { (error, response) in
            
            if (error != nil) {
                
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        })
        
        
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    @IBAction func Favourite(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "isLogged") != nil{
            if UserDefaults.standard.value(forKey: "isLogged") as! Bool == true{
                if isFav == false{
                    UpdateFav(status: "1")
                }
                else{
                    UpdateFav(status: "0")

                }
                
            }
            else{
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
                mainvc.ComingFrom = "Detail"
                mainvc.dictOfDetail = dictOfDetail
                TempdictOfDetail = dictOfDetail

                navigationController?.pushViewController(mainvc, animated: true)
            }
        }
        else{
            let mainvc = storyboard?.instantiateViewController(withIdentifier: "FacebookLoginVC") as! FacebookLoginVC
            mainvc.ComingFrom = "Detail"
            mainvc.dictOfDetail = dictOfDetail
            TempdictOfDetail = dictOfDetail
            navigationController?.pushViewController(mainvc, animated: true)
        }
    }
    
    func UpdateFav(status : String)   {
        let firebase_key = dictOfDetail.value(forKey: "firebase_key") as? String
        
        
        if firebase_key == nil{
            
            
            
        }
        else{
        
        
        if status == "1"{
            print("Add fav")
//            btnFav.setBackgroundImage(#imageLiteral(resourceName: "ic_action_star.png") , for: .normal)
            
            let key = databaseRef.child("favorite").child(UserDefaults.standard.value(forKey: "UID") as! String)
            let firebase_key = dictOfDetail.value(forKey: "firebase_key") as? String
            
            let post = [
                        "\(firebase_key!)" : dictOfDetail,
            ]
            key.updateChildValues(post)
            let alert = UIAlertController.init(title: "", message: "Successfully Add in Favourite", preferredStyle: .alert)
          
            animationView.play{ (finished) in
                // Do Something
            }
            self.isFav = true

            let when = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            
            self.present(alert, animated:true, completion:nil)
            
//            databaseRef.updateChildValues(post)
            
        }
        else{
            print("remove fav")
            let firebase_key = dictOfDetail.value(forKey: "firebase_key") as? String

            let key = databaseRef.child("favorite").child(UserDefaults.standard.value(forKey: "UID") as! String).child(firebase_key!)
            key.removeValue()
//            btnFav.setBackgroundImage(#imageLiteral(resourceName: "ic_action_star_border.png") , for: .normal)
            let alert = UIAlertController.init(title: "", message: "Successfully Remove From Favourite", preferredStyle: .alert)
            
            self.isFav = false
            animationView.stop()
            let when = DispatchTime.now() + 2.5
            DispatchQueue.main.asyncAfter(deadline: when)
            {
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            
            self.present(alert, animated:true, completion:nil)


        }
    }
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collViewSecond.reloadData()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

        animationView.frame = CGRect.init(x: btnFav.frame.origin.x + 10, y: btnFav.frame.origin.y + 10, width: 50, height: 50)



        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        animationView.frame = CGRect.init(x: btnFav.frame.origin.x + 10, y: btnFav.frame.origin.y + 10, width: 50, height: 50)
//        setupFab()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

        
       


    }

    func createDeeplink()  {
        // [START buildFDLLink]
        if SecondVC.DYNAMIC_LINK_DOMAIN != "https://d5q2p.app.goo.gl" {
          
        }
        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)

       let linkString  = link
        
        guard let link = URL(string: "http://www.ccityhk.com/product/\(dictOfDetail.value(forKey: "firebase_key") as! String)") else { return }
        
        
        print(link)
    
        let com = DynamicLinkComponents.init(link: link, domain: SecondVC.DYNAMIC_LINK_DOMAIN)
//        let analiGoogle = DynamicLinkGoogleAnalyticsParameters.init(source: "jdhafkl", medium: "jdf", campaign: "dfhjv")
//        analiGoogle.term = ""
//        analiGoogle.content = ""
//        com.analyticsParameters = analiGoogle
       
      
        

         let bundleID = "com.ahomehk.constructioncity"
        
        
            let iOSParams = DynamicLinkIOSParameters(bundleID: bundleID)
//            if let fallbackURL = dictOfDetail.value(forKey: "firebase_key")  {
//                iOSParams.fallbackURL = URL(string: fallbackURL as! String)
//            }
        iOSParams.minimumAppVersion = "1.0"
        iOSParams.customScheme = "AppOnDynamicLink"
            iOSParams.iPadBundleID = "com.ahomehk.constructioncity"
//            if let iPadFallbackURL = dictOfDetail.value(forKey: "firebase_key")  {
//                iOSParams.iPadFallbackURL = URL(string: iPadFallbackURL as! String)
//        }
            iOSParams.appStoreID = "1270165214"
            com.iOSParameters = iOSParams

//        let appStoreParams = DynamicLinkItunesConnectAnalyticsParameters()
//            appStoreParams.affiliateToken = "8"
//            appStoreParams.campaignToken = "newsletter1"
//            appStoreParams.providerToken = "itunes"
//        
//            com.iTunesConnectParameters = appStoreParams
        
//        https://itunes.apple.com/us/app/construction-city/id1270165214?ls=1&mt=8

         let packageName = "com.ahomehk.constructioncityv2"
            let androidParams = DynamicLinkAndroidParameters(packageName: packageName )
//            if let androidFallbackURL = dictOfDetail.value(forKey: "firebase_key") {
//                androidParams.fallbackURL = URL(string: androidFallbackURL as! String)
//            }
                androidParams.minimumVersion = 1
            
            com.androidParameters = androidParams
        

        let socialParams = DynamicLinkSocialMetaTagParameters()
        socialParams.title = dictOfDetail.value(forKey: "item_title") as? String
        socialParams.descriptionText = lblSerialNo.text!
        print(imageUrl)
        socialParams.imageURL = URL.init(string: imageUrl)
        com.socialMetaTagParameters = socialParams

       let longLink = com.url
        print(longLink?.absoluteString ?? "")
        // [END buildFDLLink]

       

        // [START shortLinkOptions]
        let options = DynamicLinkComponentsOptions()
        options.pathLength = .unguessable
        com.options = options
        // [END shortLinkOptions]

        // [START shortenLink]
        com.shorten { (shortURL, warnings, error) in
            // Handle shortURL.
            if let error = error {
                print(error.localizedDescription)
                return
            }
           let shortLink = shortURL
            print(shortLink?.absoluteString ?? "")
            self.DynamicLink = shortLink?.absoluteString ?? ""
            
            self.sendDeepLink()
            // [START_EXCLUDE]
           // [END_EXCLUDE]
        }
        self.stopAnimating()
        // [END shortenLink]
    
    }
    func sendDeepLink()  {
        
        let textToShare = ""
        if let myWebsite = NSURL(string: DynamicLink) {
            
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = btnShare
            present(activityVC, animated: true, completion: nil)
        }
    }

    @IBAction func Share(_ sender: UIButton) {
        createDeeplink()

       
        
    }
   


    
    
    
}

