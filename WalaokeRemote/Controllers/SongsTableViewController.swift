//
//  SongsTableViewController.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/24/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController {
    var songs = Array<Song>()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Library.sharedInstance.browseSongs().then { songs -> Void in
            self.songs = songs
            self.tableView.reloadData()
        }.catch { error in
            let alert = UIAlertController(title: "Error", message: "Failed to fetch songs.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        let song = songs[indexPath.row]
        cell.textLabel?.text = song.singer
        cell.detailTextLabel?.text = song.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songs[indexPath.row]
        Library.sharedInstance.queueSongLast(song: song)
    }
}
