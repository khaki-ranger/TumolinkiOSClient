//
//  SpaceViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/28.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class SpaceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // スペースの情報
    var space: SpaceData?
    var spaceImage: UIImage?
    // AvailabilityData型の値が入った配列
    // ツモリストを表現
    var availabilityArray: [AvailabilityData]?
    
    // MARK: Properties
    @IBOutlet weak var spaceImageView: UIImageView!
    
    // ツモリストを表示するテーブル
    @IBOutlet weak var availabilityTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up views if editing an existing Meal.
        if let space = space {
            navigationItem.title = space.spaceName
            spaceImageView.image = spaceImage
            if let availabilities = space.availabilities {
                availabilityArray = availabilities
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ツモリストの配列の長さを返却する
        guard let availabilitiesCount = availabilityArray?.count else {
            return 0
        }
        
        return availabilitiesCount
    }
    
    // テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Storyboardで指定したavailabilityCell識別子を利用して再利用可能なセルを返却する
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "availabilityCell", for: indexPath) as? AvailabilityTableViewCell else {
            return UITableViewCell()
        }
        
        // 行番号に合ったツモリストのユーザー名を取得
        if let username = availabilityArray?[indexPath.row].username {
            cell.usernameLabel.text = username
        }
        
        // 行番号に合ったツモリストの予定入退室時刻を取得
        if let arrivingAt = availabilityArray?[indexPath.row].arrivingAt {
            cell.arrivingAtLabel.text = arrivingAt
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
