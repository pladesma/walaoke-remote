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
    private var _keyword = ""
    var keyword: String {
        set {
            _keyword = newValue
            params["keyword"] = _keyword
        }
        get {
            return _keyword
        }
    }
    
    private var _offset = 0
    var offset: Int {
        set {
            _offset = newValue
            params["list"] = _offset
        }
        get {
            return _offset
        }
    }
    
    private var _limit = 0
    var limit: Int {
        set {
            _limit = newValue
            params["num"] = _limit
        }
        get {
            return _limit
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "searchSongs"
        setupParams()
    }
    
    func setupParams() {
        params["keyword"] = ""
        params["list"] = 0
        params["num"] = 30
        params["findnext"] = false
    }

}
