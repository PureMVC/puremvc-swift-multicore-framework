//
//  ViewTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

import XCTest
@testable import PureMVC

/**
Test the PureMVC View class.
*/
public class ViewTest: XCTestCase {
    
    public var onRegisterCalled: Bool = false
    public var onRemoveCalled: Bool = false
    public var lastNotification: String?
    public var counter: Int = 0
    
    class var NOTE1: String { return "Notification1" }
    class var NOTE2: String { return "Notification2" }
    class var NOTE3: String { return "Notification3" }
    class var NOTE4: String { return "Notification4" }
    class var NOTE5: String { return "Notification5" }
    class var NOTE6: String { return "Notification6" }

    override public func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
    Tests the View Multiton Factory Method
    */
    func testGetInstance() {
        // Test Factory Method
        let view: IView? = View.getInstance("ViewTestKey1") { key in View(key: key) }
        
        // test assertions
        XCTAssertNotNil(view as? View, "view != null")
    }
    
    /**
    Tests registration and notification of Observers.
    
    An Observer is created to callback the viewTestMethod of
    this ViewTest instance. This Observer is registered with
    the View to be notified of 'ViewTestEvent' events. Such
    an event is created, and a value set on its payload. Then
    the View is told to notify interested observers of this
    Event.
    
    The View calls the Observer's notifyObserver method
    which calls the viewTestMethod on this instance
    of the ViewTest class. The viewTestMethod method will set
    an instance variable to the value passed in on the Event
    payload. We evaluate the instance variable to be sure
    it is the same as that passed out as the payload of the
    original 'ViewTestEvent'.
    */
    func testRegisterAndNotifyObserver() {
        // Get the Multiton View instance
        let view:IView? = View.getInstance("viewTestKey2") { key in View(key: key) }
        
        // Create observer, passing in notification method and context
        let observer = Observer(notifyMethod: self.viewTestMethod, notifyContext: self)
        
        // Register Observer's interest in a particulat Notification with the View
        view?.registerObserver(ViewTestNote.NAME, observer: observer)
        
        // Create a ViewTestNote, setting
        // a body value, and tell the View to notify
        // Observers. Since the Observer is this class
        // and the notification method is viewTestMethod,
        // successful notification will result in our local
        // viewTestVar being set to the value we pass in
        // on the note body.
        let note = ViewTestNote.create(body: 10)
        view?.notifyObservers(note)
        
        // test assertions
        XCTAssertTrue(viewTestVar == 10, "Expecting viewTestVar = 10")
    }
    
    /**
    A test variable that proves the viewTestMethod was
    invoked by the View.
    */
    private var viewTestVar: Int = 0
    
    /**
    A utility method to test the notification of Observers by the view
    */
    private func viewTestMethod(note: INotification) {
        // set the local viewTestVar to the number on the event payload
        viewTestVar = note.body as! Int
    }
    
    /**
    Tests registering and retrieving a mediator with
    the View.
    */
    func testRegisterAndRetrieveMediator() {
        // Get the Multiton View instance
        let view = View.getInstance("ViewTestKey3") { key in View(key: key) }
        
        // Create and register the test mediator
        let viewTestMediator = ViewTestMediator(view: self)
        view?.registerMediator(viewTestMediator)
        
        // Retrieve the component
        let mediator = view?.retrieveMediator(ViewTestMediator.NAME)
        
        // test assertions
        XCTAssertNotNil(mediator as? Mediator, "Expecting viewComponent not nil")
        XCTAssertNotNil(mediator as? ViewTestMediator, "Expecting comp is ViewTestMediator")
    }
    
    /**
    Tests the hasMediator Method
    */
    func testHasMediator() {
        // register a Mediator
        let view: IView? = View.getInstance("ViewTestKey4") { key in View(key: key) }
        
        // Create and register the test mediator
        let mediator = Mediator(name: "hasMediatorTest", view: self)
        view?.registerMediator(mediator)
        
        // assert that the view?hasMediator method returns true
        // for that mediator name
        XCTAssertTrue(view?.hasMediator("hasMediatorTest") == true, "Expecting view?.hasMediator('hasMediatorTest') == true")
        
        _ = view?.removeMediator("hasMediatorTest")
        
        // assert that the view?hasMediator method returns false
        // for that mediator name
        XCTAssertTrue(view?.hasMediator("hasMediatorTest") == false, "Expecting view?.hasMediator('hasMediatorTest') == false")
    }
    
    /**
    Tests registering and removing a mediator
    */
    func testRegisterAndRemoveMediator() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey5") { key in View(key: key) }
        
        // Create and register the test mediator
        let mediator: IMediator = Mediator(name: "testing", view: self)
        view?.registerMediator(mediator)
        
        // Remove the component
        let removedMediator: IMediator? = view?.removeMediator("testing")
        
