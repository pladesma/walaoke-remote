//
//  GetPlaylistCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class GetPlaylistCommand: Command {
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "getPlaylist"
    }
}
