//
//  ViewExtendTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import puremvc_swift_multicore_framework

class ViewExtendTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructor() {
        let viewExtend = ViewExtend.getInstance(key: "Key1")
        ViewExtend.removeView("Key1")
        
        XCTAssertNotNil(viewExtend as! ViewExtend, "Expecting viewExtend not nil")
    }
    
    func testDeinit() {
        let resource = Resource()
        var viewExtend: ViewExtend! = (ViewExtend.getInstance(key: "Key1") as! ViewExtend)
        viewExtend.resource = resource
        
        XCTAssertTrue(resource.state == .ALLOCATED, "Expecting resource to be allocated")
        
        ViewExtend.removeView("Key1")
        viewExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be relased")
    }
    
    func testRegisterMediatorAndDeinit() {
        let resource = Resource()
        var viewExtend: ViewExtend! = (ViewExtend.getInstance(key: "Key1") as! ViewExtend)
        
        viewExtend.registerMediator(ResourceMediator(viewComponent: resource))
        
        View.removeView("Key1")
        viewExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be released")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
