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
    public var connected = false
    
    private var client: TCPClient?
    
    private var currentId = 0
    
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
            print("Connected to server.")
            connected = true
            
            let defaults = UserDefaults.standard
            defaults.set(ip, forKey: "ip")
            defaults.set(port, forKey: "port")
            
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func browseSongs(offset: Int, limit: Int) -> Promise<Array<Song>> {
        return searchSongs(keyword: "", offset: offset, limit: limit)
    }
    
    public func searchSongs(keyword: String?, offset: Int, limit: Int) -> Promise<Array<Song>> {
        let command = SearchCommand(JSONString: "{}")
        command?.id = getNextId()
        command?.keyword = keyword != nil ? keyword! : ""
        command?.offset = offset
        command?.limit = limit
        
        let jsonString = command?.toJSONString()
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            print("Searched for songs.")
            
            var json = readResponse()
            // This should be a < comparison
            while json["id"] as? Int != command?.id {
                json = readResponse()
            }
            
            var songs = Array<Song>()
            
            if let results = json["result"] as? Array<[String: AnyObject]> {
                for dict in results {
                    let song = Song(JSON: dict)
                    songs.append(song!)
                }
            }
            
            return Promise(value: songs)
        }
    
        print(errmsg)
        return Promise(value: Array<Song>())
    }
    
    private func getNextId() -> Int {
        let nextId = currentId
        currentId += 1
        return nextId
    }
    
    private func readResponse() -> [String: Any] {
        var string = ""
        
        while !string.contains("<EOM>") {
            let response = client?.read(1024 * 10)
            if response != nil {
                if let str = String(bytes: response!, encoding: .utf8) {
                    string.append(str)
                }
            }
        }
        
        print(string)
        
        if let data = string.replacingOccurrences(of: "<EOM>", with: "").data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                return json
            } catch {
                print("Error serializing JSON.")
            }
        }
        
        return [String: Any]()
    }
    
    public func queueSongFirst(song: Song) -> Promise<Bool> {
        let command = QueueFirstCommand(JSONString: "{}")
        command?.sid = "\(song.sid!)"
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            let stringResponse = readResponse()
            print(stringResponse)
            
            print("Queued song first.")
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func queueSongLast(song: Song) -> Promise<Bool> {
        let command = QueueLastCommand(JSONString: "{}")
        command?.sid = "\(song.sid!)"
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            let stringResponse = readResponse()
            print(stringResponse)
            
            print("Queued song last.")
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func getPlaylist() -> Promise<Array<Song>> {
        let command = GetPlaylistCommand(JSONString: "{}")
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            print("Retrieved playlist.")
            
            var json = readResponse()
            // This should be a < comparison
            while json["id"] as? Int != command?.id {
                json = readResponse()
            }
            
            var songs = Array<Song>()
            
            if let results = json["result"] as? Array<[String: AnyObject]> {
                for dict in results {
                    let song = Song(JSON: dict)
                    songs.append(song!)
                }
            }
            
            return Promise(value: songs)
        }
    
        print(errmsg)
        return Promise(value: Array<Song>())
    }

    public func moveSongToFront(index: Int) -> Promise<Bool> {
        let command = MoveSongCommand(JSONString: "{}")
        command?.fromPosition = index
        command?.toPosition = 0
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func deleteSong(index: Int) -> Promise<Bool> {
        let command = DeleteSongCommand(JSONString: "{}")
        command?.index = index
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func play() -> Promise<Bool> {
        let command = PlayCommand(JSONString: "{}")
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
    
    public func skip() -> Promise<Bool> {
        let command = NextCommand(JSONString: "{}")
        command?.id = getNextId()
        
        let jsonString = command?.toJSONString()
        print(jsonString)
        let (success, errmsg) = client!.send(str: jsonString!.appending("<EOM>"))
        
        if (success) {
            return Promise(value: true)
        }
        
        print(errmsg)
        return Promise(value: false)
    }
}
