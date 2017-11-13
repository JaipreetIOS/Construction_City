//
//  HomeTableVCell.swift
//  ConstructionCity
//
//  Created by Apple on 17/07/17.
//  Copyright © 2017 ZetrixWeb. All rights reserved.
//

import UIKit

class HomeTableVCell: UITableViewCell {

    @IBOutlet weak var imgTile: UIImageView!
    @IBOutlet weak var lblSerialNo: UILabel!
    @IBOutlet weak var lblTileTitle: UILabel!
    @IBOutlet weak var lblHeightWidth: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblTileFinish: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
