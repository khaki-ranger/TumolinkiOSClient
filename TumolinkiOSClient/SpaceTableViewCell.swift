//
//  SpaceTableViewCell.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/25.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class SpaceTableViewCell: UITableViewCell {
    
    // スペース画像
    @IBOutlet weak var spaceImageView: UIImageView!
    // スペース名
    @IBOutlet weak var spaceNameLabel: UILabel!
    // 今日のツモリストの人数
    @IBOutlet weak var availabilitiesNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        // セルの再利用時に元々入っている情報をクリア
        spaceImageView.image = nil
    }

}
