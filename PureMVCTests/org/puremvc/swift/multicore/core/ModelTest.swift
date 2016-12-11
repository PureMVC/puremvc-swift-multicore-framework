//
//  ModelTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
import PureMVC

/**
Test the PureMVC Model class.
*/
class ModelTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetInstance() {
        // Test Factory Method
        let model: IModel = Model.getInstance("ModelTestKey1") { Model(key: "ModelTestKey1") }
        
        // test assertions
        XCTAssertNotNil(model as? Model, "Expecting instance not null")
    }
    
    /**
    Tests the proxy registration and retrieval methods.
    
    Tests `registerProxy` and `retrieveProxy` in the same test.
    These methods cannot currently be tested separately
    in any meaningful way other than to show that the
    methods do not throw exception when called. 
    */
    func testRegisterAndRetrieveProxy() {
        // register a proxy and retrieve it.
        let model: IModel = Model.getInstance("ModelTestKey2") { Model(key: "ModelTestKey2") }
        model.registerProxy(Proxy(proxyName: "colors", data: ["red", "green", "blue"]))
        let proxy: Proxy = model.retrieveProxy("colors") as! Proxy
        var data: Array<String> = proxy.data as! Array<String>
        
        // test assertions
        XCTAssertNotNil(data, "Expecting data not nil")
        XCTAssertTrue(data.count == 3, "Expecting data.length == 3")
        XCTAssertTrue(data[0] == "red", "Expecting data[0] == 'red'")
        XCTAssertTrue(data[1] == "green", "Expecting data[1] == 'green'")
        XCTAssertTrue(data[2] == "blue", "Expecting data[0] == 'blue'")
    }
    
    //Test with tuple
    func testRegisterAndRetrieveProxy2() {
        let model: IModel = Model.getInstance("ModelTestKey2") { Model(key: "ModelTestKey2") }
        model.registerProxy(Proxy(proxyName: "tuple", data: (1, "abc", false)))
        
        let proxy: Proxy = model.retrieveProxy("tuple") as! Proxy
        let data: (Int, String, Bool)  = proxy.data as! (Int, String, Bool)
        
        XCTAssertTrue(data.0 == 1, "Expecting data.0 == 1")
        XCTAssertTrue(data.1 == "abc", "Expecting data.1 == 'abc'")
        XCTAssertTrue(data.2 == false, "Expecting data.2 == false")
    }
    
    /**
    Tests the proxy removal method.
    */
    func testRegisterAndRemoveProxy() {
        // register a proxy, remove it, then try to retrieve it
        let model: IModel = Model.getInstance("ModelTestKey3") { Model(key: "ModelTestKey3") }
        let proxy: IProxy = Proxy(proxyName: "sizes", data: ["7", "13", "21"])
        model.registerProxy(proxy)
        
        // remove the proxy
        let removedProxy = model.removeProxy("sizes")
        
        // assert that we removed the appropriate proxy
        XCTAssertTrue(removedProxy!.proxyName == "sizes", "Expecting removedProxy.getProxyName() == 'sizes'")
        
        // ensure that the proxy is no longer retrievable from the model
        let nilProxy = model.retrieveProxy("sizes")
        
        // test assertions
        XCTAssertTrue(nilProxy == nil, "Expecting proxy is nil")
    }
    
    /**
    Tests the hasProxy Method
    */
    func testHasProxy() {
        // register a proxy
        let model: IModel = Model.getInstance("ModelTestKey4") { Model(key: "ModelTestKey4") }
        let proxy: IProxy = Proxy(proxyName: "aces", data: ["clubs", "spades", "hearts", "diamonds"])
        model.registerProxy(proxy)
        
        // assert that the model.hasProxy method returns true
        // for that proxy name
        XCTAssertTrue(model.hasProxy("aces"), "Expecting model.hasProxy('aces') == true")
        
        // remove the proxy
        _ = model.removeProxy("aces")
        
        // assert that the model.hasProxy method returns false
        // for that proxy name
        XCTAssertTrue(model.hasProxy("aces") == false, "Expecting model.hasProxy('aces') == false")
    }
    
    /**
    Tests that the Model calls the onRegister and onRemove methods
    */
    func testOnRegisterAndOnRemove() {
        // Get a Multiton View instance
        let model: IModel = Model.getInstance("ModelTestKey4") { Model(key: "ModelTestKey4") }
        
        // Create and register the test mediator
        var proxy: IProxy = ModelTestProxy()
        model.registerProxy(proxy)
        
        // assert that onRegsiter was called, and the proxy responded by setting its data accordingly
        XCTAssertTrue((proxy.data as! String) == ModelTestProxy.ON_REGISTER_CALLED, "Expecting proxy.data == ModelTestProxy.ON_REGISTER_CALLED")
        
        // Remove the component
        _ = model.removeProxy(ModelTestProxy.NAME)
        
        // assert that onRemove was called, and the proxy responded by setting its data accordingly
        XCTAssertTrue((proxy.data as! String) == ModelTestProxy.ON_REMOVE_CALLED, "Expecting proxy.data == ModelTestProxy.ON_REMOVE_CALLED \(proxy.data)")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
