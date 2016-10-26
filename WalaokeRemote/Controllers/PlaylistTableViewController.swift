//
//  PlaylistTableViewController.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/24/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Toast_Swift

class PlaylistTableViewController: UITableViewController {
    
    @IBOutlet weak var skipButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    var songs = [Song]()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupSpinner()
        setupNavigationBarButtons()
        
        refreshControl?.addTarget(self, action: #selector(SongsTableViewController.handleRefresh), for: .valueChanged)
    }
    
    private func setupTabBar() {
        self.navigationController?.tabBarController?.tabBar.items?[0].image = UIImage.fontAwesomeIcon(name: .list, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        self.navigationController?.tabBarController?.tabBar.items?[1].image = UIImage.fontAwesomeIcon(name: .music, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
        self.navigationController?.tabBarController?.tabBar.items?[2].image = UIImage.fontAwesomeIcon(name: .cog, textColor: UIColor.black, size: CGSize(width: 30, height: 30))
    }
    
    private func setupSpinner() {
        spinner.color = UIColor.blue
        spinner.hidesWhenStopped = true
        spinner.center = view.center
        view.addSubview(spinner)
    }
    
    private func setupNavigationBarButtons() {
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        skipButton.setTitleTextAttributes(attributes, for: .normal)
        skipButton.title = String.fontAwesomeIcon(name: .forward)
        
        playButton.setTitleTextAttributes(attributes, for: .normal)
        playButton.title = String.fontAwesomeIcon(name: .play)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        refreshPlaylist()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshPlaylist()
    }
    
    private func refreshPlaylist() {
        if !Library.sharedInstance.connected {
            return
        }
        
        spinner.startAnimating()
        
        Library.sharedInstance.getPlaylist().then { songs -> Void in
            self.songs = songs
            self.tableView.reloadData()
        }.always {
            self.spinner.stopAnimating()
        }.catch { error in
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)

        let song = songs[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1). \(song.title!)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let moveFront = UITableViewRowAction(style: .normal, title: "Move to Front") { action, index in
            self.moveToFront(index: index.row)
        }
        moveFront.backgroundColor = UIColor.yellow
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.delete(index: index.row)
        }
        delete.backgroundColor = UIColor.red
        
        return [moveFront, delete]
    }
    
    private func moveToFront(index: Int) {
        spinner.startAnimating()
        
        Library.sharedInstance.moveSongToFront(index: index).then { success -> Void in
            if (success) {
                self.refreshPlaylist()
            }
        }.catch { error in
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }
    
    private func delete(index: Int) {
        spinner.startAnimating()
        
        Library.sharedInstance.deleteSong(index: index).then { success -> Void in
            if (success) {
                self.refreshPlaylist()
            }
        }.catch { error in
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    @IBAction func tappedPlayButton(_ sender: AnyObject) {
        Library.sharedInstance.play().then { success -> Void in
            if success {
                self.refreshPlaylist()
            }
        }.catch { error in
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }
    
    @IBAction func tappedSkipButton(_ sender: AnyObject) {
        Library.sharedInstance.skip().then { success -> Void in
            if success {
                self.refreshPlaylist()
            }
        }.catch { error in
            self.view.makeToast(error.localizedDescription, duration: 2.0, position: .center)
        }
    }
}
