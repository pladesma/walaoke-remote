//
//  MoveSongCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class MoveSongCommand: Command {
    private var _fromPosition: Int = 0
    var fromPosition: Int {
        set {
            _fromPosition = newValue
            params["fromPos"] = _fromPosition
        }
        get {
            return _fromPosition
        }
    }
    
    private var _toPosition: Int = 0
    var toPosition: Int {
        set {
            _toPosition = newValue
            params["toPos"] = _toPosition
        }
        get {
            return _toPosition
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "moveSongInPlaylist"
        setupParams()
    }
    
    func setupParams() {
        params["fromPos"] = 0
        params["toPos"] = 0
    }
}
