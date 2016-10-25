//
//  QueueLastCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class QueueLastCommand: Command {
    
    private var _sid = ""
    var sid: String {
        set {
            _sid = newValue
            params["SID"] = _sid as AnyObject?
        }
        get {
            return _sid
        }
    }

    required init?(map: Map) {
        super.init(map: map)
        
        method = "sendCommand"
        setupParams()
    }
    
    func setupParams() {
        params["command"] = "ADD_SONG" as AnyObject?
    }
}
