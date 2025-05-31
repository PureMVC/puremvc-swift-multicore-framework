//
//  ShellFacade.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

@testable import PureMVC

public class ShellFacade: Facade {
    
    public class var TestCommand: String { return "testCommand" }
    
    public class var TestMediator: String { return "testMediator" }
    
    public override func initializeController() {
        super.initializeController()
        registerCommand(ShellFacade.TestCommand, factory: {FacadeTestCommand2()})
    }
    
    public func startup(vo: FacadeTestVO) {
        sendNotification(ShellFacade.TestCommand, body: vo)
    }
    
    public func testMediator(vo: FacadeTestVO) {
        sendNotification(ShellFacade.TestMediator, body: vo)
    }
    
    public class func getInstance(key: String) -> IFacade? {
        return Facade.getInstance(key) { key in ShellFacade(key: key) }
    }
    
}
