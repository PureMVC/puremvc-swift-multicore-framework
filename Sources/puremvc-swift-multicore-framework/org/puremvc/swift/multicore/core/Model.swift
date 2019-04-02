//
//  Model.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A Multiton `IModel` implementation.

In PureMVC, the `Model` class provides
access to model objects (Proxies) by named lookup.

The `Model` assumes these responsibilities:

* Maintain a cache of `IProxy` instances.
* Provide methods for registering, retrieving, and removing `IProxy` instances.

Your application must register `IProxy` instances
with the `Model`. Typically, you use an
`ICommand` to create and register `IProxy`
instances once the `Facade` has initialized the Core
actors.

`@see org.puremvc.swift.multicore.patterns.proxy.Proxy Proxy`

`@see org.puremvc.swift.multicore.interfaces.IProxy IProxy`
*/
open class Model: IModel {
    
    // Mapping of proxyNames to IProxy instances
    fileprivate var proxyMap: [String: IProxy]
    
    // Concurrent queue for proxyMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    fileprivate let proxyMapQueue: DispatchQueue = DispatchQueue(label: "org.puremvc.model.proxyMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    // The Multiton Key for this Core
    fileprivate var _multitonKey: String
    
    // The Multiton Model instanceMap.
    fileprivate static var instanceMap = [String: IModel]()
    
    // instance Queue for thread safety
    fileprivate static let instanceQueue: DispatchQueue = DispatchQueue(label: "org.puremvc.model.instanceQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// Message constant
    public static let MULTITON_MSG = "Model instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IModel` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Multiton
    Factory method `Model.getInstance( multitonKey )`
    
    - parameter key: multitonKey
    
    @throws Error if instance for this Multiton key instance has already been constructed
    */
    public init(key: String) {
        assert(Model.instanceMap[key] == nil, Model.MULTITON_MSG)
        _multitonKey = key
        proxyMap = [String: IProxy]()
        Model.instanceMap[key] = self
        initializeModel()
    }
    
    /**
    Initialize the `Model` instance.
    
    Called automatically by the constructor, this
    is your opportunity to initialize the Singleton
    instance in your subclass without overriding the
    constructor.
    */
    open func initializeModel() {
        
    }
    
    /**
    `Model` Multiton Factory method.
    
    - parameter key: multitonKey
    - parameter closure: reference that returns `IModel`
    - returns: the instance returned by the passed closure
    */
    open class func getInstance(_ key: String, closure: () -> IModel) -> IModel {
        instanceQueue.sync(flags: .barrier, execute: {
            if self.instanceMap[key] == nil {
                self.instanceMap[key] = closure()
            }
        }) 
        return instanceMap[key]!
    }
    
    /**
    Register an `IProxy` with the `Model`.
    
    - parameter proxy: an `IProxy` to be held by the `Model`.
    */
    open func registerProxy(_ proxy: IProxy) {
        proxyMapQueue.sync(flags: .barrier, execute: {
            proxy.initializeNotifier(self.multitonKey)
            self.proxyMap[proxy.proxyName] = proxy
            proxy.onRegister()
        }) 
    }
    
    /**
    Retrieve an `IProxy` from the `Model`.
    
    - parameter proxyName:
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    open func retrieveProxy(_ proxyName: String) -> IProxy? {
        var proxy: IProxy?
        proxyMapQueue.sync {
            proxy = self.proxyMap[proxyName]
        }
        return proxy
    }
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    open func hasProxy(_ proxyName: String) -> Bool {
        var result = false
        proxyMapQueue.sync {
            result = self.proxyMap[proxyName] != nil
        }
        return result
    }
    
    /**
    Remove an `IProxy` from the `Model`.
    
    - parameter proxyName: name of the `IProxy` instance to be removed.
    - returns: the `IProxy` that was removed from the `Model`
    */
    open func removeProxy(_ proxyName: String) -> IProxy? {
        var removed: IProxy?
        proxyMapQueue.sync(flags: .barrier, execute: {
            if let proxy = self.proxyMap[proxyName] {
                proxy.onRemove()
                removed = self.proxyMap.removeValue(forKey: proxyName)
            }
        }) 
        return removed
    }
    
    /**
    Remove an IModel instance
    
    - parameter multitonKey: of IModel instance to remove
    */
    open class func removeModel(_ key: String) {
        instanceQueue.sync(flags: .barrier, execute: {
            _ = self.instanceMap.removeValue(forKey: key)
        }) 
    }
    
    /// The Multiton Key
    open var multitonKey: String {
        return _multitonKey
    }
    
}
