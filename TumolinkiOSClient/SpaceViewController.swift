//
//  SpaceViewController.swift
//  TumolinkiOSClient
//
//  Created by 寺島 洋平 on 2019/02/28.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class SpaceViewController: UIViewController {
    
    // スペースの情報
    var space: SpaceData?
    var spaceImage: UIImage?
    
    // MARK: Properties
    @IBOutlet weak var spaceImageView: UIImageView!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
