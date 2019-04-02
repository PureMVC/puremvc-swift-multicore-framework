//
//  ViewTestMediator3.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

/**
A Mediator class used by ViewTest.

`@see org.puremvc.swift.multicore.core.view.ViewTest ViewTest`
*/
public class ViewTestMediator3: Mediator {
    
    /**
    The Mediator name
    */
    public override class var NAME: String { return "ViewTestMediator3" }
    
    /**
    Constructor
    */
    public init(viewComponent: AnyObject?) {
        super.init(mediatorName: ViewTestMediator3.NAME, viewComponent: viewComponent)
    }
    
    // be sure that the mediator has some Observers created
    // in order to test removeMediator
    public override func listNotificationInterests() -> [String] {
        return [ ViewTest.NOTE3 ]
    }
    
    public override func handleNotification(_ notification: INotification) {
        viewTest.lastNotification = notification.name
    }
    
    public var viewTest: ViewTest {
        return viewComponent as! ViewTest
    }
    
}
