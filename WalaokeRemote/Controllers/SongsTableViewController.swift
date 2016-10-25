//
//  SongsTableViewController.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/24/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import Toast_Swift

class SongsTableViewController: UITableViewController {
        
    var songs = [Int: Song]()
    var sortedSongs = [Song]()
    var filteredSongs = [Song]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshSongs()
    }
    
    func refreshSongs() {
        if !Library.sharedInstance.connected {
            return
        }
        
        Library.sharedInstance.browseSongs().then { songs -> Void in
            self.processSongResults(songs: songs)
            self.tableView.reloadData()
        }.catch { error in
            self.view.makeToast("Failed to fetch songs.", duration: 2.0, position: .center)
        }
    }
    
    func processSongResults(songs: [Song]) {
        for song in songs {
            self.songs[song.sid!] = song
        }
        self.updateSortedSongs()
    }
    
    func updateSortedSongs() {
        var songs = Array(self.songs.values)
        songs.sort { (song1, song2) -> Bool in
            return song1.title! < song2.title!
        }
        
        sortedSongs = songs
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSongs.count
        }
        return sortedSongs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath)
        
        let song = songForRow(row: indexPath.row)

        cell.textLabel?.text = song.title
        
        return cell
    }
    
    func songForRow(row: Int) -> Song {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredSongs[row]
        } else {
            return sortedSongs[row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = songForRow(row: indexPath.row)
        queueSongLast(song: song)
    }
    
    func queueSongLast(song: Song) {
        Library.sharedInstance.queueSongLast(song: song).then { success -> Void in
            if success {
                self.view.makeToast("Song queued.", duration: 2.0, position: .center)
            } else {
                self.view.makeToast("Failed to queue song.", duration: 2.0, position: .center)
            }
            }.catch { error in
                self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }
}

extension SongsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        Library.sharedInstance.searchSongs(keyword: searchController.searchBar.text).then { songs -> Void in
            self.processSongResults(songs: songs)
            self.filterSongs(searchText: searchController.searchBar.text!)
            self.tableView.reloadData()
        }.catch { error in
            self.view.makeToast("Failed to fetch songs.", duration: 2.0, position: .center)
        }
    }
    
    func filterSongs(searchText: String) {
        filteredSongs = sortedSongs.filter { song in
            return song.title!.lowercased().contains(searchText.lowercased())
        }
    }
}
