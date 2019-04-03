//
//  SimpleCommandTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import PureMVC

/**
Test the PureMVC SimpleCommand class.

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommandTestVO SimpleCommandTestVO`

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommandTestCommand SimpleCommandTestCommand`
*/
class SimpleCommandTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests the `execute` method of a `SimpleCommand`.
    
    This test creates a new `Notification`, adding a
    `SimpleCommandTestVO` as the body.
    It then creates a `SimpleCommandTestCommand` and invokes
    its `execute` method, passing in the note.
    
    Success is determined by evaluating a property on the
    object that was passed on the Notification body, which will
    be modified by the SimpleCommand.
    */
    func testSimpleCommandExecute() {
        // Create the VO
        let vo:SimpleCommandTestVO = SimpleCommandTestVO(input: 5)
        
        // Create the Notification (note)
        let note = Notification(name: "SimpleCommandTestNote", body: vo)
        
        // Create the SimpleCommand
        let command: SimpleCommandTestCommand = SimpleCommandTestCommand()
        
        // Execute the SimpleCommand
        command.execute(note)
        
        // test assertions
        XCTAssertTrue(vo.result == 10, "Expecting v.result == 10")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
