//
//  GridModel.swift
//  Instagrid
//
//  Created by E&M Life Project on 17/12/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import Foundation

class GridModel {
    var swipeLengthIsEnough = false
    var imagePickerAllowsEditing: Bool {
        return false
    }
    
    func giveGoodArrowAndLabel(isPortrait: Bool) -> (String, String) {
        if isPortrait {
            return ("arrow-up", "Swipe up to share")
        } else {
            return ("arrow-left", "Swipe left to share")
        }
    }
    
    func alertMessageMissingImage() -> (String, String) {
        return ("PARTAGE IMPOSSIBLE", "Vous devez remplir chaque image avant de partager")
    }
}
