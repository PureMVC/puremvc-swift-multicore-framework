//
//  ViewTestMediator3.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

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
    public init(view: AnyObject?) {
        super.init(name: ViewTestMediator3.NAME, view: view)
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
        return view as! ViewTest
    }
    
}
