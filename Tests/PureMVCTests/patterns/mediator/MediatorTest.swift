//
//  MediatorTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import XCTest
@testable import PureMVC

/**
Test the PureMVC Mediator class.

`@see org.puremvc.swift.multicore.interfaces.IMediator IMediator`

`@see org.puremvc.swift.multicore.patterns.mediator.Mediator Mediator`
*/
class MediatorTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests getting the name using Mediator class accessor method.
    */
    func testNameAccessor() {
        // Create a new Mediator and use accessors to set the mediator name
        let mediator: Mediator = Mediator()
        
        // test assertions
        XCTAssertTrue(mediator.name == Mediator.NAME, "Expecting mediator.mediatorName == Mediator.NAME()")
    }
    
    /**
    Tests getting the name using Mediator class accessor method.
    */
    func testViewAccessor() {
        // Create a view object
        let view = Notification(name: "test", body: 4)
        
        // Create a new Proxy and use accessors to set the proxy name
        let mediator = Mediator(name: Mediator.NAME, viewComponent: view)
        
        // test assertions
        XCTAssertTrue(mediator.viewComponent === view, "Expecting mediator.viewComponent === view")
    }
    
    func testResourceMediator() {
        var facade: Facade? = Facade.getInstance("mediatorKey1", factory: {key in Facade(key: key)}) as? Facade
        let resource = Resource()
        
        facade?.registerMediator(ResourceMediator(viewComponent: resource))
        Facade.removeCore("mediatorKey1")
        facade = nil
        
        XCTAssertTrue(resource.state == .RELEASED, "Expecting resource.state == .RELEASED")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
