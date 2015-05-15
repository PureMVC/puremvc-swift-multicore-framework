//
//  ModelExtendTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import PureMVC

class ModelExtendTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructor() {
        var modelExtend = ModelExtend.getInstance("Key1") as! ModelExtend
        
        XCTAssertNotNil(modelExtend as ModelExtend, "Expecting modelExtend not nil")
    }
    
    func testDeinit() {
        var resource = Resource()
        var modelExtend: ModelExtend! = ModelExtend.getInstance("Key1") as! ModelExtend
        modelExtend.resource = resource
        
        XCTAssertTrue(resource.state == .ALLOCATED, "Expecting resource to be allocated")
        
        ModelExtend.removeModel("Key1")
        modelExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be relased")
    }
    
    func testRegisterProxyAndDeinit() {
        var resource = Resource()
        var modelExtend: ModelExtend! = ModelExtend.getInstance("Key1") as! ModelExtend
        
        modelExtend.registerProxy(ResourceProxy(data: resource))
        
        Model.removeModel("Key1")
        modelExtend = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource to be released")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
