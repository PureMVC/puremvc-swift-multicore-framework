//
//  ViewTestMediator5.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A Mediator class used by ViewTest.

`@see org.puremvc.swift.core.view.ViewTest ViewTest`
*/
public class ViewTestMediator5: Mediator {
    
    /**
    The Mediator name
    */
    public override class var NAME: String { return "ViewTestMediator5" }
    
    /**
    Constructor
    */
    public init(viewComponent: AnyObject?) {
        super.init(mediatorName: ViewTestMediator5.NAME, viewComponent: viewComponent)
    }
    
    public override func listNotificationInterests() -> [String] {
        return [ ViewTest.NOTE5]
    }
    
    public override func handleNotification(notification: INotification) {
        viewTest.counter++
    }
    
    public var viewTest: ViewTest {
        return viewComponent as! ViewTest
    }
    
}
