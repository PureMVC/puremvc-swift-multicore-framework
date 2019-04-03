//
//  FacadeExtendTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import PureMVC

class FacadeExtendTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConstructor() {
        var facadeExtend: FacadeExtend! = FacadeExtend.getInstance(key: "Key1") as? FacadeExtend
        
        XCTAssertNotNil(facadeExtend as FacadeExtend, "Expecting facadeExtend not nil")
        
        FacadeExtend.removeCore("Key1")
        facadeExtend = nil
    }
    
    func testDeinit() {
        let facadeResource = Resource()
        var facadeExtend: FacadeExtend! = (FacadeExtend.getInstance(key: "Key1") as! FacadeExtend)
        facadeExtend.resource = facadeResource
        
        XCTAssertTrue(facadeResource.state == .ALLOCATED, "Expecting resource to be allocated")
        
        let controllerResource = Resource()
        var controller: ControllerExtend! = (ControllerExtend.getInstance(key: "Key1") as! ControllerExtend)
        controller.resource = controllerResource
        
        let modelResource = Resource()
        var model: ModelExtend! = (ModelExtend.getInstance(key: "Key1") as! ModelExtend)
        model.resource = modelResource
        
        let viewResource = Resource()
        var view: ViewExtend! = (ViewExtend.getInstance(key: "Key1") as! ViewExtend)
        view.resource = viewResource
        
        controller.registerCommand("ControllerTest", closure: {ControllerTestCommand()}) //Observer has a weak reference to commands
        
        facadeExtend = nil
        controller = nil
        model = nil
        view = nil
        FacadeExtend.removeCore("Key1") //Facade.removeCore("Key1") //will work as well
        
        XCTAssertTrue(facadeResource.state == .RELEASED, "Expecting facadeResource to be relased")
        XCTAssertTrue(controllerResource.state == .RELEASED, "Expecting controllerResource to be released")
        XCTAssertTrue(modelResource.state == .RELEASED, "Expecting modelResource to be released")
        XCTAssertTrue(viewResource.state == .RELEASED, "Expecting modelResource to be released")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
