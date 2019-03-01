//
//  AvailabilityTableViewCell.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/03/01.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class AvailabilityTableViewCell: UITableViewCell {

    // ツモリストの名前
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
