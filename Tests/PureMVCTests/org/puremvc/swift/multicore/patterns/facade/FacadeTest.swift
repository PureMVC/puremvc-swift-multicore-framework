//
//  FacadeTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import XCTest
@testable import PureMVC

/**
Test the PureMVC Facade class.

`@see org.puremvc.as3.multicore.patterns.facade.FacadeTestVO FacadeTestVO`

`@see org.puremvc.as3.multicore.patterns.facade.FacadeTestCommand FacadeTestCommand`
*/
class FacadeTest: XCTestCase {

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
        let facade: IFacade = Facade.getInstance("FacadeTestKey1", closure: {Facade(key: "FacadeTestKey1")})
        
        // test assertions
        XCTAssertNotNil(facade as? Facade, "Expecting instance not nil")
    }
    
    /**
    Tests Command registration and execution via the Facade.
    
    This test gets a Multiton Facade instance
    and registers the FacadeTestCommand class
    to handle 'FacadeTest' Notifcations.
    
    It then sends a notification using the Facade.
    Success is determined by evaluating
    a property on an object placed in the body of
    the Notification, which will be modified by the Command.
    */
    func testRegisterCommandAndSendNotification() {
        // Create the Facade, register the FacadeTestCommand to
        // handle 'FacadeTest' notifications
        let facade = Facade.getInstance("FacadeTestKey2", closure: { Facade(key: "FacadeTestKey2") })
        facade.registerCommand("FacadeTestNote", closure: { FacadeTestCommand()} )
        
        // Send notification. The Command associated with the event
        // (FacadeTestCommand) will be invoked, and will multiply
        // the vo.input value by 2 and set the result on vo.result
        let vo = FacadeTestVO(input: 32)
        facade.sendNotification("FacadeTestNote", body: vo, type: nil)
        
        // test assertions
        XCTAssertTrue(vo.result == 64, "Expecting vo.result == 64)")
    }
    
    /**
    Tests Command removal via the Facade.
    
    This test gets a Multiton Facade instance
    and registers the FacadeTestCommand class
    to handle 'FacadeTest' Notifcations. Then it removes the command.
    
    It then sends a Notification using the Facade.
    Success is determined by evaluating
    a property on an object placed in the body of
    the Notification, which will NOT be modified by the Command.
    */
    func testRegisterAndRemoveCommandAndSendNotification() {
        // Create the Facade, register the FacadeTestCommand to
        // handle 'FacadeTest' events
        let facade = Facade.getInstance("FacadeTestKey3", closure: {Facade(key: "FacadeTestKey3")}) as! Facade
        facade.registerCommand("FacadeTestNote", closure: {FacadeTestCommand()})
        facade.removeCommand("FacadeTestNote")
        
        // Send notification. The Command associated with the event
        // (FacadeTestCommand) will NOT be invoked, and will NOT multiply
        // the vo.input value by 2
        let vo = FacadeTestVO(input: 32)
        facade.sendNotification("FacadeTestNote", body: vo)
        
        // test assertions
        XCTAssertTrue(vo.result != 64, "Expecting vo.result != 64")
    }
    
    /**
    Tests the regsitering and retrieving Model proxies via the Facade.
    
    Tests `registerProxy` and `retrieveProxy` in the same test.
    These methods cannot currently be tested separately
    in any meaningful way other than to show that the
    methods do not throw exception when called. 
    */
    func testRegisterAndRetrieveProxy() {
        // register a proxy and retrieve it.
        let facade = Facade.getInstance("FacadeTestKey4", closure: {Facade(key: "FacadeTestKey4")})
        facade.registerProxy(Proxy(proxyName: "colors", data: ["red", "green", "blue"]))
        var proxy = facade.retrieveProxy("colors")
        
        // retrieve data from proxy
        var data: [String] = proxy?.data as! [String]
        
        // test assertions
        XCTAssertNotNil(data, "Expecting data not nil")
        XCTAssertNotNil(data as Array, "Expecting data is Array")
        XCTAssertTrue(data.count == 3, "Expecting data.count == 3")
        XCTAssertTrue(data[0] == "red", "Expecting data[0] == 'red'")
        XCTAssertTrue(data[1] == "green", "Expecting data[1] == 'green'")
        XCTAssertTrue(data[2] == "blue", "Expecting data[2] == 'blue'")
    }
    
    /**
    Tests the removing Proxies via the Facade.
    */
    func testRegisterAndRemoveProxy() {
        // register a proxy, remove it, then try to retrieve it
        let facade = Facade.getInstance("FacadeTestKey5") { Facade(key: "FacadeTestKey5") }
        let proxy: IProxy = Proxy(proxyName: "sizes", data: ["7", "13", "21"])
        facade.registerProxy(proxy)
        
        // remove the proxy
        let removedProxy = facade.removeProxy("sizes")
        
        // assert that we removed the appropriate proxy
        XCTAssertTrue(removedProxy?.proxyName == "sizes", "Expecting removedProxy.proxyName == 'sizes' \(String(describing: removedProxy?.proxyName))")
        
        // make sure we can no longer retrieve the proxy from the model
        let proxy2: IProxy? = facade.retrieveProxy("sizes")
        
        // test assertions
        XCTAssertNil(proxy2 as? Proxy, "Expecing proxy is nil")
    }
    
    /**
    Tests registering, retrieving and removing Mediators via the Facade.
    */
    func testRegisterRetrieveAndRemoveMediator() {
        // register a mediator, remove it, then try to retrieve it
        let facade = Facade.getInstance("FacadeTestKey6") { Facade(key: "FacadeTestKey6") }
        facade.registerMediator(Mediator(mediatorName: Mediator.NAME, viewComponent: Mediator()))
        
        // retrieve the mediator
        XCTAssertNotNil(facade.retrieveMediator(Mediator.NAME) as? Mediator, "Expecting mediator is not nil")
        
        // remove the mediator
        let removedMediator = facade.removeMediator(Mediator.NAME)
        
        // assert that we have removed the appropriate mediator
        XCTAssertTrue(removedMediator?.mediatorName == Mediator.NAME, "Expecting removedMediator.mediatorName == Mediator.NAME")
        
        // assert that the mediator is no longer retrievable
        XCTAssertNil(facade.retrieveMediator(Mediator.NAME) as? Mediator, "facade.retrieveMediator(Mediator.NAME) is nil")
    }
    
    /**
    Tests the hasProxy Method
    */
    func testHasProxy() {
        // register a Proxy
        let facade = Facade.getInstance("FacadeTestKey7", closure: { Facade(key: "FacadeTestKey7") })
        facade.registerProxy(Proxy(proxyName: "hasProxyTest", data: [1, 2, 3]))
        
        // assert that the model.hasProxy method returns true
        // for that proxy name
        XCTAssertTrue(facade.hasProxy("hasProxyTest"), "Expecting facade.hasProxy('hasProxyTest') == true")
    }
    
    /**
    Tests the hasMediator Method
    */
    func testHasMediator() {
        // register a Mediator
        let facade = Facade.getInstance("FacadeTestKey8") { Facade(key: "FacadeTestKey8") }
        facade.registerMediator(Mediator(mediatorName: "facadeHasMediatorTest", viewComponent: Mediator()))
        
        // assert that the facade.hasMediator method returns true
        // for that mediator name
        XCTAssertTrue(facade.hasMediator("facadeHasMediatorTest"), "Expecting facade.hasMediator('fasHasMediatorTest') == true")
        
        _ = facade.removeMediator("facadeHasMediatorTest")
        
        // assert that the facade.hasMediator method returns false
        // for that mediator name
        XCTAssertTrue(facade.hasMediator("facadeHasMediatorTest") == false, "Expecting facade.hasMediator('facadeHasMediatorTest') == false")
    }
    
    /**
    Test hasCommand method.
    */
    func testHasCommand() {
        // register the ControllerTestCommand to handle 'hasCommandTest' notes
        let facade = Facade.getInstance("FacadeTestKey10", closure: { Facade(key: "FacadeTestKey10") })
        facade.registerCommand("facadeHasCommandTest", closure: {FacadeTestCommand()})
        
        // test that hasCommand returns true for hasCommandTest notifications
        XCTAssertTrue(facade.hasCommand("facadeHasCommandTest"), "Expecting facade.hasCommand('facadeHasCommandTest') == true")
        
        // Remove the Command from the Controller
        facade.removeCommand("facadeHasCommandTest")
        
        // test that hasCommand returns false for hasCommandTest notifications
        XCTAssertTrue(facade.hasCommand("facadeHasCommandTest") == false, "Expecting facade.hasCommand('facadeHasCommandTest') == false")
    }
    
    /**
    Tests the hasCore and removeCore methods
    */
    func testHasCoreAndRemoveCore() {
        // assert that the Facade.hasCore method returns false first
        XCTAssertTrue(Facade.hasCore("FacadeTestKey11") == false, "Expecting facade.hasCore('FacadeTestKey11') == false")
        
        // register a Core
        _ = Facade.getInstance("FacadeTestKey11") { Facade(key: "FacadeTestKey11") }
        
        // assert that the Facade.hasCore method returns true now that a Core is registered
        XCTAssertTrue(Facade.hasCore("FacadeTestKey11"), "Expecting facade.hasCore('FacadeTestKey11') == true")
        
        // remove the Core
        Facade.removeCore("FacadeTestKey11")
        
        // assert that the Facade.hasCore method returns false now that the core has been removed.
        XCTAssertTrue(Facade.hasCore("FacadeTestKey11") == false, "Expecting facade.hasCore('FacadeTestKey11') == false")
    }
    
    
    func testInvalidNotification() {
        // register a Core
        let facade = Facade.getInstance("FacadeTestKey12") { Facade(key: "FacadeTestKey12") } as! Facade
        
        facade.sendNotification("InvalidNotificationName") //shouldn't crash
    }
    
    
    func testNotifierDeinit() {
        var facade: IFacade? = Facade.getInstance("FacadeTestKey13") { Facade(key: "FacadeTestKey13") } as! Facade
        
        let resource = Resource()
        facade!.registerProxy(ResourceProxy(data: resource))
        
        let resource2 = Resource()
        facade!.registerMediator(ResourceMediator(viewComponent: resource2))
        
        Facade.removeCore("FacadeTestKey13")
        facade = nil
        XCTAssertTrue(resource.state == .RELEASED, "Resource must be released")
        XCTAssertTrue(resource2.state == .RELEASED, "Resource must be released")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
