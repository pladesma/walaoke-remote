//
//  Library.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/23/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Darwin.C
import ObjectMapper

class Library: NSObject {
    public var ip: String?
    public var port: Int?
    
    var client: TCPClient?
    
    var currentId = 0
    var commands = Array<Command>()
    
    static let sharedInstance = Library()
    
    override private init() {
        
    }
    
    public func connectToServer() -> Promise<Bool> {
        if (ip == nil || port == nil) {
            print("nil ip or nil port")
            return Promise(value: false)
        }
        
        client = TCPClient(addr: ip!, port: port!)
        
        let (success, errmsg) = client!.connect(timeout: 10)
        
        if (success) {
            print("Successfully connected to server.")
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func searchSongs(keyword: String?) -> Promise<Array<Song>> {
        let searchCommand = SearchCommand(JSONString: "{}")
        searchCommand?.id = getNextId()
        searchCommand?.keyword = keyword != nil ? keyword! : ""
        
        commands.append(searchCommand!)
        
        let jsonString = searchCommand?.toJSONString()
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            print("Successfully searched for songs.")
            
            let response = client?.read(1024 * 10)
            
            if (response != nil) {
                if let str = String(bytes: response!, encoding: .utf8) {
                    let data = str.replacingOccurrences(of: "<EOM>", with: "").data(using: .utf8)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                        
                        var songs = Array<Song>()
                        
                        for dict in json["result"] as! Array<[String: AnyObject]> {
                            let song = Song(JSON: dict)
                            songs.append(song!)
                        }
                        
                        return Promise(value: songs)
                    } catch {
                        print("Error serializing JSON.")
                    }
                }
            }
        }
        
        print(errmsg)
        return Promise(value: Array<Song>())
    }
    
    func getNextId() -> Int {
        let nextId = currentId
        currentId += 1
        return nextId
    }
    
    public func browseSongs() -> Promise<Array<Song>> {
        return searchSongs(keyword: "")
    }
    
    public func queueSongFirst(song: Song) {
        
    }
    
    public func queueSongLast(song: Song) {
        
    }
    
    public func getPlaylist() -> Promise<Array<Song>> {
        return Promise(value: Array<Song>())
    }
    
}
