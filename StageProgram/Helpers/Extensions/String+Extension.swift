//
//  String+Extension.swift
//  StageProgram
//
//  Created by RajeevSingh on 10/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        guard self != nil else { return false }
     
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8}$")
        return passwordTest.evaluate(with: self)
    }
}
