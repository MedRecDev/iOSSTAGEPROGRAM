//
//  CustomActivity.swift
//  StageProgram
//
//  Created by RajeevSingh on 08/07/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit

class CustomItem {

    let value: String

    required init(value: String) {
        self.value = value
    }

    func getValue() -> String {
        return self.value
    }
}

class CustomActivity: UIActivity {
    
    override class var activityCategory: UIActivity.Category {
        return .share
    }

    override var activityType: UIActivity.ActivityType? {
        return .postToFacebook
    }

    override var activityTitle: String? {
        return "Custom"
    }

    override var activityImage: UIImage? {
        return UIImage(named: "play_icon")
    }

    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if activityItems.count == 1 && activityItems[0] is CustomItem {
            return true
        }
        return false
    }

    var textToShare: String?

    override func prepare(withActivityItems activityItems: [Any]) {
        if let activityItem = activityItems.first as? CustomItem {
            self.textToShare = activityItem.getValue()
        }
    }

    override func perform() {
        // perform your custom activity with `textToShare`
        activityDidFinish(true)
    }
}

extension UIActivity.ActivityType {
    static let customuiactivity = UIActivity.ActivityType("com.stageprogram.sp.customuiactivity")
}
