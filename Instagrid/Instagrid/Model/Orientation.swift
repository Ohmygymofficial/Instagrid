//
//  Orientation.swift
//  Instagrid
//
//  Created by E&M Life Project on 27/11/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class Orientation: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var isPortrait = true
    
    // MARK: orientation is changing
       /// changingOrientation :detect device orientation for gesture direction
    func changingOrientation(swipeLabel: UILabel, arrowForSwipe: UIImageView) {
           checkOrientationMode()
           if !isPortrait {
               swipeLabel.text = "Swipe left to share"
               arrowForSwipe.image = UIImage(named: "Arrow Left")
           } else {
               swipeLabel.text = "Swipe up to share"
               arrowForSwipe.image = UIImage(named: "Arrow Up")
           }
       }
       
       /// checkOrientationMode() : Func to check orientation mode and update var isPortrait
       func checkOrientationMode() {
           if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
               isPortrait = false
           } else {
               isPortrait = true
           }
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
