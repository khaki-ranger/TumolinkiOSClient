//
//  LoginViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/03/16.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    // 画面遷移
    func segueToSpaceTableViewController() {
        self.performSegue(withIdentifier: "toSpaceTableViewController", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // ログイン済みかどうかチェックする
        if let _ = FBSDKAccessToken.current() {
            // ログインしているので画面遷移する
            print("Debug : ログインしてます")
            segueToSpaceTableViewController()
        } else {
            // FBログインボタンを設置
            let fbLoginBtn = FBSDKLoginButton()
            fbLoginBtn.readPermissions = ["public_profile", "email"]
            fbLoginBtn.center = self.view.center
            fbLoginBtn.delegate = self
            self.view.addSubview(fbLoginBtn)
        }
    }
    
    // ログインのコールバック
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        // エラーチェック
        if error == nil {
            // キャンセルしたかどうか
            if result.isCancelled {
                print("Debug : キャンセル")
            } else {
                // ログインできたので画面遷移する
                print("Debug : ログインしました")
                segueToSpaceTableViewController()
            }
        } else {
            print("Debug : エラー")
        }
    }
    
    // ログアウトのコールバック
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Debug : ログアウトしました")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
