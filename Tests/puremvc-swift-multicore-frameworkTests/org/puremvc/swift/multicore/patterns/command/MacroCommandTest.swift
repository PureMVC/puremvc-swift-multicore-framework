//
//  MacroCommandTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import puremvc_swift_multicore_framework

/**
Test the PureMVC SimpleCommand class.

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestVO MacroCommandTestVO`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommandTestCommand MacroCommandTestCommand`
*/
class MacroCommandTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests operation of a `MacroCommand`.
    
    This test creates a new `Notification`, adding a
    `MacroCommandTestVO` as the body.
    It then creates a `MacroCommandTestCommand` and invokes
    its `execute` method, passing in the
    `Notification`.
    
    The `MacroCommandTestCommand` has defined an
    `initializeMacroCommand` method, which is
    called automatically by its constructor. In this method
    the `MacroCommandTestCommand` adds 2 SubCommands
    to itself, `MacroCommandTestSub1Command` and
    `MacroCommandTestSub2Command`.
    
    The `MacroCommandTestVO` has 2 result properties,
    one is set by `MacroCommandTestSub1Command` by
    multiplying the input property by 2, and the other is set
    by `MacroCommandTestSub2Command` by multiplying
    the input property by itself.
    
    Success is determined by evaluating the 2 result properties
    on the `MacroCommandTestVO` that was passed to
    the `MacroCommandTestCommand` on the Notification
    body.
    */
    func testMacroCommandExecute() {
        // Create the VO
        let vo = MacroCommandTestVO(input: 5)
        
        // Create the Notification (note)
        let notification = Notification(name: "my", body: vo)
        
        // Create the SimpleCommand
        let command = MacroCommandTestCommand()
        command.initializeNotifier("test")
        
        // Execute the SimpleCommand
        command.execute(notification)
        
        // test assertions
        XCTAssertTrue((vo.result1!) == 10, "Expecting vo.result1 == 10")
        XCTAssertTrue((vo.result2!) == 25, "Expecting vo.result2 == 25")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
