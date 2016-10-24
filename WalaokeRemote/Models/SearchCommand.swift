//
//  SearchCommand.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/23/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchCommand: Command {
    var keyword: String?
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "searchSongs"
    }
}
