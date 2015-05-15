//
//  NotificationTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import PureMVC

/**
Test the PureMVC Notification class.

`@see org.puremvc.as3.multicore.patterns.observer.Notification Notification`
*/
class NotificationTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
    Tests setting and getting the name using Notification class accessor methods.
    */
    func testNameAccessors() {
        // Create a new Notification and use accessors to set the note name
        var note: INotification = Notification(name:"TestNote")
        
        //test assertions
        XCTAssertTrue(note.name == "TestNote", "Expecting note.name == 'TestNote'")
    }
    
    /**
    Tests setting and getting the body using Notification class accessor methods.
    */
    func testBodyAccessors() {
        // Create a new Notification and use accessors to set the body
        var note: INotification = Notification(name: "TestNote")
        note.body = 5
        
        // test assertions
        XCTAssertTrue((note.body as! Int) == 5, "Expecting note.body as Int == 5")
    }
    
    func testConstructor() {
        // Create a new Notification using the Constructor to set the note name and body
        var note:INotification = Notification(name: "TestNote", body:5, type:"TestNoteType")
        
        // test assertions
        XCTAssertTrue(note.name == "TestNote", "Expecting note.name == 'TestNote'")
        XCTAssertTrue((note.body as! Int) == 5, "Expecting note.body as Int == 5")
        XCTAssertTrue(note.type == "TestNoteType", "Expecting note.type == 'TestNoteType'")
    }
    
    /**
    Tests the toString method of the notification
    */
    func testDescription() {
        // Create a new Notification and use accessors to set the note name
        var note: INotification = Notification(name: "TestNote", body: [1, 3, 5], type: "TestType")
        var ts: String = "Notification Name: TestNote Optional([1, 3, 5]) Optional(\"TestType\")"
        
        // test assertions
        XCTAssertTrue(note.description() == ts, "Expecting note.description == '\(ts)'")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
