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
    /// ShareView
    @IBOutlet weak private var shareView: UIStackView!
    @IBOutlet weak private var swipeLabel: UILabel!
    @IBOutlet weak private var arrowForSwipe: UIImageView!
    /// SquareView
    @IBOutlet weak var squareUIView: UIView!
    @IBOutlet weak private var squareButtonTopLeft: UIButton!
    @IBOutlet weak private var squareButtonTopRight: UIButton!
    @IBOutlet weak private var squareButtonBottomLeft: UIButton!
    @IBOutlet weak private var squareButtonBottomRight: UIButton!
    /// Square COLLECTION
    @IBOutlet var squareCollection: [UIButton]!
    /// ChooseView
    @IBOutlet weak private var chooseButtonRectangleUp: UIButton!
    @IBOutlet weak private var chooseButtonRectangleDown: UIButton!
    @IBOutlet weak private var chooseButtonSquare: UIButton!
    /// ChooseVIew COLLECTION
    @IBOutlet private var gridCollection: [UIButton]!
    
    var currentButton = UIButton()
    var myArray: [UIButton] = []
    var isPortrait = true
    var swipeLenghtIsSuffisant = false
    var disparitionOfX: CGFloat = 0
    var disparitionOfY: CGFloat = 0
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting a let gestureRecognizer to detect user's gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareView.addGestureRecognizer(gestureRecognizer)
        configureOrientation()
        didTapOnAnyChooseButton(_ : chooseButtonSquare)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            isPortrait = false
        default:
            isPortrait = true
        }
        configureOrientation()
    }
    
    
    func configureOrientation() {
        if isPortrait {
            arrowForSwipe.image = UIImage(named: "arrow-up")
            swipeLabel.text = "Swipe up to share"
        } else {
            arrowForSwipe.image = UIImage(named: "arrow-left")
            swipeLabel.text = "Swipe left to share"
        }
    }
    
    
    // MARK: Swipe on share view
    /// userDidSwipe : Case When user didSwipe on shareView
    @objc func userDidSwipe(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformShareViewAndSquareView(gesture: sender)
        case .ended, .cancelled:
            releaseSwipe()
        default:
            break
        }
    }
    
    /// transformShareViewAndSquareView : Give instruction to do When user didSwipe began/changed on shareView
    private func transformShareViewAndSquareView(gesture : UIPanGestureRecognizer) {
        let translation = gesture.translation(in: shareView)
        if isPortrait {
            animationSquareAndShareView(translationForX: 0, translationForY: translation.y)
            checkingSlideLenght(translation: translation.y)
            disparitionOfX = 0
            disparitionOfY = UIScreen.main.bounds.height
        } else {
            animationSquareAndShareView(translationForX: translation.x, translationForY: 0)
            checkingSlideLenght(translation: translation.x)
            disparitionOfX = UIScreen.main.bounds.width
            disparitionOfY = 0
        }
    }
    
    
    
     // releaseSwipe : Action When user ended/cancelled Swipe on shareView
    private func releaseSwipe() {
        if swipeLenghtIsSuffisant == true {
            UIView.animate(withDuration: 0.3, animations:  {
                self.animationSquareAndShareView(translationForX: -self.disparitionOfX, translationForY: -self.disparitionOfY)
            })
            { (success) in
                if success {
                    self.checkImagesIsPresent(neededButtonImage: self.myArray)
                    self.sharePhoto()
                }
            }
        } else {
            squareUIView.transform  = .identity
            shareView.transform = .identity
        }
    }
    
    
    /// sharePhoto() : to share photo with UIActivity
    private func sharePhoto() {
        /// convert UIView into Image
        let renderer = UIGraphicsImageRenderer(size: squareUIView.bounds.size)
        let imageView = renderer.image { ctx in
            squareUIView.drawHierarchy(in: squareUIView.bounds, afterScreenUpdates: true)
        }
        /// share with UIActivity
        let vc = UIActivityViewController(activityItems: [imageView], applicationActivities: [])
        present(vc, animated: true)
        animationReturnBack()
    }
    
    
    ///animationReturnBack : To animate the return of the SquareView to his initial position
    private func animationReturnBack() {
        UIView.animate(withDuration: 0.3, animations: {
            // a passer dans la methode extension creee
            self.animationSquareAndShareView(translationForX: 0, translationForY: 0)
        })
    }
    
    
    // Check if user loaded image into each square
    func checkImagesIsPresent(neededButtonImage: [UIButton]) {
        for button in neededButtonImage {
            if button.image(for: .normal)!.pngData() == UIImage(named: "Plus")!.pngData() {
                let alert = UIAlertController(title: "PARTAGE IMPOSSIBLE", message: "Vous devez remplir chaque image avant de partager", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                animationReturnBack()
            }
        }
    }
    
    
    
    @IBAction func didTapOnSquareButton(_ sender: UIButton) {
        currentButton = sender
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
    //
    /// imagePickerController : To import image in the good Square
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentButton.setImage(originalImage, for: .normal)
            currentButton.imageView?.contentMode = .scaleAspectFill
            currentButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    /// isChangingDisposition : Changing disposition in square view depend of wich one is choosen
    private func isChangingDisposition(arrayButtonIsVisible : [UIButton]) {
        UIView.animate(withDuration: 0.3) {
            for button in arrayButtonIsVisible {
                button.isHidden = false
            }
        }
    }
    
    
    @IBAction func didTapOnAnyChooseButton(_ sender: UIButton) {
        resetStateOfSelectedGridCollection()
        resetStateOfSquareButton()
        sender.isSelected = true
        if sender == chooseButtonRectangleUp {
            myArray = [squareButtonTopRight, squareButtonBottomLeft, squareButtonBottomRight]
            self.squareButtonTopRight.setBackgroundImage(UIImage(named: "Rectangle 4"), for: .normal)
        } else if sender == chooseButtonRectangleDown {
            myArray = [squareButtonTopRight, squareButtonTopLeft, squareButtonBottomRight]
            self.squareButtonBottomRight.setBackgroundImage(UIImage(named: "Rectangle 4"), for: .normal)
        } else if sender == chooseButtonSquare {
            myArray = [squareButtonTopRight, squareButtonTopLeft, squareButtonBottomLeft, squareButtonBottomRight]
        }
        isChangingDisposition(arrayButtonIsVisible: myArray)
    }
    
    
    func resetStateOfSquareButton() {
        UIView.animate(withDuration: 0.3) {
            for button in self.squareCollection {
                button.isHidden = true
                button.setBackgroundImage(UIImage(named: "Rectangle 3"), for: .normal)
            }
        }
    }
    
    func resetStateOfSelectedGridCollection() {
        let image = UIImage(named: "Selected")
        for button in gridCollection {
            button.isSelected = false
            button.setImage(image, for: .selected)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
        }
    }
    
    func animationSquareAndShareView(translationForX: CGFloat, translationForY: CGFloat) {
        shareView.transform = CGAffineTransform(translationX: translationForX, y: translationForY)
        squareUIView.transform = CGAffineTransform(translationX: translationForX, y: translationForY)
    }
    
    func checkingSlideLenght(translation: CGFloat) {
        let slideLenght: CGFloat = 50
        if translation < -slideLenght {
            swipeLenghtIsSuffisant = true
        } else { swipeLenghtIsSuffisant = false }
    }
}




