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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // テーブルの行数を返却する
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ツモリストの配列の長さを返却する
        // return (self.space?.availabilities?.count)!
        
        return 3
    }
    
    // テーブルの行ごとのセルを返却する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Storyboardで指定したavailabilityCell識別子を利用して再利用可能なセルを返却する
        let cell = tableView.dequeueReusableCell(withIdentifier: "availabilityCell", for: indexPath)
        
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
