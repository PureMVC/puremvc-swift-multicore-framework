//
//  ViewTestMediator4.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

/**
A Mediator class used by ViewTest.

`@see org.puremvc.swift.multicore.core.view.ViewTest ViewTest`
*/
public class ViewTestMediator4: Mediator, IMediator {

    /**
    The Mediator name
    */
    public override class var NAME: String { return "ViewTestMediator4" }
    
    public init(viewComponent: AnyObject?) {
        super.init(mediatorName: ViewTestMediator4.NAME, viewComponent: viewComponent)
    }
    
    public override func onRegister() {
        viewTest.onRegisterCalled = true
    }
    
    public override func onRemove() {
        viewTest.onRemoveCalled = true
    }
    
    public var viewTest: ViewTest {
        return viewComponent as! ViewTest
    }
    
}
