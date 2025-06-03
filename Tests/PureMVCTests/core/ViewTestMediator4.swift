//
//  ViewTestMediator4.swift
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
public class ViewTestMediator4: Mediator {

    /**
    The Mediator name
    */
    public override class var NAME: String { return "ViewTestMediator4" }
    
    public init(view: AnyObject?) {
        super.init(name: ViewTestMediator4.NAME, view: view)
    }
    
    public override func onRegister() {
        viewTest.onRegisterCalled = true
    }
    
    public override func onRemove() {
        viewTest.onRemoveCalled = true
    }
    
    public var viewTest: ViewTest {
        return view as! ViewTest
    }
    
}
