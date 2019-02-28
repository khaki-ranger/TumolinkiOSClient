//
//  SpaceViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/28.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class SpaceViewController: UIViewController {
    
    // スペース名
    var spaceName: String?

    @IBOutlet weak var spaceNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let spaseName = spaceName else {
            return
        }
        
        spaceNameLabel.text = spaseName
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
