//
//  ViewController.swift
//  Instagrid
//
//  Created by E&M Life Project on 26/06/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // All objects of the view
    
    @IBOutlet weak var instagrid: UIImageView!
    @IBOutlet weak var shareview: UIStackView!
    @IBOutlet weak var swipeUpLabel: UILabel!
    @IBOutlet weak var arrowUpImage: UIImageView!
    @IBOutlet weak var squareView: UIStackView!
    @IBOutlet weak var squareUpView: UIStackView!
    @IBOutlet weak var squareBottomView: UIStackView!
    @IBOutlet weak var chooseView: UIStackView!
    @IBOutlet weak var layoutImage1: UIImageView!
    @IBOutlet weak var layoutImage2: UIImageView!
    @IBOutlet weak var layoutImage3: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    
    class SelectedGrid: UIView {
        
        enum Style {
            case square, rectangleUp, rectangleDown
        }
        
        var style: Style = .square {
            didSet {
                setStyle(style)
            }
        }
        
        private func setStyle(_ style: Style) {
            switch style {
            case .square:
                
            case .rectangleUp:
            //code
            case .rectangleDown:
                //code
            }
        }
    }
}

