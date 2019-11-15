//
//  GridViewController.swift
//  Instagrid
//
//  Created by E&M Life Project on 26/06/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
    @IBOutlet weak var squareBottomButton1: UIButton!
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
        tapBottomButton1()
    }
    
    
    /**
     Bottom Button 1 Action
     */
    private func tapBottomButton1() {
        
        swipeUpLabel.text = "Je cherche une image"
        showImagePickerController()
    }
    
    func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        let actionSheet = UIAlertController(title: "Photo source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                self.swipeUpLabel.text = "Camera not avalaible right now"
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    /// Controller of the image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            squareBottomButton1.setImage(editedImage, for: .normal)
        } else {
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                squareBottomButton1.setImage(originalImage, for: .normal)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    // MARK: TAP BUTTON ON CHOOSEVIEW
    /**
     ChooseButton1 TAP
     */
    @IBAction func didTapChooseButton1(_ sender: Any) {
        tapChooseButton1()
    }
    /**
     ChooseButton1 Action
     */
    private func tapChooseButton1() {
        squareUpButton1.isHidden = true
        squareUpButton2.isHidden = false
        squareBottomButton1.isHidden = false
        squareBottomButton2.isHidden = false
    }
    
    
    /**
     ChooseButton2 TAP
     */
    @IBAction func didTapChooseButton2(_ sender: Any) {
        tapChooseButton2()
    }
    /**
     ChooseButton2 Action
     */
    private func tapChooseButton2() {
        squareUpButton1.isHidden = false
        squareUpButton2.isHidden = false
        squareBottomButton1.isHidden = true
        squareBottomButton2.isHidden = false
    }
    
    /**
     ChooseButton3 TAP
     */
    @IBAction func didTapChooseButton3(_ sender: Any) {
        tapChooseButton3()
    }
    /**
     ChooseButton3 Action
     */
    private func tapChooseButton3() {
        squareUpButton1.isHidden = false
        squareUpButton2.isHidden = false
        squareBottomButton1.isHidden = false
        squareBottomButton2.isHidden = false
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
                print("Choix 1")
            case .rectangleUp:
                print("Choix 2")
            case .rectangleDown:
                print("Choix 3")
            }
        }
    }
}

