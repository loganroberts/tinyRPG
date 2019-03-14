//
//  Extensions.swift
//  tinyRPG
//
//  Created by Logan Roberts on 3/8/19.
//  Copyright © 2019 Logan Roberts. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}


func getDefaults(name: String) -> Dictionary<String, Any> {
    var dictionary: [String: Any] = [:]
    if let url = Bundle.main.url(forResource: name, withExtension: "plist") {
        do {
            let data = try Data(contentsOf: url)
            dictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String : Any]
        } catch {
            print("No Plist Found")
        }
    }
    return dictionary
}
