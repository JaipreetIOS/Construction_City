//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Contacts



protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}

class MenuViewController: UIViewController , UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate{
    
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Menu button which was tapped to display the menu
    */

    var btnMenu : UIButton!

    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    @IBOutlet weak var tblMenu: UITableView!
    
    let arrOfSectionTitle: NSArray = ["  Service","  Tool","  Job reference","  Stone","  others","  latest project","  Artificial plants","  Furniture","  Aluminium","  Vinyl flooring","  Carpet","  news","  designer","  design","  Tile","  Glass","  Stainless Steel"]
    
    
    let arrOfServices: NSArray = ["Epoxy","Waterproofing"]
    let arrOfTotal: NSArray = ["Safety","Painting"]
    let arrOfJobPreference: NSArray = ["chain store","shop","office","hotel","supermarket","others","school","mtr","restaurant","department store"]
    
    let arrOfStone: NSArray = ["Sand Stone","Granite","Culture stone","Marble","Basalt","Onxy","Travertine","Quartz Stone","Terrazzo","Artificial Stone"]
    
    let arrOfArtificialPlants: NSArray = ["Flower","Grass","Tree"]
    
    let arrOfTile: NSArray = ["Wall Tile","Outdoor Wall Tile","Mosaic Tile","Mosaic Tile","Floor Tile","Patchwork Tile","Glazed Tile","Subway Tile","Ceramic Tile","Mosaic Tile","Patchwork Tile","Hexagon","Ceramic Tile (Wooden Pattern)","Wall Tile","Roof Tile","Ceramic","Non Slip Tile","Stone","Stone Pattern","Stainless Steel","Handmade Tile","Outdoor Plaza Brick","Square"]
    
    var gameTimer: Timer!
    @IBOutlet weak var viewMenu: UIView!
    
    var isExpand: Bool = false
    var stateArray          = [Bool]() // EXPAND TABLE VIEW
    
    var arrOfMenu = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        btnCloseMenuOverlay.fadeIn(0.3, delay: 0.0) { (true) in
//            self.btnCloseMenuOverlay.fadeIn()
//        }

        stateArray = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
        
        // Fetch data from constructioncity_ahomehk_export.json file
        fetchDataFromjsonFile()

    }
    func fetchDataFromjsonFile() {
        
        // Fetch data from constructioncity_ahomehk_export.json file
        if let path = Bundle.main.path(forResource: "constructioncity-ahomehk-export", ofType: "json") {
            do {
                
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                do{
                    
                    // JsonResponse Data
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    arrOfMenu = jsonResult.object(forKey: "itemType") as! NSMutableArray
                    
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
    // MARK: -  UITableViewDataSource Mehtods 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //return 60
        if stateArray[indexPath.section] {
            
            return 30
            
        }else{
            
            return 0
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return arrOfSectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case 0:
            return arrOfServices.count
            
            
        case 1:
            return arrOfTotal.count
            
            
        case 2:
            return arrOfJobPreference.count
            
            
        case 3:
            return arrOfStone.count
            
            
        case 6:
            return arrOfArtificialPlants.count
            
            
        case 14:
            return arrOfTile.count
            
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblMenu.dequeueReusableCell(withIdentifier: "Tblcell", for: indexPath) as! Tblcell
        
        switch indexPath.section {
            
        case 0:
            cell.lblMenu.text = arrOfServices[indexPath.row] as? String
            break
            
        case 1:
            cell.lblMenu.text = arrOfTotal[indexPath.row] as? String
            break
            
        case 2:
            cell.lblMenu.text = arrOfJobPreference[indexPath.row] as? String
            break
            
        case 3:
            cell.lblMenu.text = arrOfStone[indexPath.row] as? String
            break
            
        case 6:
            cell.lblMenu.text = arrOfArtificialPlants[indexPath.row] as? String
            break
            
        case 14:
            cell.lblMenu.text = arrOfTile[indexPath.row] as? String
            break
            
        default: break
            
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: tblMenu.frame.size.width, height: 40))
        headerView.tag = section;
        
        headerView.backgroundColor = UIColor.clear
        
        
        let uilbl:UILabel = UILabel(frame: CGRect(x: 8, y: 5, width: tblMenu.frame.size.width - 16 , height: 30))
        uilbl.textColor = UIColor.white
        uilbl.backgroundColor = UIColor(red: 198/255 , green: 40/255, blue: 40/255, alpha: 1.0)
        uilbl.textAlignment = .left
        uilbl.layer.cornerRadius = 7
        
        uilbl.text = (arrOfSectionTitle.object(at: section) as! String)
        uilbl.clipsToBounds = true
        
        headerView.addSubview(uilbl)
        
        var imgview: UIImageView = UIImageView()
        
        if section == 0 || section == 1 || section == 2 || section == 3 || section == 6 || section == 14 {
        
            imgview = UIImageView(frame: CGRect(x: tblMenu.frame.size.width - 36, y: 10, width: 20, height: 20))
        }
        
        if stateArray[section] {
            
            imgview.image = UIImage(named: "upArrow.png")
            
        } else {
            
            imgview.image = UIImage(named: "DownArrow.png")
            
        }
        
        headerView.addSubview(imgview)
        
        let headerGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderTapped))
        
        headerView.addGestureRecognizer(headerGesture)
        
        return headerView;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            getParentId(strMenuName: arrOfServices[indexPath.row] as! String)
            break
            
        case 1:
            getParentId(strMenuName: arrOfTotal[indexPath.row] as! String)
            break
            
        case 2:
            getParentId(strMenuName: arrOfJobPreference[indexPath.row] as! String)
            break
            
        case 3:
            getParentId(strMenuName: arrOfStone[indexPath.row] as! String)
            break
            
        case 6:
            getParentId(strMenuName: arrOfArtificialPlants[indexPath.row] as! String)
            break
            
        case 14:
            getParentId(strMenuName: arrOfTile[indexPath.row] as! String)
            break
            
        default: break
            
        }
    }
    func getParentId(strMenuName: String) {
        
        for i in 0..<arrOfMenu.count {
            
            // To Get ParentId
            if strMenuName.lowercased() == ((arrOfMenu[i] as! NSDictionary).value(forKey: "type") as! String).lowercased() {
                
                //print(arrOfMenu[i])
                
                let mainvc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                mainvc.dictMenu = (arrOfMenu[i] as! NSDictionary)
                navigationController?.pushViewController(mainvc, animated: true)
                
                break
                
            }
        }
        
        // To close Menu
        let btn = UIButton(type: .custom)
        btnCloseClicked(btn)
    
    }
    
    
    /* ====== MARK:  SECTION HEADER TAP (FOR EXPAND TABLEVIEW) ===== */
    func sectionHeaderTapped(_ gestureRecognizer:UITapGestureRecognizer){
        
        if let section = gestureRecognizer.view?.tag {
            
            
            stateArray[section] = !stateArray[section]
            self.tblMenu.reloadSections(NSIndexSet(index: section) as IndexSet, with: UITableViewRowAnimation.fade)
        }
    }
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        
        btnMenu.tag = 0
        Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index: index)
        }
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            Helper.viewSlideInFromRightToLeft(views: self.viewMenu)
        })
    }
    func runTimedCode() {
        
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
}
// For FadeIn Out Animation
extension UIView{
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

