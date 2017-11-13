
//
//  Helper.swift
//  Queue Music
//
//  Created by Ketan Raval on 14/10/15.
//  Copyright © 2015 zetrixweb. All rights reserved.
//




import UIKit


var arrFiles = NSMutableArray()
var arrImg = NSMutableArray()

@objc class Helper : NSObject{
    
//    static let sharedInstance = Helper()
//    required init () {
//    }
//    
    class func isSimulator() -> Bool{
        
        #if (arch(i386) || arch(x86_64))
            return true
        #else
            return false
        #endif
    }
    
    class func cropImageToSquare(image: UIImage) -> UIImage? {
        var imageHeight = image.size.height
        var imageWidth = image.size.width
        
        if imageHeight > imageWidth {
            imageHeight = imageWidth
        }
        else {
            imageWidth = imageHeight
        }
        
        let size = CGSize(width: imageWidth, height: imageHeight)
        
        let refWidth : CGFloat = CGFloat(image.cgImage!.width)
        let refHeight : CGFloat = CGFloat(image.cgImage!.height)
        
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
        if let imageRef = image.cgImage!.cropping(to: cropRect) {
            return UIImage(cgImage: imageRef, scale: 0, orientation: image.imageOrientation)
        }
        
        return nil
    }
    class func setLabelFont(lblName: UILabel, fontSize: CGFloat){
        lblName.font = UIFont(name: "Helvetica Neue", size: fontSize)
    }
    class func setLabelFontWithBold(lblName: UILabel, fontSize: CGFloat){
        lblName.font = UIFont(name: "Helvetica Neue", size: fontSize)
        lblName.font = UIFont.boldSystemFont(ofSize: fontSize)

    }
    
    class func scaleUIImageToSize( image: UIImage, size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    class func gotoTopInScrollview(scrollview: UIScrollView) {
        
        scrollview.contentOffset = CGPoint(x: 0, y: 0)
    }
    class func imageWithSize(size:CGSize , image:UIImage) -> UIImage{
        var scaledImageRect = CGRect.zero;
        
        let aspectWidth:CGFloat = size.width / image.size.width;
        let aspectHeight:CGFloat = size.height / image.size.height;
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight);
        
        scaledImageRect.size.width = image.size.width * aspectRatio;
        scaledImageRect.size.height = image.size.height * aspectRatio;
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        
        image.draw(in: scaledImageRect);
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage!;
    }
    class func getFilename(str : String) -> (String /*, ext: String*/)? {
        let l = str.components(separatedBy: "/")
        let file = l.last?.components(separatedBy:".")[0]
        let ext = l.last?.components(separatedBy:".")[1]
        return (file!/*, ext!*/)
    
    }
    /*===DOCUEMT DIRECTORY HELPER====*/
   
    class func getDirectoryFiles(directoryName : String!, subSirectoryName : String! , extensionName : String!) -> NSArray {
         Helper.removeDirectory(directoryName: "/" + directoryName + "/.DS_Store")
        var directoryUrls = NSArray()
        let documentsUrl =  NSURL( fileURLWithPath: Helper.getDocumentDirectoryPath() + "/" + directoryName + "/" + subSirectoryName )
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            //print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        do {
             directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl as URL, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions()) as NSArray
            //print(directoryUrls)
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
    
    class func getImagePath(directoryName : String!, subDirectoryName: String, imageName: String) -> String{
        let path =  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return path + "/" + directoryName + "/" + subDirectoryName + "/" + imageName + ".png"
    }
    
