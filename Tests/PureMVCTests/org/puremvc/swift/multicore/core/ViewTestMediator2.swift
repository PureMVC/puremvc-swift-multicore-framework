//
//  ViewTestMediator2.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import PureMVC

/**
A Mediator class used by ViewTest.

`@see org.puremvc.swift.multicore.core.view.ViewTest ViewTest`
*/
public class ViewTestMediator2 : Mediator {
    
    /**
    The Mediator name
    */
    public override class var NAME: String { return "ViewTestMediator2" }
    
    /**
    Constructor
    */
    public init(viewComponent: AnyObject?) {
        super.init(mediatorName: ViewTestMediator2.NAME, viewComponent: viewComponent)
    }
    
    public override func listNotificationInterests() -> [String] {
        // be sure that the mediator has some Observers created
        // in order to test removeMediator
        return [ViewTest.NOTE1, ViewTest.NOTE2]
    }
    
    public override func handleNotification(_ notification: INotification) {
        viewTest.lastNotification = notification.name
    }
    
    public var viewTest: ViewTest {
        return viewComponent as! ViewTest
    }
    
}
