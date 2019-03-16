//
//  SpaceTableViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/25.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class SpaceTableViewController: UITableViewController {
    
    // スペース一つ一つに関するデータを管理するための配列
    var spaceDataArray = [SpaceData]()
    
    // 再利用する画像データを管理する
    var imageCash = NSCache<AnyObject, UIImage>()
    
    // リクエストのベースURL
    var baseUrl: String = "https://www.tumolink.com"
    
    // APIのパス
    var apiPath: String = "/api/iosclient"
    
    // FacebookLogin
    // ユーザー情報を表示する
    func returnUserDate() {
        let graphPath = "me"
        let parameters = ["fields": "id, name, email"]
        let graphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: parameters)
        
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let result = result as? [String: Any] else {
                    return
                }
                
                // ログインユーザーの情報をデバッグ表示
                print(result)
            }
        })
        connection.start()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保持しているデータをいったん削除
        spaceDataArray.removeAll()
        
        // リクエストURLを作成する
        let requestUrl = baseUrl + apiPath
        
        // APIをリクエストする
        request(requestUrl: requestUrl)
        
        // ログインユーザーの情報を表示する
        returnUserDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // レスポンス内容をパースしてリストを作成する
    func parseData(jsonData: [Any]) {
        
        for resultSet in jsonData {
            // スペース取得
            // String:Any型が入った辞書型で取得できるかどうか検証
            guard let result = resultSet as? [String: Any] else {
                // 取得に失敗
                // 次のfor文の処理を行う
                continue
            }
            
            // スペースのデータ格納オブジェクトを作成
            let spaceData = SpaceData()
            
            // spaceNameをString型で取得
            if let spaceName = result["name"] as? String {
                spaceData.spaceName = spaceName
            }
            
            // imgPathをString型で取得
            if let imgPath = result["imgPath"] as? String {
                // 画像のフルパスを作成
                let spaceImageUrl = baseUrl + imgPath
                spaceData.spaceImageUrl = spaceImageUrl
            }
            
            // ツモリストの情報を取得
            if let availabilities = result["availabilities"] as? [Any] {
                
                // ツモリスト一つ一つに関するデータを管理するための配列
                // ツモリストがゼロでも空の配列を作る
                var availabilityDataArray = [AvailabilityData]()
                
                for availabilitySet in availabilities {
                    guard let availability = availabilitySet as? [String: Any] else {
                        // 次のfor文の処理を行う
                        continue
                    }
                
                    // ツモリストのデータ格納オブジェクトを作成
                    let availabilityData = AvailabilityData()
                    
                    // ユーザー名をString型で取得
                    if let username = availability["username"] as? String {
                        availabilityData.username = username
                    }
                    
                    // ニックネームをString型で取得
                    if let nickname = availability["nickname"] as? String {
                        availabilityData.nickname = nickname
                    }
                    
                    // ユーザーアイコン画像をString型で取得
                    if let userPhotoUrl = availability["photoUrl"] as? String {
                        availabilityData.userPhotoUrl = userPhotoUrl
                    }
                    
                    // 入室予定時刻をString型で取得
                    if let arrivingAt = availability["arrivingAt"] as? String {
                        availabilityData.arrivingAt = arrivingAt
                    }
                    
                    // 退室予定時刻をString型で取得
                    if let leavingAt = availability["leavingAt"] as? String {
                        availabilityData.leavingAt = leavingAt
                    }
                    
                    // ツモリストのリストに追加
                    availabilityDataArray.append(availabilityData)
                }
                
                // AvailabilityData型が入った配列を格納
                // ツモリストがゼロでも空の配列をspaceDataに格納
                spaceData.availabilities = availabilityDataArray
            }
            
            // スペースのリストに追加
            self.spaceDataArray.append(spaceData)
        }
    }
    
    // リクエストを行う
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // URL生成失敗
            return
        }
        
        // リクエスト生成
        let request = URLRequest(url: url)
        
        // APIにリクエストを送る
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data:Data?, response:URLResponse?, error:Error?) in
            // 通信完了後の処理
            // エラーチェック
            guard error == nil else {
                // エラー表示
                let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // UIに関する処理はメインスレッド上で行う
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            // JSONで返却されたデータをパースして格納する
            guard let data = data else {
                // データなし
                print("データなし")
                return
            }
            
            // JSON形式への変換処理
            guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [Any] else {
                // 変換失敗
                print("変換失敗")
                return
            }
            
            // データを解析
            self.parseData(jsonData: jsonData)
            
            // テーブルの描画処理
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // 通信開始
        task.resume()
    }

    // MARK: - Table view data source

    // テーブルのセクション数を設定
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // セクション内のスペースの数を取得して行の数に設定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spaceDataArray.count
    }

    // テーブルセルの設定処理
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "spaceCell", for: indexPath) as? SpaceTableViewCell else {
            return UITableViewCell()
        }

        let spaceData = spaceDataArray[indexPath.row]
        
        // スペース名の設定
        cell.spaceNameLabel.text = spaceData.spaceName
        
        // ツモリストの数を設定
        let availabilitiesCount = spaceData.availabilities?.count ?? 0
        cell.availabilitiesCountLabel.text = String(availabilitiesCount)
        
        // 画像の設定処理
        // すでにセルに設定されている画像と同じかどうかチェックする
        // 画像がまだ設定されていない場合に処理を行う
        guard let spaceImageUrl = spaceData.spaceImageUrl else {
            // 画像なし
            return cell
        }
        
        // キャッシュの画像を取り出す
        if let cacheImage = imageCash.object(forKey: spaceImageUrl as AnyObject) {
            // キャッシュ画像の設定
            cell.spaceImageView.image = cacheImage
            return cell
        }
        
        // キャッシュの画像がないためダウンロードする
        guard let url = URL(string: spaceImageUrl) else {
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
            self.imageCash.setObject(image, forKey: spaceImageUrl as AnyObject)
            
            // 画像はメインスレッド上で設定する
            DispatchQueue.main.async {
                cell.spaceImageView.image = image
            }
        }
        
        // 画像の読み込み処理開始
        task.resume()
        
        return cell
    }
    
    // MARK: - Navigation
    // セルをタップして次の画面に遷移する前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? SpaceTableViewCell {
            if let spaceViewController = segue.destination as? SpaceViewController {
                
                guard let indexPath = tableView.indexPath(for: cell) else {
                    fatalError("The selected cell is not begin displayed by the table")
                }
                
                let selectedSpace = spaceDataArray[indexPath.row]
                
                // スペースの情報を登録
                spaceViewController.space = selectedSpace
                
                // スペースの画像を登録
                spaceViewController.spaceImage = cell.spaceImageView.image
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
