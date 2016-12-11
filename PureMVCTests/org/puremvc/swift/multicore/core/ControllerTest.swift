//
//  ControllerTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import PureMVC

/**
Test the PureMVC Controller class.

`@see org.puremvc.swift.multicore.core.controller.ControllerTestVO ControllerTestVO`

`@see org.puremvc.swift.multicore.core.controller.ControllerTestCommand ControllerTestCommand`
*/
class ControllerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests the Controller Multiton Factory Method
    */
    func testGetInstance() {
        // Test Factory Method
        let controller: IController = Controller.getInstance("ControllerTestKey1") { Controller(key: "ControllerTestKey1") }
        
        // test assertions
        XCTAssertNotNil(controller as? Controller, "Expecting instance not nil")
    }
    
    /**
    Tests Command registration and execution.
    
    This test gets a Multiton Controller instance
    and registers the ControllerTestCommand class
    to handle 'ControllerTest' Notifications.
    
    It then constructs such a Notification and tells the
    Controller to execute the associated Command.
    Success is determined by evaluating a property
    on an object passed to the Command, which will
    be modified when the Command executes.
    */
    func testRegisterAndExecuteCommand() {
        // Create the controller, register the ControllerTestCommand to handle 'ControllerTest' notes
        let controller: IController = Controller.getInstance("ControllerTestKey1") { Controller(key: "ControllerTestKey1") }
        controller.registerCommand("ControllerTest", closure: {ControllerTestCommand()})
        
        // Create a 'ControllerTest' note
        let vo: ControllerTestVO = ControllerTestVO(input: 12)
        let note = Notification(name: "ControllerTest", body: vo)
        
        // Tell the controller to execute the Command associated with the note
        // the ControllerTestCommand invoked will multiply the vo.input value
        // by 2 and set the result on vo.result
        controller.executeCommand(note)
        
        // test assertions
        XCTAssertTrue(vo.result == 24, "Expecting vo.result == 24")
        XCTAssertEqual(vo.result, 24, "my test")
    }
    
    /**
    Tests Command registration and removal.
    
    Tests that once a Command is registered and verified
    working, it can be removed from the Controller.
    */
    func testRegisterAndRemoveCommand() {
        // Create the controller, register the ControllerTestCommand to handle 'ControllerTest' notes
        let controller: IController = Controller.getInstance("ControllerTestKey3") { Controller(key: "ControllerTestKey3") }
        controller.registerCommand("ControllerRemoveTest", closure: {ControllerTestCommand()})
        
        // Create a 'ControllerTest' note
        let vo = ControllerTestVO(input: 12)
        let note = Notification(name: "ControllerRemoveTest", body: vo)
        
        // Tell the controller to execute the Command associated with the note
        // the ControllerTestCommand invoked will multiply the vo.input value
        // by 2 and set the result on vo.result
        controller.executeCommand(note)
        
        // test assertions
        XCTAssertTrue(vo.result == 24, "Expecting vo.result == 24")
        
        // Reset result
        vo.result = 0
        
        // Remove the Command from the Controller
        controller.removeCommand("ControllerRemoveTest")
        
        // Tell the controller to execute the Command associated with the
        // note. This time, it should not be registered, and our vo result
        // will not change
        controller.executeCommand(note)
        
        // test assertions
        XCTAssertTrue(vo.result == 0, "Expecting vo.result == 0")
    }
    
    /**
    Test hasCommand method.
    */
    func testHasCommand() {
        // register the ControllerTestCommand to handle 'hasCommandTest' notes
        let controller = Controller.getInstance("ControllerTestKey4") { Controller(key: "ControllerTestKey4") }
        controller.registerCommand("hasCommandTest", closure: {ControllerTestCommand()})
        
        // test that hasCommand returns true for hasCommandTest notifications
        XCTAssertTrue(controller.hasCommand("hasCommandTest"), "Expecting controller.hasCommand('hasCommandTest') == true")
        
        // Remove the Command from the Controller
        controller.removeCommand("hasCommandTest")
        
        // test that hasCommand returns false for hasCommandTest notifications
        XCTAssertTrue(controller.hasCommand("hasCommandTest") == false, "Expecting controller.hasCommand('hasCommandTest') == false")
    }
    
    /**
    Tests Removing and Reregistering a Command
    
    Tests that when a Command is re-registered that it isn't fired twice.
    This involves, minimally, registration with the controller but
    notification via the View, rather than direct execution of
    the Controller's executeCommand method as is done above in
    testRegisterAndRemove. The bug under test was fixed in AS3 Standard
    Version 2.0.2. If you run the unit tests with 2.0.1 this
    test will fail.
    */
    func testReregisterAndExecuteCommand() {
        // Fetch the controller, register the ControllerTestCommand2 to handle 'ControllerTest2' notes
        let controller = Controller.getInstance("ControllerTestKey5") { Controller(key: "ControllerTestKey5") }
        controller.registerCommand("ControllerTest2", closure: {ControllerTestCommand2()})
        
        // Remove the Command from the Controller
        controller.removeCommand("ControllerTest2")
        
        // Re-register the Command with the Controller
        controller.registerCommand("ControllerTest2", closure: {ControllerTestCommand2()})
        
        // Create a 'ControllerTest2' note
        let vo = ControllerTestVO(input: 12)
        let note = Notification(name: "ControllerTest2", body: vo)
        
        // retrieve a reference to the View from the same core.
        let view = View.getInstance("ControllerTestKey5") { View(key: "ControllerTestKey5") }
        
        // send the Notification
        view.notifyObservers(note)
        
        // test assertions
        // if the command is executed once the value will be 24
        XCTAssertTrue(vo.result == 24, "Expecting vo.result == 24")
        
        // Prove that accumulation works in the VO by sending the notification again
        view.notifyObservers(note)
        
        // if the command is executed twice the value will be 48
        XCTAssertTrue(vo.result == 48, "Expecting vo.result == 48")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
