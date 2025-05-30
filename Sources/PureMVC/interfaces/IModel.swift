//
//  IModel.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
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
public protocol IModel: AnyObject {
    
    /**
     Initialize the `Model` instance.
     */
    func initializeModel()
    
    /**
    Register an `IProxy` instance with the `Model`.
    
    - parameter proxy: an object reference to be held by the `Model`.
    */
    func registerProxy(_ proxy: IProxy)
    
    /**
    Retrieve an `IProxy` instance from the Model.
    
    - parameter proxyName:
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    func retrieveProxy(_ proxyName: String) -> IProxy?
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    func hasProxy(_ proxyName: String) -> Bool
    
    /**
    Remove an `IProxy` instance from the Model.
    
    - parameter proxyName: name of the `IProxy` instance to be removed.
    - returns: the `IProxy` that was removed from the `Model`
    */
    @discardableResult func removeProxy(_ proxyName: String) -> IProxy?
    
}
