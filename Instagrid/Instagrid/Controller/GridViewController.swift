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
    @IBOutlet weak private var shareView: UIStackView!
    @IBOutlet weak private var swipeLabel: UILabel!
    @IBOutlet weak private var arrowForSwipe: UIImageView!
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
    @IBOutlet weak var chooseButtonRectangleUp: UIButton!
    @IBOutlet weak var chooseButtonRectangleDown: UIButton!
    @IBOutlet weak var chooseButtonSquare: UIButton!
    /// declare whereIsTapped : identify the good square to import a photo, default 1
    var whereIsTapped : PhotoButtonTapped = .topLeft
    /// declare gridStyle as variant to know wich Style of grid user want
    var userSelection = SelectedGrid()
    /// declare Bool slideLenghtIsOk to confirm the swipe action
    var slideLenghtIsOk = false
    /*
     /// declare Bool isPortrait to be easier to read the code
    var isPortrait = true
     */
    let orientation = Orientation()
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setting a let gestureRecognizer for detect user's gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareView.addGestureRecognizer(gestureRecognizer)
        /// detect device orientation for gesture direction
        orientation.changingOrientation(swipeLabel: swipeLabel, arrowForSwipe: arrowForSwipe)
        /// configure Choose button
        configureChooseButton()
        ///configure Square Button
        chooseButtonSquare.isSelected = true
        resetStateOfSquareButton()
    }
    
    
    // MARK: willTransition:
    /// willTransition :detect device orientation for gesture direction
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        orientation.changingOrientation(swipeLabel: swipeLabel, arrowForSwipe: arrowForSwipe)
    }
    
    /*
    // MARK: orientation is changing
    /// changingOrientation :detect device orientation for gesture direction
    func changingOrientation() {
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
    private func checkOrientationMode() {
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            isPortrait = false
        } else {
            isPortrait = true
        }
    }
    */
    
    // configureChooseButton : To change image for each button depend if selected or no
    func configureChooseButton() {
        let image = UIImage(named: "Selected")
        chooseButtonRectangleUp.setImage(image, for: .selected)
        chooseButtonRectangleUp.contentVerticalAlignment = .fill
        chooseButtonRectangleUp.contentHorizontalAlignment = .fill
        chooseButtonRectangleDown.setImage(image, for: .selected)
        chooseButtonRectangleDown.contentVerticalAlignment = .fill
        chooseButtonRectangleDown.contentHorizontalAlignment = .fill
        chooseButtonSquare.setImage(image, for: .selected)
        chooseButtonSquare.contentVerticalAlignment = .fill
        chooseButtonSquare.contentHorizontalAlignment = .fill
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
        let translation = gesture.translation(in: shareView)
        orientation.checkOrientationMode()
        if !orientation.isPortrait {
            shareView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            squareUIView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            slideLenghtIsSuffisant(translation: translation.x)
        } else {
            shareView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            squareUIView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            slideLenghtIsSuffisant(translation: translation.y)
        }
    }
    
    
    /// slideLenghtIsSuffisant private func to check if the slideLenght is suffisant
    private func slideLenghtIsSuffisant(translation: CGFloat) {
        if translation < -50 {
            slideLenghtIsOk = true
        } else { slideLenghtIsOk = false }
    }
    
    
    
    /// askingShareDone : Action When user didSwipe ended/cancelled on shareView
    private func askingShareDone(gesture : UIPanGestureRecognizer) {
        if slideLenghtIsOk {
            let sizeScreenWidth = UIScreen.main.bounds.width
            let sizeScreenHeight = UIScreen.main.bounds.height
            animationBeforeSharing(sizeScreenWidth: sizeScreenWidth, sizeScreenHeight: sizeScreenHeight)
        } else {
            animationReturnBack()
        }
    }
    
    ///animationBeforeSharing : To animate SquareView outside the screen before sharing
    private func animationBeforeSharing(sizeScreenWidth: CGFloat, sizeScreenHeight: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            if !self.orientation.isPortrait {
                self.squareUIView.transform = CGAffineTransform(translationX: -sizeScreenWidth, y:  0)
            } else {
                self.squareUIView.transform = CGAffineTransform(translationX: 0, y:  -sizeScreenHeight)
            }
        })
        { (success) in
            if success {
                self.sharePhoto()
                self.animationReturnBack()
            }
        }
    }
    
    /// sharePhoto() : to share photo with UIActivity
    private func sharePhoto() {
        // have to check if the square is complete
        squareIsItComplete()
        /// convert UIView into Image
        let renderer = UIGraphicsImageRenderer(size: squareUIView.bounds.size)
        let imageView = renderer.image { ctx in
            squareUIView.drawHierarchy(in: squareUIView.bounds, afterScreenUpdates: true)
        }
        /// share with UIActivity
        let vc = UIActivityViewController(activityItems: [imageView], applicationActivities: [])
        present(vc, animated: true)
    }
    
    ///animationReturnBack : To animate the return of the SquareView to his initial position
    private func animationReturnBack() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shareView.transform = .identity
            self.squareUIView.transform = .identity
        })
    }
    
    
    // Check depend of the disposition choosen
    func squareIsItComplete() {
        /// if rectangleUp : Must Have TopRight, BottomLeft, BottomRight
        if userSelection.gridStyle == .rectangleUp {
            checkImagesIsPresent(neededButtonImage: squareButtonTopRight)
            checkImagesIsPresent(neededButtonImage: squareButtonBottomLeft)
            checkImagesIsPresent(neededButtonImage: squareButtonBottomRight)
        }
        /// if rectangleDown : Must Have TopLeft, TopRight, BottomRight
        if userSelection.gridStyle == .rectangleDown {
            checkImagesIsPresent(neededButtonImage: squareButtonTopLeft)
            checkImagesIsPresent(neededButtonImage: squareButtonTopRight)
            checkImagesIsPresent(neededButtonImage: squareButtonBottomRight)
        }
        /// if square : Must Have TopLeft, TopRight, BottomLeft, BottomRight
        if userSelection.gridStyle == .square {
            checkImagesIsPresent(neededButtonImage: squareButtonTopLeft)
            checkImagesIsPresent(neededButtonImage: squareButtonTopRight)
            checkImagesIsPresent(neededButtonImage: squareButtonBottomLeft)
            checkImagesIsPresent(neededButtonImage: squareButtonBottomRight)
        }
    }
    
    
    // Check if user loaded image into each square
    func checkImagesIsPresent (neededButtonImage: UIButton) {
        if neededButtonImage.image(for: .normal)!.pngData() == UIImage(named: "Plus")!.pngData() {
            checkBeforeShare()
        }
    }
    
    
    // Check if all the button image is complete before sharing
    func checkBeforeShare() {
        let alert = UIAlertController(title: "IMAGE MANQUANTE", message: "Vous devez remplir chaque image avant de partager", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
        animationReturnBack()
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
        imagePicker.allowsEditing = false
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
                return squareButtonBottomRight
            }
        }
        goodButton.setImage(originalImage, for: .normal)
    }
    
    
    
    // MARK: Tap button on chooseView
    
    @IBAction func didTapChooseButtonRectangleUp(_ sender: Any) {
        userSelection.gridStyle = .rectangleUp
        isChangingDisposition(wichButtonIsHidden: squareButtonTopLeft, userSelection : userSelection)
        resetStateOfChooseButton()
        chooseButtonRectangleUp.isSelected = true
    }
    
    @IBAction func didTapChooseButtonRectangleDown(_ sender: Any) {
        userSelection.gridStyle = .rectangleDown
        isChangingDisposition(wichButtonIsHidden: squareButtonBottomLeft, userSelection : userSelection)
        resetStateOfChooseButton()
        chooseButtonRectangleDown.isSelected = true
    }
    
    
    @IBAction func didTapChooseButtonSquare(_ sender: Any) {
        userSelection.gridStyle = .square
        isChangingDisposition(wichButtonIsHidden: squareButtonTopRight, userSelection : userSelection)
        resetStateOfChooseButton()
        chooseButtonSquare.isSelected = true
    }
    
    
    
    // resetStateOfChooseButton : Func to reset each Choose Button to False Value
    func resetStateOfChooseButton() {
        chooseButtonRectangleUp.isSelected = false
        chooseButtonRectangleDown.isSelected = false
        chooseButtonSquare.isSelected = false
    }
    
    /// isChangingDisposition : Changing disposition in square view depend of wich one is choosen
    private func isChangingDisposition(wichButtonIsHidden : UIButton, userSelection : SelectedGrid) {
        UIView.animate(withDuration: 0.3) {
            self.resetStateOfSquareButton()
            if userSelection.gridStyle != .square  {
                wichButtonIsHidden.isHidden = true
                ///replace rectangle 3 into rectangle 4
                if userSelection.gridStyle == .rectangleUp {
                    self.squareButtonTopRight.setBackgroundImage(UIImage(named: "Rectangle 4"), for: .normal)
                } else {
                    self.squareButtonBottomRight.setBackgroundImage(UIImage(named: "Rectangle 4"), for: .normal)
                }
            }
        }
    }
    
    // resetStateOfSquareButton : Func to reset Square Button to False Value
    func resetStateOfSquareButton() {
        UIView.animate(withDuration: 0.3) {
            self.squareButtonTopLeft.isHidden = false
            self.squareButtonTopRight.isHidden = false
            self.squareButtonBottomLeft.isHidden = false
            self.squareButtonBottomRight.isHidden = false
            self.squareButtonTopRight.setBackgroundImage(UIImage(named: "Rectangle 3"), for: .normal)
            self.squareButtonBottomRight.setBackgroundImage(UIImage(named: "Rectangle 3"), for: .normal)
        }
    }
}


