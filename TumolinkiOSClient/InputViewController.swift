//
//  InputViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/04/14.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var tumoliLabel: UILabel!
    @IBOutlet weak var tumoliSlider: UISlider!
    
    // ツモリ度を格納する変数
    var tumoli:Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ツモリスライダーの初期設定
        tumoliSlider.maximumValue = 100
        tumoliSlider.minimumValue = 0
        tumoliSlider.value = 0
        tumoliLabel.text = String(Int(tumoliSlider.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSlider(_ sender: UISlider) {
        tumoliLabel.text = String(Int(sender.value))
        tumoli = Int(sender.value)
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
