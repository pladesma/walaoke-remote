//
//  WalaokeRemoteTests.swift
//  WalaokeRemoteTests
//
//  Created by Peter Ladesma on 10/17/16.
//  Copyright © 2016 Peter Ladesma. All rights reserved.
//

import XCTest
@testable import WalaokeRemote

class CommandTests: XCTestCase {
    var command: Command?
    var searchCommand: SearchCommand?
    
    override func setUp() {
        super.setUp()
        
        command = Command(JSONString: "{\"id\":0}")
        searchCommand = SearchCommand(JSONString: "{\"id\": 0}")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCommandConstruction() {
        XCTAssertEqual(command?.id, 0)
        
        let jsonString = command?.toJSONString()
        XCTAssertEqual(jsonString, "{\"id\":0}")
    }
    
    func testCommandPropertyChanges() {
        command?.method = "method"
        
        let jsonString = command?.toJSONString()
        XCTAssertEqual(jsonString, "{\"id\":0,\"method\":\"method\"}")
    }
    
    func testSearchCommandConstruction() {
        XCTAssertEqual(searchCommand?.method, "searchSongs")
        
        let jsonString = searchCommand?.toJSONString()
        XCTAssertEqual(jsonString, "{\"id\":0,\"method\":\"searchSongs\"}")
    }
    
}
