//
//  Constants.swift
//  Hash Me
//
//  Created by Eric Klose on 3/12/16.
//  Copyright © 2016 Eric Klose. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

let KEY_UID = "uid"

//Segues
let SEGUE_LOGGED_IN = "loggedIn"

//Status Codes
let STATUS_ACCOUNT_NONEXIST = -8

extension Dictionary where Value : Equatable {
    func allKeysForValue(val : Value) -> [Key] {
        return self.filter { $1 == val }.map { $0.0 }
    }
}

typealias DownloadComplete = () -> ()