//
//  AvailabilityTableViewCell.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/03/01.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class AvailabilityTableViewCell: UITableViewCell {

    // ツモリストのアイコン画像
    @IBOutlet weak var userImageView: UIImageView!
    // ツモリストの名前
    @IBOutlet weak var usernameLabel: UILabel!
    // 予定入退室時刻
    @IBOutlet weak var arrivingAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
