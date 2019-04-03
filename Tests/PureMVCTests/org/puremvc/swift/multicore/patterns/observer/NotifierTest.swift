//
//  NotifierTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import PureMVC

class NotifierTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests notifier methods.
    */
    func testNotifier() {
        let facade = Facade.getInstance("notifierTest") { Facade(key: "notifierTest") }
        
        XCTAssertTrue(Facade.hasCore("notifierTest"), "Expecting Facade.hasCore('notifierTest') == true")
        
        let vo = FacadeTestVO(input: 5)
        facade.registerCommand("testCommand", closure: {FacadeTestCommand()})
        
        let notifier = Notifier()
        notifier.initializeNotifier("notifierTest")
        notifier.sendNotification("testCommand", body: vo)
        
        XCTAssertTrue(vo.result == 10, "Expecting vo.result == 10")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
