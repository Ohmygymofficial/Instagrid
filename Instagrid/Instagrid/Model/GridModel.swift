//
//  GridModel.swift
//  Instagrid
//
//  Created by E&M Life Project on 27/11/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class GridModel {
    
    enum ConfigureOrientation {
        case whenViewDidLoad, whenViewWillTransition
    }
    
    /// makeSwipeLabelTextAndArrowImage : To return good arrow image and good Swipe Text value
    func makeSwipeLabelTextAndArrowImage(with configureOrientation: ConfigureOrientation) -> (String, UIImage?) {
        let isPortrait = (configureOrientation == .whenViewDidLoad) ? isOrientationPortraitWhenViewDidLoad() : isOrientationPortraitWhenWillTransition()
        if isPortrait {
            let arrowImage = UIImage(named: "arrow-up")
            let indicationLabelText = "Swipe up to share"
            return (indicationLabelText, arrowImage)
        } else {
            let arrowImage = UIImage(named: "arrow-left")
            let indicationLabelText = "Swipe left to share"
            return (indicationLabelText, arrowImage)
        }
    }
    
    /// isOrientationPortraitWhenViewDidLoad() : Return BOOL depend of the orientation
    func isOrientationPortraitWhenViewDidLoad() -> Bool {
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
    
    /// isOrientationPortraitWhenWillTransition() : Return BOOL depend of the orientation
    func isOrientationPortraitWhenWillTransition() -> Bool {
        return UIDevice.current.orientation.isPortrait
    }
    
    
    
    /// giveTransformationSwipeValue : Return the good translation on X or Y to the user swipe action
    func giveTransformationSwipeValue(translation: CGPoint) -> CGAffineTransform {
        let isPortrait = isOrientationPortraitWhenWillTransition()
        if isPortrait {
            return CGAffineTransform(translationX: 0, y: translation.y)
        } else {
            return CGAffineTransform(translationX: translation.x, y: 0)
        }
    }
    
    
    /// giveTheSizeOfTheScreen : return the size of the screen
    func giveTheSizeOfTheScreen() -> (CGFloat, CGFloat) {
        return (UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    
    /// slideLenghtIsSuffisant private func to check if the slideLenght is suffisant
    func isSlideLenghtIsSuffisant(translation: CGPoint) -> Bool {
        let translationToApply: CGFloat
        let isPortrait = isOrientationPortraitWhenWillTransition()
        if isPortrait {
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
