//
//  ViewTestMediator6.swift
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
public class ViewTestMediator6: Mediator {
    
    /**
    The Mediator base name
    */
    public override class var NAME: String { return "ViewTestMediator6" }
    
    /**
    Constructor
    */
    public init(name: String, view: AnyObject?) {
        super.init(name: name, view: view)
    }
    
    public override func listNotificationInterests() -> [String] {
        return [ ViewTest.NOTE6 ]
    }
    
    public override func handleNotification(_ notification: INotification) {
        //temp implementation until facade is developed
        let view: IView? = View.getInstance("ViewTestKey11") { key in View(key: key) }
        _ = view?.removeMediator(name)
    }
    
    public override func onRemove() {
         viewTest.counter += 1
    }
    
    public var viewTest: ViewTest {
        return view as! ViewTest
    }
    
}
