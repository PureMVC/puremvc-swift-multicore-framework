//
//  IFacade.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
The interface definition for a PureMVC Facade.

The Facade Pattern suggests providing a single
class to act as a central point of communication
for a subsystem.

In PureMVC, the Facade acts as an interface between
the core MVC actors (Model, View, Controller) and
the rest of your application.

`@see org.puremvc.swift.multicore.interfaces.IModel IModel`

`@see org.puremvc.swift.multicore.interfaces.IView IView`

`@see org.puremvc.swift.multicore.interfaces.IController IController`

`@see org.puremvc.swift.multicore.interfaces.ICommand ICommand`

`@see org.puremvc.swift.multicore.interfaces.INotification INotification`
*/
public protocol IFacade: INotifier {
    
    /**
    Register an `IProxy` with the `Model` by name.
    
    - parameter proxy: the `IProxy` to be registered with the `Model`.
    */
    func registerProxy(_ proxy: IProxy)
    
    /**
    Retrieve a `IProxy` from the `Model` by name.
    
    - parameter proxyName: the name of the `IProxy` instance to be retrieved.
    - returns: the `IProxy` previously regisetered by `proxyName` with the `Model`.
    */
    func retrieveProxy(_ proxyName: String) -> IProxy?
    
    /**
    Remove an `IProxy` instance from the `Model` by name.
    
    - parameter proxyName: the `IProxy` to remove from the `Model`.
    - returns: the `IProxy` that was removed from the `Model`
    */
    func removeProxy(_ proxyName: String) -> IProxy?
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    func hasProxy(_ proxyName: String) -> Bool
    
    /**
    Register an `ICommand` with the `Controller`.
    
    - parameter noteName: the name of the `INotification` to associate the `ICommand` with.
    - parameter closure: reference that returns `ICommand`
    */
    func registerCommand(_ notificationName: String, closure: @escaping () -> ICommand)
    
    /**
    Remove a previously registered `ICommand` to `INotification` mapping from the Controller.
    
    - parameter notificationName: the name of the `INotification` to remove the `ICommand` mapping for
    */
    func removeCommand(_ notificationName: String)
    
    /**
    Check if a Command is registered for a given Notification
    
    - parameter notificationName:
    - returns: whether a Command is currently registered for the given `notificationName`.
    */
    func hasCommand(_ notificationName: String) -> Bool
    
    /**
    Register an `IMediator` instance with the `View`.
    
    - parameter mediator: a reference to the `IMediator` instance
    */
    func registerMediator(_ mediator: IMediator)
    
    /**
    Retrieve an `IMediator` instance from the `View`.
    
    - parameter mediatorName: the name of the `IMediator` instance to retrievve
    - returns: the `IMediator` previously registered with the given `mediatorName`.
    */
    func retrieveMediator(_ mediatorName: String) -> IMediator?
    
    /**
    Remove a `IMediator` instance from the `View`.
    
    - parameter mediatorName: name of the `IMediator` instance to be removed.
    - returns: the `IMediator` instance previously registered with the given `mediatorName`.
    */
    func removeMediator(_ mediatorName: String) -> IMediator?
    
    /**
    Check if a Mediator is registered or not
    
    - parameter mediatorName:
    - returns: whether a Mediator is registered with the given `mediatorName`.
    */
    
    func hasMediator(_ mediatorName: String) -> Bool
    
    /**
    Notify `Observer`s.
    
    This method is left public mostly for backward
    compatibility, and to allow you to send custom
    notification classes using the facade.
    
    Usually you should just call sendNotification
    and pass the parameters, never having to
    construct the notification yourself.
    
    - parameter notification: the `INotification` to have the `View` notify `Observers` of.
    */
    func notifyObservers(_ notification: INotification)
    
}
