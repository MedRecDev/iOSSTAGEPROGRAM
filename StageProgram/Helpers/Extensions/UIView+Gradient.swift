//
//  UIView+Gradient.swift
//  StageProgram
//
//  Created by RajeevSingh on 23/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

extension UIView {
    
    func setGradientBackground(topColor: UIColor, bottomColor: UIColor) {
        let colorTop =  topColor.cgColor
        let colorBottom = bottomColor.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at:0)
    }
}
