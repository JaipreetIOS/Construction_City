//
//  FavouriteVC.swift
//  ConstructionCity
//
//  Created by Apple on 25/10/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FavouriteVC: UIViewController , UITableViewDataSource , UITableViewDelegate , NVActivityIndicatorViewable{
    var arrOfTilesAndDiscription = NSMutableArray()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblTilesAndDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        getFavBaseDatabaseChanged()
        self.title = "My Favourite"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]

        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {

        getFavBaseDatabase()

    }
    func getFavBaseDatabase() {
        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)

        databaseRef.child("favorite").child(UserDefaults.standard.value(forKey: "UID") as! String).observe( .value, with: { (snapshot) in
            print(snapshot)
            self.arrOfTilesAndDiscription.removeAllObjects()

            if snapshot.value is NSDictionary {
            let messageData = snapshot.value as! NSDictionary
                
                self.arrOfTilesAndDiscription = NSMutableArray.init(array: messageData.allValues as NSArray)
            
//                if self.arrOfTilesAndDiscription.contains(messageData){
//                }
//                else{
//                    self.arrOfTilesAndDiscription.add(messageData)
//
//                }
//
            self.stopAnimating()
            self.tableView.reloadData()
            }
        })
    }
    func getFavBaseDatabaseChanged() {
        self.startAnimating(CGSize(width: 30, height:30), message: "Loading..", type: NVActivityIndicatorType.ballClipRotateMultiple)
        
        arrOfTilesAndDiscription.removeAllObjects()
        databaseRef.child("favorite").child(UserDefaults.standard.value(forKey: "UID") as! String).observe( .childChanged, with: { (snapshot) in
            print(snapshot)
            
            if snapshot.value is NSDictionary {
                let messageData = snapshot.value as! NSDictionary
                
                if self.arrOfTilesAndDiscription.contains(messageData){
                }
                else{
                    self.arrOfTilesAndDiscription.add(messageData)
                    
                }
                
                self.stopAnimating()
                self.tableView.reloadData()
            }
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
    
            return arrOfTilesAndDiscription.count
     
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TailsAndDetailsTableVCell
            
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
        
            print(dictOfData)
            return cell
            
        
    }
    
    // MARK: -  UITableViewDelegate Mehtod
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
        
       
        // To hide Key
    }
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
    @IBAction func Back(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
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
