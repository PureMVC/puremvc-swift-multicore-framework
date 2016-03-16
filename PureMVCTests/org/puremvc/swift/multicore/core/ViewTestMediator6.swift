//
//  ViewTestMediator6.swift
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
public class ViewTestMediator6: Mediator {
    
    /**
    The Mediator base name
    */
    public override class var NAME: String { return "ViewTestMediator6" }
    
    /**
    Constructor
    */
    public init(mediatorName: String, viewComponent: AnyObject?) {
        super.init(mediatorName: mediatorName, viewComponent: viewComponent)
    }
    
    public override func listNotificationInterests() -> [String] {
        return [ ViewTest.NOTE6 ]
    }
    
    public override func handleNotification(notification: INotification) {
        //temp implementation until facade is developed
        let view: IView = View.getInstance("ViewTestKey11") { View(key: "ViewTestKey11") }
        view.removeMediator(mediatorName)
    }
    
    public override func onRemove() {
         viewTest.counter++
    }
    
    public var viewTest: ViewTest {
        return viewComponent as! ViewTest
    }
    
}
