//
//  GridModel.swift
//  Instagrid
//
//  Created by E&M Life Project on 27/11/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class GridModel {
    
    /// makeSwipeLabelTextAndArrowImage : To return good arrow image and good Swipe Text value
    func makeSwipeLabelTextAndArrow() -> (String, UIImage?) {
        if !isOrientationPortrait() {
            let image = UIImage(named: "Arrow up")
            if image != nil {
                return ("Swipe up to share", image)
            }
        } else {
            if let image = UIImage(named: "Arrow left") {
                return ("Swipe left to share", image)
            }
        }
        return ("Swipe up to share", UIImage(named: "Arrow up"))
    }
    
    /*
     /// makeSwipeLabelTextAndArrowImage : To return good arrow image and good Swipe Text value
     func makeSwipeLabelTextAndArrow() -> (String, UIImage?) {
     /// voir avec Lilian : Ici, en portrait, je suis obligé de mettre ! sinon  ca passe dans arrow left (BOOL return est donc faux)
     if !isOrientationPortrait() {
     return ("Swipe up to share", UIImage(named: "Arrow up"))
     ///voir avec LILIAN : Aussi : l'image retournée est NIL
     } else {
     return ("Swipe left to share", UIImage(named: "Arrow left"))
     }
     }
     */
    
    
    /// isOrientationPortrait() : Return BOOL depend of the orientation
    func isOrientationPortrait() -> Bool {
        return UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
    }
    
    
    /// giveTransformationSwipeValue : Return the good translation on X or Y to the user swipe action
    func giveTransformationSwipeValue(translation: CGPoint) -> (CGAffineTransform) {
        if isOrientationPortrait() {
            return ( CGAffineTransform(translationX: 0, y: translation.y))
        } else {
            return ( CGAffineTransform(translationX: translation.x, y: 0))
        }
    }
    
    
    /// giveTheSizeOfTheScreen : return the size of the screen
    func giveTheSizeOfTheScreen() -> (CGFloat, CGFloat) {
        return (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    
    /// slideLenghtIsSuffisant private func to check if the slideLenght is suffisant
    func isSlideLenghtIsSuffisant(translation: CGPoint) -> Bool {
        let translationToApply : CGFloat
        if isOrientationPortrait() {
            translationToApply = translation.y
        } else {
            translationToApply = translation.x
        }
        if translationToApply < -50 {
            return true
        } else {
            return false
            
        }
    }
    
    
}
