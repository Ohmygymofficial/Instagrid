//
//  GridViewController.swift
//  Instagrid
//
//  Created by E&M Life Project on 26/06/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    
    
    // MARK: IBOutlet Link
    /**
     All objects of the view
     */
    @IBOutlet weak private var instagrid: UIImageView!
    /**
     ShareView
     */
    @IBOutlet weak private var shareview: UIStackView!
    @IBOutlet weak private var swipeUpLabel: UILabel!
    @IBOutlet weak private var arrowUpImage: UIImageView!
    /**
     SquareView
     */
    @IBOutlet weak private var squareUIView: UIView!
    @IBOutlet weak private var squareView: UIStackView!
    @IBOutlet weak private var squareUpView: UIStackView!
    @IBOutlet weak private var squareUpButton1: UIButton!
    @IBOutlet weak private var squareUpButton2: UIButton!
    @IBOutlet weak private var squareBottomView: UIStackView!
    @IBOutlet weak private var squareBottomButton1: UIButton!
    @IBOutlet weak private var squareBottomButton2: UIButton!
    /**
     ChooseView
     */
    @IBOutlet weak private var chooseView: UIStackView!
    @IBOutlet weak var chooseButton1: UIButton!
    @IBOutlet weak var chooseButton2: UIButton!
    @IBOutlet weak var chooseButton3: UIButton!
    
    
    // MARK: DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        /**
         Setting a let gestureRecognizer for detect user's gesture
         */
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareview.addGestureRecognizer(gestureRecognizer)
    }
    
    
    // MARK: SWIPE ON SHARE VIEW
    /**
     Case When user didSwipe on shareView
     */
    @objc func userDidSwipe(sender: UIPanGestureRecognizer) {
        // AJOUTER ICI UNE CONDITION DU TYPE : SI LES IMAGES NE SONT PAS REMPLIES ALORS ON AFFICHE UNE ALERTE, SINON ON PERMET LE SHARE
        switch sender.state {
        case .began, .changed:
            swipeUpLabel.text = "begin"
            transformShareView(gesture: sender)
        case .ended, .cancelled:
            swipeUpLabel.text = "share"
            askingShareDone(gesture: sender)
        default:
            break
        }
        
    }
    
    /**
    Action When user didSwipe began/changed on shareView
    */
    private func transformShareView(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: shareview)
        shareview.transform = CGAffineTransform(translationX: 0, y: translation.y)
    }
    
    /**
    Action When user didSwipe ended/cancelled on shareView
    */
    private func askingShareDone(gesture : UIPanGestureRecognizer) {
        shareview.transform = .identity
    }
    
    
    // MARK: TAP BUTTON ON SQUAREVIEW
    /**
    Bottom Button 1 TAP
     */
    @IBAction func didTapBottomButton1(_ sender: Any) {
        TapBottomButton1()
    }
    
    
    /**
    Bottom Button 1 Action
     */
    private func TapBottomButton1() {
        swipeUpLabel.text = "Je change quand tu tapes"
    }
    
    
    // MARK: TAP BUTTON ON CHOOSEVIEW
    /**
    ChooseButton1 TAP
     */
    
    
    
    
    
    
    
    
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
                print("Choix 1")
            case .rectangleUp:
                print("Choix 2")
            case .rectangleDown:
                print("Choix 3")
            }
        }
    }
}

