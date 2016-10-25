//
//  PlaylistTableViewController.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/24/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import FontAwesome_swift

class PlaylistTableViewController: UITableViewController {
    
    var songs = [Song]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        refreshControl?.addTarget(self, action: #selector(SongsTableViewController.handleRefresh), for: .valueChanged)
    }
    
    private func setupTabBar() {
        self.navigationController?.tabBarController?.tabBar.items?[0].image = UIImage.fontAwesomeIcon(name: .list, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        self.navigationController?.tabBarController?.tabBar.items?[1].image = UIImage.fontAwesomeIcon(name: .music, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        self.navigationController?.tabBarController?.tabBar.items?[2].image = UIImage.fontAwesomeIcon(name: .cog, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshPlaylist()
        refreshControl.endRefreshing()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshPlaylist()
    }
    
    func refreshPlaylist() {
        if !Library.sharedInstance.connected {
            return
        }
        
        Library.sharedInstance.getPlaylist().then { songs -> Void in
            self.songs = songs
            self.tableView.reloadData()
        }.catch { error in
            self.view.makeToast("Failed to fetch songs.", duration: 2.0, position: .center)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)

        let song = songs[indexPath.row]
        cell.textLabel?.text = song.title

        return cell
    }

}
