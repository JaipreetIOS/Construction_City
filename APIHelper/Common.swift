//
//  Common.swift
//  Vidyalaya
//
//  Created by Janak Thakkar on 05/05/16.
//  Copyright © 2016 zetrixweb. All rights reserved.
//

import Foundation

let BaseURL         = "http://www.shareapaint.com/api/"
let BaseUrlForPaint = "http://storage.shareapaint.com/paints/"

struct GlobalConstants {

    //Common userls 
    static let KProjectName          = "Shareapaint"
    static let KInternetFailure      = "Something went wrong,Please try Again"
    static let KInternetSlow         = "Check your internet connection"
    
    static let KSignUp              = BaseURL + "register"
    static let KLogin               = BaseURL + "login"
    static let KForgetPassword      = BaseURL + "forgot"
    static let kPaints              = BaseURL + "paints"
    static let KPaint               = BaseURL + "paint"
    static let KPainters            = BaseURL + "painters"
    static let KNotifications       = BaseURL + "notifications"
    static let KLogout              = BaseURL + "logout"
    static let KLike                = BaseURL + "like"
    static let KFollow              = BaseURL + "follow"
}

