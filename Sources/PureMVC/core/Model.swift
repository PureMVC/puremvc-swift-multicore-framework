//
//  Model.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
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
    internal var proxyMap = [String: IProxy]()
    
    // Concurrent queue for proxyMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    internal let proxyMapQueue = DispatchQueue(label: "org.puremvc.model.proxyMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// The Multiton Key for this app
    internal private(set) var multitonKey: String
    
    // The Multiton Model instanceMap.
    private static var instanceMap = [String: IModel]()
    
    // instance Queue for thread safety
    private static let instanceQueue = DispatchQueue(label: "org.puremvc.model.instanceQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// Message constant
    internal static let MULTITON_MSG = "Model instance for this Multiton key already constructed!"
    
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
        multitonKey = key
        Model.instanceMap[key] = self
        initializeModel()
    }
    
    /**
    Initialize the `Model` instance.
    
    Called automatically by the constructor, this
    is your opportunity to initialize the Multiton
    instance in your subclass without overriding the
    constructor.
    */
    open func initializeModel() {
        
    }
    
    /**
    `Model` Multiton Factory method.
    
    - parameter key: multitonKey
    - parameter factory: reference that returns `IModel`
    - returns: the instance returned by the passed closure
    */
    open class func getInstance(_ key: String, factory: (String) -> IModel) -> IModel {
        instanceQueue.sync(flags: .barrier) {
            if instanceMap[key] == nil {
                instanceMap[key] = factory(key)
            }
        }
        return instanceMap[key]!
    }
    
    /**
    Register an `IProxy` with the `Model`.
    
    - parameter proxy: an `IProxy` to be held by the `Model`.
    */
    open func registerProxy(_ proxy: IProxy) {
        proxy.initializeNotifier(multitonKey)
        proxyMapQueue.sync(flags: .barrier) {
            proxyMap[proxy.name] = proxy
        }
        proxy.onRegister()
    }
    
    /**
    Retrieve an `IProxy` from the `Model`.
    
    - parameter proxyName:
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    open func retrieveProxy(_ proxyName: String) -> IProxy? {
        proxyMapQueue.sync {
            proxyMap[proxyName]
        }
    }
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    open func hasProxy(_ proxyName: String) -> Bool {
        proxyMapQueue.sync {
            proxyMap[proxyName] != nil
        }
    }
    
    /**
    Remove an `IProxy` from the `Model`.
    
    - parameter proxyName: name of the `IProxy` instance to be removed.
    - returns: the `IProxy` that was removed from the `Model`
    */
    @discardableResult open func removeProxy(_ proxyName: String) -> IProxy? {
        var removed: IProxy?
        proxyMapQueue.sync(flags: .barrier) {
            removed = proxyMap.removeValue(forKey: proxyName)
        }
        
        removed?.onRemove()
        return removed
    }
    
    /**
    Remove an IModel instance
    
    - parameter multitonKey: of IModel instance to remove
    */
    open class func removeModel(_ key: String) {
        instanceQueue.sync(flags: .barrier) {
            _ = instanceMap.removeValue(forKey: key)
        }
    }
    
}
