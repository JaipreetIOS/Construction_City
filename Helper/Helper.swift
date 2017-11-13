//
//  Helper.swift
//  Queue Music
//
//  Created by Ketan Raval on 14/10/15.
//  Copyright © 2015 zetrixweb. All rights reserved.
//




import UIKit
import AVFoundation

var arrFiles = NSMutableArray()
var arrImg = NSMutableArray()



class Helper {
    
    static let sharedInstance = Helper()
    required init () {
    }
    
//    class func convertImageToBase64(image: UIImage) -> String {
//        
//        var imageData = UIImagePNGRepresentation(image)
//        let base64String = imageData!.base64EncodedStringWithOptions(.allZeros)
//        
//        return base64String
//        
//    }
    
    class func isNull(someObject: AnyObject?) -> Bool {
        guard let someObject = someObject else {
            return true
        }
        
        return (someObject is NSNull)
    }

       
   class func isNotNSNull(object:AnyObject) -> Bool {
        return object.classForCoder != NSNull.classForCoder()
    }
    
   
    
    class func stringByRemovingSpaceFromBothEnd(str : String) ->String {
        return str.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    class func convertBase64ToImage(base64String: String) -> UIImage {
        let decodedData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0) )
        let decodedimage = UIImage(data: decodedData! as Data)
        return decodedimage!
    }
    
    class func GetDeviceWidth() ->CGFloat{
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        return width
        
    }
    class func GetDeviceHeight() ->CGFloat{
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        return height
    }
    
    class func getFilename(str : String) -> (String /*, ext: String*/)? {
        let l = str.components(separatedBy: "/")
        
        let file = l.last?.components(separatedBy: ".")[0]
        let ext = l.last?.components(separatedBy: ".")[1]
        return (file!/*, ext!*/)
    
    }
    /*===DOCUEMT DIRECTORY HELPER====*/
   
    class func getDirectoryFiles(directoryName : String! , extensionName : String!) -> NSArray {
         Helper.removeDirectory(directoryName: "/" + directoryName + "/.DS_Store")
        var directoryUrls = NSArray()
        let documentsUrl =  NSURL( fileURLWithPath: Helper.getDocumentDirectoryPath() + "/" + directoryName )
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
             directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions()) as NSArray
            print(directoryUrls)
            //let typeFilter = directoryUrls.filter{ $0.pathExtension == extensionName }.map{ $0.lastPathComponent }
            //print("typeFilter:\n" + typeFilter.description)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        arrFiles=directoryUrls.mutableCopy() as! NSMutableArray
        
        return arrFiles 
    
    }
    
    class func getDocumentDirectoryPath() -> String{
        let path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return path
    }
    
    class func getSubDirectoryPath(directoryName : String!) -> String{
        let path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return path + "/" + directoryName
    }
    
    class func createDirectory(directoryName : String!) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPath = documentsDirectory
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath as! String, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func removeDirectory(directoryName : String!){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPath = documentsDirectory
        
        do {
            try FileManager.default.removeItem(atPath: dataPath as! String)
        } catch let error as NSError {
            print(error.localizedDescription);
        }

    }
    
    
    class func saveImageAtPath(img : UIImage, path : String ){
        var path = path
        path = path.replacingOccurrences(of: "file://", with: "")
        let result = img.writeAtPath(path: path)
        
    }
    
    class func removeImageFromDirectory(imgName : String, directoryName : String ){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPath = documentsDirectory
       print((dataPath as! String) + "/" + imgName + ".png")
        do {
            try FileManager.default.removeItem(atPath: (dataPath as! String) + "/" + imgName + ".png")
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func loadImageFromPath(path : NSURL) -> UIImage? {
        let image = UIImage(contentsOfFile: String(describing: path))
        if image == nil {
            print("missing image at: \(path)")
        }
        return image
        
    }
    
    class func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
   class func firstLettersOfString(string: String!) -> String {
        let arrayOfWords = string.components(separatedBy: " ")
        let firstLetters: [String] = arrayOfWords.map {
            return String($0.characters.first!)
        }
        return firstLetters.joined(separator: "").uppercased()
    }
    
    
    class func sizeOfAttributeString(str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRect(with:CGSize(width: maxWidth, height: 1000), options:(NSStringDrawingOptions.usesLineFragmentOrigin), context:nil).size
        return size
    }
    
    
    class func imageFromText(text:NSString, font:UIFont, maxWidth:CGFloat, color:UIColor) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = .center // potentially this can be an input param too, but i guess in most use cases we want center align
        
        let attributedString = NSAttributedString(string: text as String, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName:paragraph])
        
        let size = sizeOfAttributeString(str: attributedString, maxWidth: maxWidth)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x:0, y:0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
   class func isValidEmail(testStr:String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: testStr)
    }
 
    class func globalAlert(msg: String) {
        
        let alertView:UIAlertView = UIAlertView()
        alertView.title = "SharePaint"
        alertView.message = msg
        alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        
        alertView.show()

    }
    
    class func reportMemory() {
        let name = mach_task_self_
        let flavor = task_flavor_t(TASK_BASIC_INFO)
        let basicInfo = task_basic_info()
        var size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout.size(ofValue: basicInfo))
        let pointerOfBasicInfo = UnsafeMutablePointer<task_basic_info>.allocate(capacity: 1)
        
        //let kerr: kern_return_t = task_info(name, flavor, UnsafeMutablePointer(pointerOfBasicInfo), &size)
        let info = pointerOfBasicInfo.move()
        pointerOfBasicInfo.deallocate(capacity: 1)
        

    }

    class func isConnectedToNetwork() -> Bool {
        
        var status:Bool = false
        
        let url = NSURL(string: "https://google.com")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response:URLResponse?
        
        do {
            let _ = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response) as NSData?
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        return status
    }
    
    func fadeIN(btn : UIButton){
        UIView.animate(withDuration: 0.2, delay: 0.0,
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                btn.alpha = 0
            },
            completion: ({finished in
                if (finished) {
                    UIView.animate(withDuration: 0.2, animations: {
                        btn.alpha = 1.0
                    })
                }
            }))
    }
    
    class func validateUrl (stringURL : NSString) -> Bool {
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        let urlTest = NSPredicate.withSubstitutionVariables(predicate)
        return predicate.evaluate(with: stringURL)
    }
    
    class func timeStamp()->String{
        return "\(NSDate().timeIntervalSince1970 * 1000).png"
    }
    
    class func scheduleLocal() {
        
        let notification = UILocalNotification()
        notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
        notification.alertBody = "Have you fuledup"
        //notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    class func getCurrentDate() -> String {
        let today: NSDate = NSDate()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy HH/mm"
        return dateFormat.string(from: today as Date)
    }
    
    class func getCurrentDateNew() -> String {
        let today: NSDate = NSDate()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "MM/dd/YYYY"
        return dateFormat.string(from: today as Date)
    }
    
    class func getDateFromString(strDate : String) -> NSDate  {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH/mm"
        return formatter.date(from: strDate)! as NSDate
    }
    
    class func getDateFromStringNew(strDate : String) -> NSDate  {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.date(from: strDate)! as NSDate
    }
    
    class func applyPlainShadow(view1 : UIView) {
        let layer = view1.layer
        
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowOpacity = 0.8
    
    }

    class func isBlank (optionalString :String?) -> Bool {
        if let string = optionalString {
            return string.isEmpty
        } else {
            return true
        }
    }
    
    class func screenLockSetting(setting : Bool){
        UIApplication.shared.isIdleTimerDisabled = setting
    }
    class func saveImageToGallery(image : UIImage){
       UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    class func getIndexOfObject (arr : NSArray ,value : AnyObject ) -> (Int) {
        
        let num: Int  = value as! Int
        
        //let num: Int = Int(value as! NSNumber)
        let Index: Int = arr.index(of: num)
        return Index
    }
    class func onlyNumberForTextField(textField:UITextField,targetTextField:UITextField,string:String) -> Bool{
        
        if (textField == targetTextField){
            
            let newCharacters = NSCharacterSet(charactersIn: string)
            let boolIsNumber = NSCharacterSet.decimalDigits.isSuperset(of: newCharacters as CharacterSet)
            if boolIsNumber == true {
                return true
            }
            else {
                return false
            }
        }
        return true
    }
    
    class func getAutoNextTextField(textField:UITextField,targetTextField:UITextField,range:NSRange,string:String) -> Bool{
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        let len = textField.text?.characters.count
        
        if (len == 0){
            textField.text = newString as String
            textField.resignFirstResponder()
            targetTextField.becomeFirstResponder()
        }
        return true
        
    }

    class func getThumnilFromVideo(){
        do {
            let asset = AVURLAsset(url: NSURL(fileURLWithPath: "/that/long/path") as URL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            let imageView = UIImageView(image: uiImage)
        // lay out this image view, or if it already exists, set its image property to uiImage
        } catch let error as NSError {
    print("Error generating thumbnail: \(error)")
        }
    }
    
    class func getPreviewImageForVideoAtURL(videoURL: NSURL, atInterval: Int) -> UIImage? {
        print("Taking pic at \(atInterval) second")
        let asset = AVAsset(url: videoURL as URL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(Float64(atInterval), 100)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let frameImg = UIImage(cgImage: img)
            return frameImg
        } catch {
            /* error handling here */
        }
        return nil
    }
}


import Foundation
import UIKit
import ImageIO
import MobileCoreServices

extension UIImage {
    func writeAtPath(path:String) -> Bool {
        
        let result = CGImageWriteToFile(image: self.cgImage!, filePath: path)
        return result
    }
    
    private func CGImageWriteToFile(image:CGImage, filePath:String) -> Bool {
        let imageURL:CFURL = NSURL(fileURLWithPath: filePath)
        var destination:CGImageDestination? = nil
        
        let ext = (filePath as NSString).pathExtension.uppercased()
        
        if ext == "JPG" || ext == "JPEG" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeJPEG, 1, nil)
        } else if ext == "PNG" || ext == "PNGF" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypePNG, 1, nil)
        } else if ext == "TIFF" || ext == "TIF" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeTIFF, 1, nil)
        } else if ext == "GIFF" || ext == "GIF" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeGIF, 1, nil)
        } else if ext == "PICT" || ext == "PIC" || ext == "PCT" || ext == "X-PICT" || ext == "X-MACPICT" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypePICT, 1, nil)
        } else if ext == "JP2" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeJPEG2000, 1, nil)
        } else  if ext == "QTIF" || ext == "QIF" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeQuickTimeImage, 1, nil)
        } else  if ext == "ICNS" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeAppleICNS, 1, nil)
        } else  if ext == "BMPF" || ext == "BMP" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeBMP, 1, nil)
        } else  if ext == "ICO" {
            destination = CGImageDestinationCreateWithURL(imageURL, kUTTypeICO, 1, nil)
        } else {
            fatalError("Did not find any matching path extension to store the image")
        }
        
        if (destination == nil) {
            fatalError("Did not find any matching path extension to store the image")
            return false
        } else {
            CGImageDestinationAddImage(destination!, image, nil)
            
            if CGImageDestinationFinalize(destination!) {
                return false
            }
            return true
        }
    }
}




