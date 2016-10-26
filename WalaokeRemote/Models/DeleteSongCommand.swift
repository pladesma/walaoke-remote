//
//  DeleteSongCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class DeleteSongCommand: Command {
    private var _index: Int = 0
    var index: Int {
        set {
            _index = newValue
            params["index"] = _index
        }
        get {
            return _index
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "deleteSongInPlaylist"
        setupParams()
    }
    
    func setupParams() {
        params["index"] = 0
    }
}
