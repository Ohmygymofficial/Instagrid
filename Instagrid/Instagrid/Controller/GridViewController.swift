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
    /// ShareView
    @IBOutlet weak private var shareView: UIStackView!
    @IBOutlet weak private var swipeLabel: UILabel!
    @IBOutlet weak private var arrowForSwipe: UIImageView!
    /// SquareView
    @IBOutlet weak private var squareUIView: UIView!
    @IBOutlet weak private var squareButtonTopLeft: UIButton!
    @IBOutlet weak private var squareButtonTopRight: UIButton!
    @IBOutlet weak private var squareButtonBottomLeft: UIButton!
    @IBOutlet weak private var squareButtonBottomRight: UIButton!
    @IBOutlet var squareCollection: [UIButton]!
    /// ChooseView
    @IBOutlet weak private var chooseButtonRectangleUp: UIButton!
    @IBOutlet weak private var chooseButtonRectangleDown: UIButton!
    @IBOutlet weak private var chooseButtonSquare: UIButton!
    @IBOutlet private var gridCollection: [UIButton]!
    ///var declaration
    var currentButton = UIButton()
    var myArray: [UIButton] = []
    var xValueDisparition: CGFloat = 0
    var yValueDisparition: CGFloat = 0
    var model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting a let gestureRecognizer to detect user's gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidSwipe(sender:)))
        shareView.addGestureRecognizer(gestureRecognizer)
        configureOrientation()
        didTapOnAnyChooseButton(_ : chooseButtonSquare)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        configureOrientation()
    }
    
    // ConfigureOrientation : Take back from model : Good Label and Arrow depend of the orientation mode
    private func configureOrientation() {
        let (goodArrowIs, goodSwipeIs) = model.giveGoodArrowAndLabel(isPortrait: isPortraitMode())
        arrowForSwipe.image = UIImage(named: goodArrowIs)
        swipeLabel.text = goodSwipeIs
    }
    
    private func isPortraitMode() -> Bool {
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            return false
        default:
            return true
        }
    }
    
    // MARK: - UserDidSwipe
    @objc func userDidSwipe(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            transformShareViewAndSquareView(gesture: sender)
        case .ended, .cancelled:
            releaseSwipe(gesture: sender)
        default:
            break
        }
    }
    
    private func transformShareViewAndSquareView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: shareView)
        if isPortraitMode() {
            gestureSize(xTranslation: 0, yTranslation: translation.y)
            checkingSlideLenght(translation: translation.y)
            xValueDisparition = 0
            yValueDisparition = UIScreen.main.bounds.height
        } else {
            gestureSize(xTranslation: translation.x, yTranslation: 0)
            checkingSlideLenght(translation: translation.x)
            xValueDisparition = UIScreen.main.bounds.width
            yValueDisparition = 0
        }
    }
    
    private func checkingSlideLenght(translation: CGFloat) {
        let slideLenght: CGFloat = 50
        if translation < -slideLenght {
            model.swipeLenghtIsSuffisant = true
        } else {
            model.swipeLenghtIsSuffisant = false
        }
    }
    
    private func releaseSwipe(gesture: UIPanGestureRecognizer) {
        if model.swipeLenghtIsSuffisant {
            UIView.animate(withDuration: 0.3, animations: {
                self.gestureSize(xTranslation: -self.xValueDisparition, yTranslation: -self.yValueDisparition)
            })
            { (success) in
                if success {
                    self.checkIfImagesArePresent(neededButtonImage: self.myArray)
                    self.sharePhoto()
                }
            }
        } else {
            squareUIView.transform  = .identity
            shareView.transform = .identity
        }
    }

    private func sharePhoto() {
        let renderer = UIGraphicsImageRenderer(size: squareUIView.bounds.size)
        let imageView = renderer.image { _ in
            squareUIView.drawHierarchy(in: squareUIView.bounds, afterScreenUpdates: true)
        }
        let viewC = UIActivityViewController(activityItems: [imageView], applicationActivities: [])
        present(viewC, animated: true)
        animationReturnBack()
    }

    private func animationReturnBack() {
        UIView.animate(withDuration: 0.3, animations: {
            self.gestureSize(xTranslation: 0, yTranslation: 0)
        })
    }

    private func checkIfImagesArePresent(neededButtonImage: [UIButton]) {
        for button in neededButtonImage {
            if button.image(for: .normal)!.pngData() == UIImage(named: "Plus")!.pngData() {
                let (title, message) = model.alertMessageMissingImage()
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                animationReturnBack()
            }
        }
    }
    
    // MARK: - didTapOnSquareButton
    @IBAction func didTapOnSquareButton(_ sender: UIButton) {
        currentButton = sender
        showImagePickerController()
    }
    
    private func showImagePickerController() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            currentButton.setImage(originalImage, for: .normal)
            currentButton.imageView?.contentMode = .scaleAspectFill
            currentButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - didTapOnAnyChooseButton
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
    
    private func isChangingDisposition(arrayButtonIsVisible: [UIButton]) {
         UIView.animate(withDuration: 0.3) {
             for button in arrayButtonIsVisible {
                 button.isHidden = false
             }
         }
     }
     
     private func resetStateOfSquareButton() {
         UIView.animate(withDuration: 0.3) {
             for button in self.squareCollection {
                 button.isHidden = true
                 button.setBackgroundImage(UIImage(named: "Rectangle 3"), for: .normal)
             }
         }
     }
    
    private func resetStateOfSelectedGridCollection() {
        let image = UIImage(named: "Selected")
        for button in gridCollection {
            button.isSelected = false
            button.setImage(image, for: .selected)
            button.contentVerticalAlignment = .fill
            button.contentHorizontalAlignment = .fill
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension GridViewController: UIImagePickerControllerDelegate {
}
// MARK: - UINavigationControllerDelegate
extension GridViewController: UINavigationControllerDelegate{
}
// MARK: - animation
extension GridViewController {
    func gestureSize(xTranslation: CGFloat, yTranslation: CGFloat) {
        // Lilian desire mettre ca dans le model = impossible car le CFFloat ou le CGAffine depend du UIKit
        shareView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
        squareUIView.transform = CGAffineTransform(translationX: xTranslation, y: yTranslation)
    }
}

