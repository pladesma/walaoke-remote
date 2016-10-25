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
            params["keyword"] = _keyword as AnyObject?
        }
        get {
            return _keyword
        }
    }
    
    private var _offset = 0
    var offset: Int {
        set {
            _offset = newValue
            params["list"] = _offset as AnyObject?
        }
        get {
            return _offset
        }
    }
    
    required init?(map: Map) {
        super.init(map: map)
        
        method = "searchSongs"
        setupParams()
    }
    
    func setupParams() {
        params["keyword"] = "" as AnyObject?
        params["list"] = 0 as AnyObject?
        params["num"] = 30 as AnyObject?
        params["findnext"] = false as AnyObject?
    }

}
