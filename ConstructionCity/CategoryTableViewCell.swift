//
//  CategoryTableViewCell.swift
//  Construction
//
//  Created by Apple on 24/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var nameTxt: AppLabel!
    @IBOutlet weak var name: CustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
