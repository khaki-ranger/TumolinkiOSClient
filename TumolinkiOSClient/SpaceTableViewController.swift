//
//  SpaceTableViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/25.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class SpaceTableViewController: UITableViewController {
    
    // スペースの情報の一つ一つのデータを管理するための配列
    var spaceDataArray = [SpaceData]()
    
    // 再利用する画像データを管理する
    var imageCash = NSCache<AnyObject, UIImage>()
    
    // APIのリクエストURL
    var entryUrl: String = "https://www.tumolink.com/api/iosclient"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 保持しているデータをいったん削除
        spaceDataArray.removeAll()
        
        // リクエストURLを作成する
        let requestUrl = entryUrl
        
        // APIをリクエストする
        // request(requestUrl: requestUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // レスポンス内容をパースしてリストを作成する
    func parseData(resultSet: [String: Any]) {
        
        guard let firstObject = resultSet["0"] as? [String: Any] else {
            return
        }
        
        guard let results = firstObject["Reslt"] as? [String: Any] else {
            return
        }
        
        for key in results.keys.sorted() {
            // Requestのキーは無視する
            if key == "Request" {
                // 次のfor文の処理を行う
                continue
            }
            
            // スペース取得
            guard let result = results[key] as? [String: Any] else {
                // 次のfor文の処理を行う
                continue
            }
            
            // スペースのデータ格納オブジェクトを作成
            let spaceData = SpaceData()
            
            // レスポンスデータから画像の情報を取得する
            if let spaceImageDic = result["Image"] as? [String: Any] {
                let spaceImageUrl = spaceImageDic["Medium"] as? String
                spaceData.spaceImageUrl = spaceImageUrl
            }
            
            // レスポンスデータからスペース名の情報を取得する
            let spaceName = result["Name"] as? String
            spaceData.spaceName = spaceName
            
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
                return
            }
            
            // JSON形式への変換処理
            guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                // 変換失敗
                return
            }
            
            // データを解析
            guard let resultSet = jsonData["ResultSet"] as? [String: Any] else {
                // データなし
                return
            }
            
            self.parseData(resultSet: resultSet)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
