//
//  CustomView.swift
//  Tribe Explorer
//
//  Created by Apple on 17/08/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

var color: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
    didSet {
//        layer.borderColor = color.cgColor
    }
}
var deepColor: UIColor = .white {
    didSet {
//        layer.borderColor = deepColor.cgColor
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
}
func configure() {
//            backgroundColor = UIColor.white
    layer.borderColor  = UIColor.clear.cgColor
    //        contentEdgeInsets  = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
   
    
   
    layer.cornerRadius = 6
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: -1, height: 3)
    layer.shadowRadius = 3
    layer.shadowOpacity = 0.2


    
}
}
