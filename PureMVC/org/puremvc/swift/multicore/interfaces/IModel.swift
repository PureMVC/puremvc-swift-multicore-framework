//
//  IModel.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
The interface definition for a PureMVC Model.

In PureMVC, `IModel` implementors provide
access to `IProxy` objects by named lookup.

An `IModel` assumes these responsibilities:

* Maintain a cache of `IProxy` instances
* Provide methods for registering, retrieving, and removing `IProxy` instances
*/
public protocol IModel {
    
    /**
    Register an `IProxy` instance with the `Model`.
    
    - parameter proxyName: the name to associate with this `IProxy` instance.
    - parameter proxy: an object reference to be held by the `Model`.
    */
    func registerProxy(proxy: IProxy)
    
    /**
    Retrieve an `IProxy` instance from the Model.
    
    - parameter proxyName:
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    func retrieveProxy(proxyName: String) -> IProxy?
    
    /**
    Remove an `IProxy` instance from the Model.
    
    - parameter proxyName: name of the `IProxy` instance to be removed.
    - returns: the `IProxy` that was removed from the `Model`
    */
    func removeProxy(proxyName: String) -> IProxy?
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    func hasProxy(proxyName: String) -> Bool
    
}
