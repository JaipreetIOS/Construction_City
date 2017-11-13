

import Foundation
import UIKit
//import Alamofire
//import PKHUD

var arrGlobal = NSArray()
var dictGlobal = NSDictionary()
var strGlobal = NSString()

class APIHelper {

    //Singleton calls , memory allocated once
     static let sharedInstance = APIHelper()

    func getData(parameter:[String:AnyObject],completion:@escaping (_ success:Bool)->Void){
        
        PKHUD.sharedHUD.contentView = PKHUDTextView(text: "Loading...")
        PKHUD.sharedHUD.show()
        
        request(GlobalConstants.KSignUp,method:.post,parameters:parameter, headers:["Content-Type":"application/x-www-form-urlencoded"]) .validate().responseJSON
            {
                response in switch response.result {
                case .success(let JSON):
                    PKHUD.sharedHUD.hide()
                     print("Success with JSON: \(JSON)")
                     completion(true)
                case .failure(let error):
                     PKHUD.sharedHUD.hide()
                    completion(false)
                    print(error)
                    break
                }
        }
    }
 
}
