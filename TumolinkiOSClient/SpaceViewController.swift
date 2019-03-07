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
    
    // 再利用する画像データを管理する
    var imageCash = NSCache<AnyObject, UIImage>()
    
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
        
        // 行番号に合ったツモリストのデータを定数に格納
        let availabilityData = availabilityArray?[indexPath.row]
        
        // ユーザー名を設定
        // 取得できていればニックネームを設定
        if let username = availabilityData?.username {
            if let nickname = availabilityData?.nickname {
                cell.usernameLabel.text = nickname
            } else {
                cell.usernameLabel.text = username
            }
        }
        
        // 入退室予定時刻を設定する変数
        var arrivingAndLeavingString = ""
        
        // 入室予定時刻を取得
        if let arrivingAt = availabilityData?.arrivingAt {
            arrivingAndLeavingString = arrivingAt
        }
        
        // 退室予定時刻を取得
        if let leavingAt = availabilityData?.leavingAt {
            arrivingAndLeavingString += leavingAt
        }
        
        // 入退室予定時刻を設定
        cell.arrivingAtLabel.text = arrivingAndLeavingString
        
        // ユーザーのアイコン画像のURLを取得
        guard let userImageUrl = availabilityData?.userPhotoUrl else {
            // 画像なし
            return cell
        }
        
        // キャッシュの画像があれば取得する
        if let cacheImage = imageCash.object(forKey: userImageUrl as AnyObject) {
            // キャッシュ画像の設定
            cell.userImageView.image = cacheImage
            return cell
        }
        
        // キャッシュの画像がないためダウンロードする
        guard let url = URL(string: userImageUrl) else {
            // urlが生成できなかった
            return cell
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                // エラーあり
                return
            }
            
            guard let data = data else {
                // データがない
                return
            }
            
            guard let image = UIImage(data: data) else {
                // imageが生成できなかった
                return
            }
            
            // ダウンロードした画像をキャッシュに登録しておく
            self.imageCash.setObject(image, forKey: userImageUrl as AnyObject)
            
            // 画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.userImageView.image = image
            }
        }
        
        // 画像の読み込み処理開始
        task.resume()
        
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
