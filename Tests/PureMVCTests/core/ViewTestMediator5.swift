//
//  ViewTestMediator5.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

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
    public init(view: AnyObject?) {
        super.init(name: ViewTestMediator5.NAME, view: view)
    }
    
    public override func listNotificationInterests() -> [String] {
        return [ ViewTest.NOTE5]
    }
    
    public override func handleNotification(_ notification: INotification) {
        viewTest.counter += 1
    }
    
    public var viewTest: ViewTest {
        return view as! ViewTest
    }
    
}
