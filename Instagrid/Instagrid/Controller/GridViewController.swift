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
    @IBOutlet weak private var chooseButtonRectangleUp: UIButton!
    @IBOutlet weak private var chooseButtonRectangleDown: UIButton!
    @IBOutlet weak private var chooseButtonSquare: UIButton!
    /// ChooseVIew COLLECTION
    @IBOutlet private var selectedGridCollection: [UIButton]!
    
    
    
    
    
    /// declare whereIsTapped : identify the good square to import a photo, default 1
    var whereIsTapped : PhotoButtonTapped = .topLeft
    /// declare gridStyle as variant to know wich Style of grid user want
    let userSelection = SelectedGrid()
    /// let model to use var and func of Class GridModel
    let model = GridModel()
    
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Setting a let gestureRecognizer for detect user's gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareView.addGestureRecognizer(gestureRecognizer)
        /// configure orientation Arrow image and Swipe Label
        configureOrientation()
        /// configure Choose button
        configureChooseButton()
        ///configure Square Button
        chooseButtonSquare.isSelected = true
        resetStateOfSquareButton()
    }
    
    
    // MARK: willTransition:
    /// willTransition :detect device orientation for gesture direction
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        configureOrientation()
    }
    
    
    func configureOrientation() {
        let (swipeLabelText, arrowImage) = model.makeSwipeLabelTextAndArrow()
        print("L'image est : \(arrowImage)")
        arrowForSwipe.image = arrowImage
        swipeLabel.text = swipeLabelText
    }
    
    
    // configureChooseButton : To change image for each button depend if selected or no
    func configureChooseButton() {
        let image = UIImage(named: "Selected")
        for button in selectedGridCollection {
            button.setImage(image, for: .selected)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
        }
    }
    
    
    // MARK: Swipe on share view
    /// userDidSwipe : Case When user didSwipe on shareView
    @objc func userDidSwipe(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformShareViewAndSquareView(gesture: sender)
        case .ended, .cancelled:
            askingShareDone(gesture: sender)
        default:
            break
        }
    }
    
    /*
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
     */
    
    /// transformShareViewAndSquareView : Give instruction to do When user didSwipe began/changed on shareView
    private func transformShareViewAndSquareView(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: shareView)
        let transformation = model.giveTransformationSwipeValue(translation: translation)
        shareView.transform = transformation
        squareUIView.transform = transformation
    }
    
    
    
    /// askingShareDone : Action When user didSwipe ended/cancelled on shareView
    private func askingShareDone(gesture : UIPanGestureRecognizer) {
        ///je dois vérifier si portrait ou paysage
        let isPortrait = model.isOrientationPortrait()
        /// je dois vérifier si le swipe est suffisant
        let translation = gesture.translation(in: shareView)
        let isSwipeLenghtIsOk = model.isSlideLenghtIsSuffisant(translation: translation)
        /// je dois vérifier la taille de l'ecran
        let (sizeScreenWidth, sizeScreenHeight) = model.giveTheSizeOfTheScreen()
        /// je dois lancer une animation puis share la photo
        ///ou je dois revenir a letat normal
        if isSwipeLenghtIsOk {
            UIView.animate(withDuration: 0.3, animations: {
                if !isPortrait {
                    self.squareUIView.transform = CGAffineTransform(translationX: -sizeScreenWidth, y:  0)
                    self.shareView.transform = CGAffineTransform(translationX: -sizeScreenWidth, y:  0)
                } else {
                    self.squareUIView.transform = CGAffineTransform(translationX: 0, y:  -sizeScreenHeight)
                    self.shareView.transform = CGAffineTransform(translationX: 0, y:  -sizeScreenHeight)
                }
            })
            { (success) in
                if success {
                    self.sharePhoto()
                    self.animationReturnBack()
                }
            }
        } else {
            animationReturnBack()
        }
    }
    
    /*
     ///animationBeforeSharing : To animate SquareView outside the screen before sharing
     private func animationBeforeSharing(sizeScreenWidth: CGFloat, sizeScreenHeight: CGFloat) {
     UIView.animate(withDuration: 0.3, animations: {
     if !self.orientation.isPortrait {
     self.squareUIView.transform = CGAffineTransform(translationX: -sizeScreenWidth, y:  0)
     self.shareView.transform = CGAffineTransform(translationX: -sizeScreenWidth, y:  0)
     } else {
     self.squareUIView.transform = CGAffineTransform(translationX: 0, y:  -sizeScreenHeight)
     self.shareView.transform = CGAffineTransform(translationX: 0, y:  -sizeScreenHeight)
     }
     })
     { (success) in
     if success {
     self.sharePhoto()
     self.animationReturnBack()
     }
     }
     }
     */
    
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
        goodButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    
    // MARK: Tap button on chooseView
    // resetStateOfSelectedGridCollection : Func to reset each Choose Button to False Value
    @IBAction func resetStateOfSelectedGridCollection(_ sender: [UIButton]) {
        for button in selectedGridCollection {
            button.isSelected = false
        }
    }

    
    
    @IBAction func didTapChooseButtonRectangleUp(_ sender: Any) {
        userSelection.gridStyle = .rectangleUp
        isChangingDisposition(wichButtonIsHidden: squareButtonTopLeft, userSelection : userSelection)
        resetStateOfSelectedGridCollection(selectedGridCollection)
        //resetStateOfChooseButton()
        chooseButtonRectangleUp.isSelected = true
    }
    
    @IBAction func didTapChooseButtonRectangleDown(_ sender: Any) {
        userSelection.gridStyle = .rectangleDown
        isChangingDisposition(wichButtonIsHidden: squareButtonBottomLeft, userSelection : userSelection)
        resetStateOfSelectedGridCollection(selectedGridCollection)
        // resetStateOfChooseButton()
        chooseButtonRectangleDown.isSelected = true
    }
    
    
    @IBAction func didTapChooseButtonSquare(_ sender: Any) {
        userSelection.gridStyle = .square
        isChangingDisposition(wichButtonIsHidden: squareButtonTopRight, userSelection : userSelection)
        resetStateOfSelectedGridCollection(selectedGridCollection)
        // resetStateOfChooseButton()
        chooseButtonSquare.isSelected = true
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
