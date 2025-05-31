//
//  ObserverTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import XCTest
@testable import PureMVC

/**
Tests PureMVC Observer class.

Since the Observer encapsulates the interested object's
callback information, there are no getters, only setters.
It is, in effect write-only memory.

Therefore, the only way to test it is to set the
notification method and context and call the notifyObserver
method.
*/
class ObserverTest: XCTestCase {

    /**
    A test variable that proves the notify method was
    executed with 'this' as its exectution context
    */
    var observerTestVar: Int = 0
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests observer class when initialized by accessor methods.
    */
    func testObserverAccessors() {
        // Create observer
        let observer:Observer = Observer(notifyMethod: nil, notifyContext: nil)
        observer.notifyMethod = self.observerTestMethod
        observer.notifyContext = self
        
        // create a test event, setting a payload value and notify
        // the observer with it. since the observer is this class
        // and the notification method is observerTestMethod,
        // successful notification will result in our local
        // observerTestVar being set to the value we pass in
        // on the note body.
        let note = Notification(name: "ObserverTestNote", body: 10)
        observer.notifyObserver(note)
        
        // test assertions
        XCTAssertTrue(self.observerTestVar == 10, "Expecting observerTestVar = 10")
    }
    
    /**
    Tests observer class when initialized by constructor.
    */
    func testObserverConstructor() {
        // Create observer passing in notification method and context
        let observer:Observer = Observer(notifyMethod: self.observerTestMethod, notifyContext: self)
        
        // create a test note, setting a body value and notify
        // the observer with it. since the observer is this class
        // and the notification method is observerTestMethod,
        // successful notification will result in our local
        // observerTestVar being set to the value we pass in
        // on the note body.
        let note = Notification(name: "ObserverTestNote", body: 5)
        observer.notifyObserver(note)
        
        // test assertions
        XCTAssertTrue(self.observerTestVar == 5, "Expecting observerTestVar = 5")
    }
    
    /**
    Tests the compareNotifyContext method of the Observer class
    */
    func testCompareNotifiyContext() {
        // Create observer passing in notification method and context
        let observer = Observer(notifyMethod: self.observerTestMethod, notifyContext: self)
        
        let negTestObject = Notification(name: "ObserverTestNote")
        
        // test assertions
        XCTAssertTrue(observer.compareNotifyContext(negTestObject) == false, "Expecting observer.compareNotifyContext(negTestObj) == false")
        XCTAssertTrue(observer.compareNotifyContext(self) == true, "Expecting observer.compareNotifyContext(self) == true")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    /**
    A function that is used as the observer notification
    method. It multiplies the input number by the
    observerTestVar value
    */
    func observerTestMethod(note: INotification) {
        self.observerTestVar = note.body as! Int
    }

}
