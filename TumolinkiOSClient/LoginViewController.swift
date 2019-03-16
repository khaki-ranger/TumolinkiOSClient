//
//  LoginViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/03/16.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // 画面遷移
    func segueToSpaceTableViewController() {
        self.performSegue(withIdentifier: "toSpaceTableViewController", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Debug : 画面遷移します")
        segueToSpaceTableViewController()
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
