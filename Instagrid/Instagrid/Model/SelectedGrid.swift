//
//  SelectedGrid.swift
//  ohmyGymProject
//
//  Created by E&M Life Project on 25/11/2019.
//  Copyright © 2019 Erwan PASTE. All rights reserved.
//

import UIKit

class SelectedGrid {
    
    var gridStyle: SelectedGridStyle = .square {
        didSet {
            setStyle(gridStyle)
        }
    }
    
    enum SelectedGridStyle {
        case square, rectangleUp, rectangleDown
    }
    
    
    private func setStyle(_ gridStyle: SelectedGridStyle) {
        switch gridStyle {
        case .square:
            // code here
            print("Choix 1 Carre: code à ajouter ici")
        case .rectangleUp:
            print("Choix 2 Rectangle Haut: code à ajouter ici")
        case .rectangleDown:
            print("Choix 3 Rectangle bas: code à ajouter ici")
        }
    }
} 
