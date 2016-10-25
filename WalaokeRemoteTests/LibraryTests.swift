//
//  LibraryTests.swift
//  WalaokeRemote
//
//  Created by Peter Ladesma on 10/25/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import XCTest
@testable import WalaokeRemote

class LibraryTests: XCTestCase {
    let ip = "192.168.2.7"
    let port = 8888
    
    var library: Library?
        
    override func setUp() {
        super.setUp()
        
        library = Library.sharedInstance
        library?.ip = ip
        library?.port = port
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBrowseSongs() {
        library?.connectToServer().then { connected -> Void in
            if (connected) {
                self.library?.browseSongs().then{ songs -> Void in
                    XCTAssert(songs.count > 0)
                }.catch {error in
                    XCTFail(error.localizedDescription)
                }
            } else {
                XCTFail("Failed to connect to server.")
            }
        }.catch { error in
            XCTFail(error.localizedDescription)
        }
    }
    
}
