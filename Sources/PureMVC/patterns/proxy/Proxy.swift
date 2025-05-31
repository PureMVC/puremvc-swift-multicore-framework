//
//  Proxy.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

/**
A base `IProxy` implementation.

In PureMVC, `Proxy` classes are used to manage parts of the
application's data model.

A `Proxy` might simply manage a reference to a local data object,
in which case interacting with it might involve setting and
getting of its data in synchronous fashion.

`Proxy` classes are also used to encapsulate the application's
interaction with remote services to save or retrieve data, in which case,
we adopt an asyncronous idiom; setting data (or calling a method) on the
`Proxy` and listening for a `Notification` to be sent
when the `Proxy` has retrieved the data from the service. 

`@see org.puremvc.swift.multicore.core.Model Model`
*/
open class Proxy: Notifier, IProxy {
    
    /// Default proxy name
    open class var NAME: String { "Proxy" }
    
    /// the proxy name
    public private(set) var name: String
    
    /// the data object
    public var data: Any?
    
    /// Constructor
    public init(name: String? = nil, data: Any? = nil) {
        self.name = name ?? Proxy.NAME
        self.data = data
    }
    
    /// Called by the Model when the Proxy is registered
    open func onRegister() {
        
    }
    
    /// Called by the Model when the Proxy is removed
    open func onRemove() {
        
    }
    
}
