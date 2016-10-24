//
//  Command.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/23/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class Command: Mappable {
    var params: Dictionary<String, AnyObject>?
    var method: String?
    var id: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        params <- map["params"]
        method <- map["method"]
        id <- map["id"]
    }
}
