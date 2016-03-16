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
public class Model: IModel {
    
    // Mapping of proxyNames to IProxy instances
    private var proxyMap: [String: IProxy]
    
    // Concurrent queue for proxyMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    private let proxyMapQueue: dispatch_queue_t = dispatch_queue_create("org.puremvc.model.proxyMapQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // The Multiton Key for this Core
    private var _multitonKey: String
    
    // The Multiton Model instanceMap.
    private static var instanceMap = [String: IModel]()
    
    // instance Queue for thread safety
    private static let instanceQueue: dispatch_queue_t = dispatch_queue_create("org.puremvc.model.instanceQueue", DISPATCH_QUEUE_CONCURRENT)
    
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
    public func initializeModel() {
        
    }
    
    /**
    `Model` Multiton Factory method.
    
    - parameter key: multitonKey
    - parameter closure: reference that returns `IModel`
    - returns: the instance returned by the passed closure
    */
    public class func getInstance(key: String, closure: () -> IModel) -> IModel {
        dispatch_barrier_sync(instanceQueue) {
            if self.instanceMap[key] == nil {
                self.instanceMap[key] = closure()
            }
        }
        return instanceMap[key]!
    }
    
    /**
    Register an `IProxy` with the `Model`.
    
    - parameter proxy: an `IProxy` to be held by the `Model`.
    */
    public func registerProxy(proxy: IProxy) {
        dispatch_barrier_sync(proxyMapQueue) {
            proxy.initializeNotifier(self.multitonKey)
            self.proxyMap[proxy.proxyName] = proxy
            proxy.onRegister()
        }
    }
    
    /**
    Retrieve an `IProxy` from the `Model`.
    
    - parameter proxyName:
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    public func retrieveProxy(proxyName: String) -> IProxy? {
        var proxy: IProxy?
        dispatch_sync(proxyMapQueue) {
            proxy = self.proxyMap[proxyName]
        }
        return proxy
    }
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    public func hasProxy(proxyName: String) -> Bool {
        var result = false
        dispatch_sync(proxyMapQueue) {
            result = self.proxyMap[proxyName] != nil
        }
        return result
    }
    
    /**
    Remove an `IProxy` from the `Model`.
    
    - parameter proxyName: name of the `IProxy` instance to be removed.
    - returns: the `IProxy` that was removed from the `Model`
    */
    public func removeProxy(proxyName: String) -> IProxy? {
        var removed: IProxy?
        dispatch_barrier_sync(proxyMapQueue) {
            if let proxy = self.proxyMap[proxyName] {
                proxy.onRemove()
                removed = self.proxyMap.removeValueForKey(proxyName)
            }
        }
        return removed
    }
    
    /**
    Remove an IModel instance
    
    - parameter multitonKey: of IModel instance to remove
    */
    public class func removeModel(key: String) {
        dispatch_barrier_sync(instanceQueue) {
            self.instanceMap.removeValueForKey(key)
        }
    }
    
    /// The Multiton Key
    public var multitonKey: String {
        return _multitonKey
    }
    
}
