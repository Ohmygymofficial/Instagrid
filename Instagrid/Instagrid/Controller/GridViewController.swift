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
    /// All objects of the view
    @IBOutlet weak private var instagrid: UIImageView!
    /// ShareView
    @IBOutlet weak private var shareview: UIStackView!
    @IBOutlet weak private var swipeUpLabel: UILabel!
    @IBOutlet weak private var arrowUpImage: UIImageView!
    /// SquareView
    @IBOutlet weak private var squareUIView: UIView!
    @IBOutlet weak private var squareView: UIStackView!
    @IBOutlet weak private var squareUpView: UIStackView!
    @IBOutlet weak private var squareButtonTopLeft: UIButton!
    @IBOutlet weak private var squareButtonTopRight: UIButton!
    @IBOutlet weak private var squareBottomView: UIStackView!
    @IBOutlet weak private var squareButtonBottomLeft: UIButton!
    @IBOutlet weak private var squareButtonBottomRight: UIButton!
    /// ChooseView
    @IBOutlet weak private var chooseView: UIStackView!
    @IBOutlet weak var chooseButton1: UIButton!
    @IBOutlet weak var chooseButton2: UIButton!
    @IBOutlet weak var chooseButton3: UIButton!
    /// declare whereIsTapped : identify the good square to import a photo, default 1
    var whereIsTapped : PhotoButtonTapped = .topLeft
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setting a let gestureRecognizer for detect user's gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareview.addGestureRecognizer(gestureRecognizer)
        /// detect device orientation for gesture direction
        changingOrientation()
    }

    
    // MARK: willTransition:
    /// willTransition :detect device orientation for gesture direction
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        changingOrientation()
    }
    
    
    // MARK: orientation is changing
    /// changingOrientation :detect device orientation for gesture direction
    func changingOrientation() {
        if UIDevice.current.orientation == .landscapeRight {
            self.swipeUpLabel.text = "Swipe right to share"
            self.swipeUpLabel.isHidden = false
        } else if UIDevice.current.orientation == .landscapeLeft {
            swipeUpLabel.text = "Swipe left to share"
            self.swipeUpLabel.isHidden = false
        } else {
            self.swipeUpLabel.text = "Swipe up to share"
            self.swipeUpLabel.isHidden = false
            self.swipeUpLabel.transform = .identity
        }
    }
    
    
    // MARK: Swipe on share view
    
    /// userDidSwipe : Case When user didSwipe on shareView
    @objc func userDidSwipe(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformShareView(gesture: sender)
        case .ended, .cancelled:
            askingShareDone(gesture: sender)
        default:
            break
        }
    }
    /// transformShareView : Action When user didSwipe began/changed on shareView
    private func transformShareView(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: shareview)
        shareview.transform = CGAffineTransform(translationX: 0, y: translation.y)
    }
    /// askingShareDone : Action When user didSwipe ended/cancelled on shareView
    private func askingShareDone(gesture : UIPanGestureRecognizer) {
        shareview.transform = .identity
        /// UIActivity to share
        let renderer = UIGraphicsImageRenderer(size: squareUIView.bounds.size)
        let imageView = renderer.image { ctx in
            squareUIView.drawHierarchy(in: squareUIView.bounds, afterScreenUpdates: true)
        }
        let vc = UIActivityViewController(activityItems: [imageView], applicationActivities: [])
        present(vc, animated: true)
    }


    

    
    
    // MARK: Tap button on square view
    @IBAction func didTapOnTopLeftButton(_ sender: UIButton) {
        whereIsTapped = .topLeft
        showImagePickerController()
    }
    
    @IBAction func didTapOnTopRightButton(_ sender: Any) {
          whereIsTapped = .topRight
          showImagePickerController()
      }
    
    
    @IBAction func didTapOnBottomLeftButton(_ sender: Any) {
        whereIsTapped = .bottomLeft
        showImagePickerController()
    }
    
    @IBAction func didTapOnBottomRightButton(_ sender: Any) {
        whereIsTapped = .bottomRight
        showImagePickerController()
    }
    
    
    // MARK: User want to import an image
    
    /// showImagePickerController : Used to choose option
    private func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    /// imagePickerController : To import image in the good Square
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            sendInGoodButton(originalImage: originalImage, whereIsTapped: whereIsTapped)
                }
            dismiss(animated: true, completion: nil)
        }

    /// sendInGoodButton : Refactor to import image in the good square depending of wich button is tapped
    func sendInGoodButton(originalImage: UIImage, whereIsTapped : PhotoButtonTapped) {
        var goodButton : UIButton {
            switch whereIsTapped {
            case .topLeft :
                return squareButtonTopLeft
            case .topRight :
                return squareButtonTopRight
            case .bottomLeft :
                return squareButtonBottomLeft
            default:
                return squareButtonTopRight
            }
        }
        goodButton.setImage(originalImage, for: .normal)
    }
    
    
    
    // MARK: Tap button on chooseView

    @IBAction func didTapChooseButton1(_ sender: Any) {
        isChangingDisposition(wichButtonIsHidden: squareButtonTopLeft)
    }
    @IBAction func didTapChooseButton2(_ sender: Any) {
        isChangingDisposition(wichButtonIsHidden: squareButtonBottomLeft)    }
    @IBAction func didTapChooseButton3(_ sender: Any) {
        isChangingDisposition(wichButtonIsHidden: squareButtonTopRight)    }
    
/// isChangingDisposition : Changing disposition in square view depend of wich one is choosen
    private func isChangingDisposition(wichButtonIsHidden : UIButton) {
        if wichButtonIsHidden == squareButtonTopLeft {
            wichButtonIsHidden.isHidden = true
            squareButtonTopRight.isHidden = false
            squareButtonBottomLeft.isHidden = false
            squareButtonBottomRight.isHidden = false
        }else if wichButtonIsHidden == squareButtonBottomLeft {
            wichButtonIsHidden.isHidden = true
            squareButtonTopLeft.isHidden = false
            squareButtonTopRight.isHidden = false
            squareButtonBottomRight.isHidden = false
        }else{
            squareButtonTopLeft.isHidden = false
            squareButtonTopRight.isHidden = false
            squareButtonBottomLeft.isHidden = false
            squareButtonBottomRight.isHidden = false
        }
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

