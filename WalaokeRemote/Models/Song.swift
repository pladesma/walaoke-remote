//
//  Song.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/23/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import ObjectMapper

class Song: Mappable {
    var sid: Int?
    var title: String?
    var path: String?
    var author: String?
    var singer: String?
    var lyric: String?
    var contentType: String?
    var type: String?
    var downloadable: Bool?
    var downloaded: Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        sid <- map["sid"]
        title <- map["title"]
        path <- map["path"]
        author <- map["author"]
        singer <- map["singer"]
        lyric <- map["lyric"]
        contentType <- map["contentType"]
        type <- map["type"]
        downloadable <- map["downloadable"]
        downloaded <- map["downloaded"]
    }
}