    class func createDirectory(directoryName : String!) {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let dataPath = documentsDirectory.appendingFormat("/", directoryName)
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func createReportSubDirectory(directoryName : String!,subDirectoryName : String!){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let dataPath = documentsDirectory.appendingFormat("/", directoryName) + "/" + subDirectoryName
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func removeDirectory(directoryName : String!){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let dataPath = documentsDirectory.appendingFormat("/", directoryName)
        
        do {
            try FileManager.default.removeItem(atPath: dataPath)
        } catch let error as NSError {
            print(error.localizedDescription);
        }

    }
    /*class func saveImageInDirectory(img : UIImage, directoryName : String ,subDirectoryName : String!) -> String{
            Helper.removeDirectory(directoryName: "/" + directoryName + "/" + subDirectoryName + "/.DS_Store")
            var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
            let select = "SELECT * from images where p_id = \(p_id) AND u_id = \(u_id) AND r_id =\(r_id)"
            let arrCount = String (db.SelectAllFromTable(select).count + 1)
        
        
            //let total = String(Helper.getDirectoryFiles(directoryName, extensionName: ".png").count)
            let appdendPath : String = "/" + p_id + "/" + subDirectoryName +  "/" + arrCount  + ".png"
            path = (path as NSString).appendingPathComponent(appdendPath)
            let result = img.writeAtPath(path: path)
            return String(arrCount)

    }*/
    
    class func saveImageAtPath(img : UIImage, path : String ){
        var path = path
        path = path.replacingOccurrences(of:"file://", with: "")
        let result = img.writeAtPath(path: path)
        
    }
    
    class func removeImageFromDirectory(imgName : String, directoryName : String , subDirectoryName : String){
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: String = paths[0] as String
        let dataPath = documentsDirectory.appendingFormat("/", documentsDirectory)
       //print(dataPath + "/" + imgName + ".png")
        do {
            try FileManager.default.removeItem(atPath: dataPath + "/" +  subDirectoryName + "/" + imgName + ".png")
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    class func loadImageFromPath(path : String) -> UIImage? {
        let image = UIImage(contentsOfFile: String(path))
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
        let size = str.boundingRect(with: CGSize(width: maxWidth, height: 1000), options:(NSStringDrawingOptions.usesLineFragmentOrigin), context:nil).size
        return size
    }
    
    
    class func imageFromText(text:NSString, font:UIFont, maxWidth:CGFloat, color:UIColor) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = .center // potentially this can be an input param too, but i guess in most use cases we want center align
        
        let attributedString = NSAttributedString(string: text as String, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName:paragraph])
        
        let size = sizeOfAttributeString(str: attributedString, maxWidth: maxWidth)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
   class func isValidEmail(testStr:String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: testStr)
    }
    
    
//    class func getLimitWithZero(limit : Int) -> [AnyObject] {
//        var pred: dispatch_once_t = dispatch_once_t()
//        var sortingList: [AnyObject]? = nil
//        dispatch_once(&pred, {
//            for(var i = 0; i <= limit ; i++){
//                sortingList?.append(i)
//            }
//            
//        })
//        return sortingList!
//    }
    
//    class func getLimitWithoutZero(limit : Int) -> [AnyObject] {
//        var pred: dispatch_once_t = dispatch_once_t()
//        var sortingList: [AnyObject]? = nil
//        dispatch_once(&pred, {
//            for(var i = 1; i <= limit ; i++){
//                sortingList?.append(i)
//            }
//            
//        })
//        return sortingList!
//    }
//    
//    class func getLimitOption() -> [AnyObject] {
//        var pred: dispatch_once_t = dispatch_once_t()
//        var sortingList: [AnyObject]? = nil
//        dispatch_once(&pred, {
//        sortingList = ["1", "2", "3", "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22" , "23" , "24" , "25" , "26" , "27" , "28" , "29" , "30" , "31" , "32" , "33" ,"34" , "35" , "36" , "37" , "38" , "39" , "40" ,"41" , "42" , "43" ,"44" , "45" , "46" , "47" , "48" , "49" , "50" ,]
//            
//        })
//        return sortingList!
//    }
//    
//    class func getLevelOption() -> NSArray {
//        var pred: dispatch_once_t = dispatch_once_t()
//        var sortingList: NSArray? = nil
//        dispatch_once(&pred, {
//            sortingList = ["1", "2", "3", "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22" , "23" , "24" , "25" , "26" , "27" , "28" , "29" , "30" , "31" , "32" , "33" ,"34" , "35" , "36" , "37" , "38" , "39" , "40" ,"41" , "42" , "43" ,"44" , "45" , "46" , "47" , "48" , "49" , "50" ,]
//            
//        })
//        return sortingList! as NSArray
//    }
    
//    class func getLimitOptionWithZero() -> [AnyObject] {
//        var pred: dispatch_once_t = dispatch_once_t()
//        var sortingList: [AnyObject]? = nil
//        dispatch_once(&pred, {        sortingList = [ "0" , "1", "2", "3", "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22" , "23" , "24" , "25" , "26" , "27" , "28" , "29" , "30" , "31" , "32" , "33" ,"34" , "35" , "36" , "37" , "38" , "39" , "40" ,"41" , "42" , "43" ,"44" , "45" , "46" , "47" , "48" , "49" , "50" ,]
//            
//        })
//        return sortingList!
//    }
    
    class func globalAlert(msg: String) {
        let alertView:UIAlertView = UIAlertView()
        alertView.title = "Report Generator"
        alertView.message = msg
        alertView.delegate = self
        alertView.addButton(withTitle: "OK")
        
        alertView.show()

    }
    func mach_task_self() -> task_t {
        return mach_task_self_
    }
    
    func reportMemory() -> Float? {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kerr = withUnsafeMutablePointer(to: &info) { infoPtr in
            return infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { (machPtr: UnsafeMutablePointer<integer_t>) in
                return task_info(
                    mach_task_self(),
                    task_flavor_t(MACH_TASK_BASIC_INFO),
                    machPtr,
                    &count
                )
            }
        }
        guard kerr == KERN_SUCCESS else {
            return nil
        }  
        return Float(info.resident_size) / (1024 * 1024)   
    }  

    
//    class func reportMemory() {
//        let name = mach_task_self_
//        let flavor = task_flavor_t(TASK_BASIC_INFO)
//        let basicInfo = task_basic_info()
//        var size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout.size(ofValue: basicInfo))
//        let pointerOfBasicInfo = UnsafeMutablePointer<task_basic_info>.allocate(capacity: 1)
//        
//        let kerr: kern_return_t = task_info(name, flavor, UnsafeMutablePointer(pointerOfBasicInfo), &size)
//        let info = pointerOfBasicInfo.move()
//        pointerOfBasicInfo.deallocate(capacity: 1)
//        
//        if kerr == KERN_SUCCESS {
//            print("Memory in use (in Mbytes): \(info.resident_size/1024/1024)")
//        } else {
//            print("error with task info(): \(mach_error_string(kerr))")
//        }
//    }

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
        notification.alertBody = "Queue completed"
        //notification.alertAction = "be awesome!"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["CustomField1": "w00t"]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    /*===VIEW ANIMATIONS====*/
   class func viewSlideInFromRightToLeft(views: UIView) {
    
        views.isHidden = false
        var transition: CATransition? = nil
        transition = CATransition()
        transition!.duration = 0.5
        transition!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition!.type = kCATransitionPush
        transition!.subtype = kCATransitionFromRight
        views.layer.add(transition!, forKey: nil)
        views.isHidden = true
    }
   class func viewSlideInFromLeftToRight(views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition()
        transition!.duration = 0.5
        transition!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition!.type = kCATransitionPush
        transition!.subtype = kCATransitionFromLeft
        views.layer.add(transition!, forKey: nil)
    }
   class func viewSlideInFromTopToBottom(views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition()
        transition!.duration = 0.5
        transition!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition!.type = kCATransitionPush
        transition!.subtype = kCATransitionFromTop
        views.layer.add(transition!, forKey: nil)
    }
    class func viewSlideInFromBottomToTop(views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition()
        transition!.duration = 0.5
        transition!.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition!.type = kCATransitionPush
        transition!.subtype = kCATransitionFromBottom
        views.layer.add(transition!, forKey: nil)
    }
    
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }

    class func imageForImageURLString(imageURLString: String, completion: (_ image: UIImage?, _ success: Bool) -> Void) {
        guard let url = NSURL(string: imageURLString),
            let data = NSData(contentsOf: url as URL),
            let image = UIImage(data: data as Data)
            else {
                completion(nil, false);
                return
        }
        
        completion(image, true)
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