        // assert that we have removed the appropriate mediator
        XCTAssertTrue(removedMediator?.name == "testing", "Expecting removedMediator?.mediatorName == 'testing'")
        
        // assert that the mediator is no longer retrievable
        XCTAssertTrue(view?.retrieveMediator("testing") == nil, "Expecting view?.retrieveMediator('testing') == nil")
    }
    
    /**
    Tests that the View callse the onRegister and onRemove methods
    */
    func testOnRegisterAndOnRemove() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey6") { key in View(key: key) }
        
        // Create and register the test mediator
        let mediator: IMediator = ViewTestMediator4(view: self)
        view?.registerMediator(mediator)
        
        // assert that onRegsiter was called, and the mediator responded by setting our boolean
        XCTAssertTrue(onRegisterCalled, "Expecting onRegisterCalled == true")
        
        // Remove the component
        _ = view?.removeMediator(ViewTestMediator4.NAME)
        
        // assert that the mediator is no longer retrievable
        XCTAssertTrue(onRemoveCalled, "Expecting onRemoveCalled == true")
    }
    
    /**
    Tests successive regster and remove of same mediator.
    */
    func testSuccessiveRegisterAndRemoveMediator() {
        // Get the Multiton View instance
        let view:IView? = View.getInstance("ViewTestKey7") { key in View(key: key) }
        
        // Create and register the test mediator,
        // but not so we have a reference to it
        view?.registerMediator(ViewTestMediator(view: self))
        
        // test that we can retrieve it
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator.NAME) is ViewTestMediator, "Expecting view?.retrieveMediator(ViewTestMediator.NAME) is ViewTestMediator")
        
        // Remove the Mediator
        _ = view?.removeMediator(ViewTestMediator.NAME)
        
        // test that retrieving it now returns null
        XCTAssertNil(view?.retrieveMediator(ViewTestMediator.NAME), "Expecting view?.retrieveMediator(ViewTestMediator.NAME ) == nil")
        
        // test that removing the mediator again once its gone doesn't cause crash
        XCTAssertTrue(view?.removeMediator(ViewTestMediator.NAME) == nil, "Expecting view?.removeMediator( ViewTestMediator.NAME ) doesn't crash")
        
        // Create and register another instance of the test mediator,
        view?.registerMediator(ViewTestMediator(view: self))
        
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator.NAME) is ViewTestMediator, "Expecting view?.retrieveMediator( ViewTestMediator.NAME ) is ViewTestMediator")
        
        // Remove the Mediator
        _ = view?.removeMediator(ViewTestMediator.NAME);
        
        // test that retrieving it now returns null
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator.NAME) == nil, "Expecting view?.retrieveMediator(ViewTestMediator.NAME) == nil")
    }
    
    /**
    Tests registering a Mediator for 2 different notifications, removing the
    Mediator from the View, and seeing that neither notification causes the
    Mediator to be notified.
    */
    func testRemoveMediatorAndSubsequentNotify() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey8") { key in View(key: key) }
        
        // Create and register the test mediator to be removed.
        view?.registerMediator(ViewTestMediator2(view: self))
        
        // test that notifications work
        view?.notifyObservers(Notification(name: ViewTest.NOTE1))
        XCTAssertTrue(lastNotification == ViewTest.NOTE1, "Expecting lastNotification == NOTE1")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE2))
        XCTAssertTrue(lastNotification == ViewTest.NOTE2, "Expecting lastNotification == NOTE2")
        
        // Remove the Mediator
        _ = view?.removeMediator(ViewTestMediator2.NAME)
        
        // test that retrieving it now returns null
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator2.NAME) == nil, "Expecting view?.retrieveMediator(ViewTestMediator2.NAME ) == nil")
        
        // test that notifications no longer work
        // (ViewTestMediator2 is the one that sets lastNotification
        // on this component, and ViewTestMediator)
        lastNotification = nil
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE1))
        
        XCTAssertTrue(lastNotification != ViewTest.NOTE1, "Expecting lastNotification != NOTE1")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE2))
        
        XCTAssertTrue(lastNotification != ViewTest.NOTE2, "Expecting lastNotification != NOTE2")
    }
    
    /**
    Tests registering one of two registered Mediators and seeing
    that the remaining one still responds.
    */
    func testRemoveOneOfTwoMediatorsAndSubsequentNotify() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey9") { key in View(key: key) }
        
        // Create and register that responds to notifications 1 and 2
        view?.registerMediator(ViewTestMediator2(view: self))
        
        // Create and register that responds to notification 3
        view?.registerMediator(ViewTestMediator3(view: self))
        
        // test that all notifications work
        view?.notifyObservers(Notification(name: ViewTest.NOTE1))
        XCTAssertTrue(lastNotification == ViewTest.NOTE1, "Expecting lastNotification == NOTE1")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE2))
        XCTAssertTrue(lastNotification == ViewTest.NOTE2, "Expecting lastNotification == NOTE2")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE3))
        XCTAssertTrue(lastNotification == ViewTest.NOTE3, "Expecting lastNotification == NOTE3")
        
        // Remove the Mediator that responds to 1 and 2
        _ = view?.removeMediator(ViewTestMediator2.NAME)
        
        // test that retrieving it now returns nil
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator2.NAME) == nil, "Expecting view?.retrieveMediator(ViewTestMediator2.NAME ) == nil")
        
        // test that notifications no longer work
        // for notifications 1 and 2, but still work for 3
        lastNotification = nil
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE1))
        XCTAssertTrue(lastNotification != ViewTest.NOTE1, "Expecting lastNotification != NOTE1")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE2))
        XCTAssertTrue(lastNotification != ViewTest.NOTE2, "Expecting lastNotification != NOTE2")
        
        view?.notifyObservers(Notification(name: ViewTest.NOTE3))
        XCTAssertTrue(lastNotification == ViewTest.NOTE3, "Expecting lastNotification == NOTE3")
        
    }
    
    /**
    Tests registering the same mediator twice.
    A subsequent notification should only illicit
    one response. Also, since reregistration
    was causing 2 observers to be created, ensure
    that after removal of the mediator there will
    be no further response.
    */
    func testMediatorReregistration() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey10") { key in View(key: key) }
        
        // Create and register that responds to notification 5
        view?.registerMediator(ViewTestMediator5(view: self))
        
        // try to register another instance of that mediator (uses the same NAME constant).
        view?.registerMediator(ViewTestMediator5(view: self))
        
        // test that the counter is only incremented once (mediator 5's response)
        counter = 0
        view?.notifyObservers(Notification(name: ViewTest.NOTE5))
        XCTAssertEqual(1, counter, "Expecting counter == 1")
        
        // Remove the Mediator
        _ = view?.removeMediator(ViewTestMediator5.NAME)
        
        // test that retrieving it now returns nil
        XCTAssertTrue(view?.retrieveMediator(ViewTestMediator5.NAME) == nil, "Expecting view?.retrieveMediator( ViewTestMediator5.NAME ) == nil")
        
        // test that the counter is no longer incremented
        counter = 0
        view?.notifyObservers(Notification(name: ViewTest.NOTE5))
        XCTAssertEqual(0, counter, "Expecting counter == 0")
    }
    
    /**
    Tests the ability for the observer list to
    be modified during the process of notification,
    and all observers be properly notified. This
    happens most often when multiple Mediators
    respond to the same notification by removing
    themselves.
    */
    func testModifyObserverListDuringNotification() {
        // Get the Multiton View instance
        let view: IView? = View.getInstance("ViewTestKey11") { key in View(key: key) }
        
        // Create and register several mediator instances that respond to notification 6
        // by removing themselves, which will cause the observer list for that notification
        // to change. versions prior to MultiCore Version 2.0.5 will see every other mediator
        // fails to be notified.
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/1", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/2", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/3", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/4", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/5", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/6", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/7", view: self))
        view?.registerMediator(ViewTestMediator6(name: ViewTestMediator6.NAME + "/8", view: self))
        
        // clear the counter
        counter = 0
        
        // send the notification. each of the above mediators will respond by removing
        // themselves and incrementing the counter by 1. This should leave us with a
        // count of 8, since 8 mediators will respond.
        view?.notifyObservers(Notification(name: ViewTest.NOTE6))
        // verify the count is correct
        XCTAssertEqual(8, counter, "Expecting counter == 8")
        
        // clear the counter
        counter = 0
        view?.notifyObservers(Notification(name: ViewTest.NOTE6))
        
        // verify the count is 0
        XCTAssertEqual(0, counter, "Expecting counter == 0")
    }
    
    func testRegisterAndRemoveObserver() {
        let view = View.getInstance("ViewTestKey12") { key in View(key: key) }
        
        let vo = ViewTestVO(input: 5)
        let note = Notification(name: "test", body: vo)
        
        view?.registerObserver("test", observer: Observer(notifyMethod: self.handleNotification, notifyContext: self))
        
        view?.notifyObservers(note)
        
        XCTAssertTrue(vo.result == 10, "vo.result == 10 true")
        
        vo.result = 0
        
        view?.removeObserver("test", notifyContext: self)
        
        view?.notifyObservers(note)
        
        XCTAssertTrue(vo.result == 0, "vo.result == 0 true")
        
        //register again
        view?.registerObserver("test", observer: Observer(notifyMethod: self.handleNotification, notifyContext: self))
        
        view?.notifyObservers(note)
        
        XCTAssertTrue(vo.result == 10, "vo.result == 10 true")
        
    }
    
    func handleNotification(notification: INotification) {
        let vo = notification.body as! ViewTestVO
        vo.result = vo.input * 2
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
