//
//  PlayCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit

class PlayCommand: Command {
    required init?(map: Map) {
        super.init(map: map)
        
        method = "sendCommand"
        setupParams()
    }
    
    func setupParams() {
        params["command"] = "PLAY"
        params["SID"] = ""
    }
}
