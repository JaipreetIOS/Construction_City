//
//  TailsAndDetailsTableVCell.swift
//  ConstructionCity
//
//  Created by Pratik Joshi on 22/07/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit

class TailsAndDetailsTableVCell: UITableViewCell {

    @IBOutlet var imgTile: UIImageView!
    @IBOutlet var lblItemSerialNo: UILabel!
    @IBOutlet var lblTileType: UILabel!
    @IBOutlet var lblItemWidthHeight: UILabel!
    @IBOutlet var lblItemColor: UILabel!
    @IBOutlet var lblItemFinish: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
