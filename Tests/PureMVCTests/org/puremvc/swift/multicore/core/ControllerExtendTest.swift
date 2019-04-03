//
//  ControllerExtendTest.swift
//  PureMVC
//
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import PureMVC

class ControllerExtendTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructor() {
        let controllerExtend = ControllerExtend.getInstance(key: "Key1")
        View.removeView("Key1")
        
        XCTAssertNotNil(controllerExtend as! ControllerExtend, "Expecting controllerExtend not nil")
    }
    
    func testDeinit() {
        //To ensure all allocated resources gets released without any memory leak via each actor's deinit method
        let resource = Resource()
        var controllerExtend: ControllerExtend! = ControllerExtend.getInstance(key: "Key1") as? ControllerExtend
        controllerExtend.resource = resource
        
        XCTAssertTrue(resource.state == .ALLOCATED, "Expecting resource to be allocated")
        
        ControllerExtend.removeController("Key1")
        View.removeView("Key1") //since view also gets initialized
        controllerExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be relased")
    }
    
    func testRegisterCommandAndDeinit() {
        //To ensure all allocated resources gets released without any memory leak via each actor's deinit method
        let resource = Resource()
        var controllerExtend: ControllerExtend! = ControllerExtend.getInstance(key: "Key1") as? ControllerExtend
        controllerExtend.resource = resource
        
        //Observer has weak reference to Command/Mediator as they form cyclic references
        controllerExtend.registerCommand("ControllerTest", closure: {ControllerTestCommand()})
        
        Controller.removeController("Key1")
        View.removeView("Key1") //since view also gets initialized with the controller
        controllerExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be released")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
