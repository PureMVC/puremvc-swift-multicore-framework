//
//  ProxyTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import puremvc_swift_multicore_framework

/**
Test the PureMVC Proxy class.

`@see org.puremvc.swift.multicore.interfaces.IProxy IProxy`

`@see org.puremvc.swift.multicore.patterns.proxy.Proxy Proxy`
*/
class ProxyTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests getting the name using Proxy class accessor method. Setting can only be done in constructor.
    */
    func testNameAccessor() {
        // Create a new Proxy and use accessors to set the proxy name
        let proxy: Proxy = Proxy(proxyName: "TestProxy", data: nil)
        
        // test assertions
        XCTAssertTrue(proxy.proxyName == "TestProxy", "Expecting proxy.proxyName == 'TestProxy'")
    }
    
    /**
    Tests setting and getting the data using Proxy class accessor methods.
    */
    func testDataAccessors() {
        // Create a new Proxy and use accessors to set the data
        let proxy: Proxy = Proxy(proxyName: "colors", data: nil)
        proxy.data = ["red", "green", "blue"]
        
        var data: [String] = proxy.data as! [String]
        
        // test assertions
        XCTAssertTrue(data.count == 3, "Expecting data.count == 3")
        XCTAssertTrue(data[0] == "red", "Expecting data[0] == 'red'")
        XCTAssertTrue(data[1] == "green", "Expecting data[1] == 'green'")
        XCTAssertTrue(data[2] == "blue", "Expecting data[2] == 'blue'")
    }
    
    /**
    Tests setting the name and body using the Notification class Constructor.
    */
    func testConstructor() {
        // Create a new Proxy using the Constructor to set the name and data
        let proxy: Proxy = Proxy(proxyName: "colors", data: ["red", "green", "blue"])
        
        var data: [String] = proxy.data as! [String]
        
        // test assertions
        XCTAssertNotNil(proxy, "Expecting proxy not nil")
        XCTAssertTrue(proxy.proxyName == "colors", "Expecting proxy.proxyName == 'colors'")
        XCTAssertTrue(data.count == 3, "Expecting data.count == 3")
        XCTAssertTrue(data[0] == "red", "Expecting data[0] == 'red'")
        XCTAssertTrue(data[1] == "green", "Expecting data[1] == 'green'")
        XCTAssertTrue(data[2] == "blue", "Expecting data[2] == 'blue'")
    }
    
    func testDeinit() {
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
