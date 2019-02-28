//
//  AvailabilityData.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/28.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import Foundation

class Availability {
    // ユーザー名
    var username: String?
    
    // ユーザーアイコン画像のURL
    var userPhotoUrl: String?
    
    // 入室予定時刻
    var arrivingAt: String?
    
    // 退出予定時刻
    var leavingAt: String?
}
