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
    
    :param: proxy the `IProxy` to be registered with the `Model`.
    */
    func registerProxy(proxy: IProxy)
    
    /**
    Retrieve a `IProxy` from the `Model` by name.
    
    :param: proxyName the name of the `IProxy` instance to be retrieved.
    :returns: the `IProxy` previously regisetered by `proxyName` with the `Model`.
    */
    func retrieveProxy(proxyName: String) -> IProxy?
    
    /**
    Remove an `IProxy` instance from the `Model` by name.
    
    :param: proxyName the `IProxy` to remove from the `Model`.
    :returns: the `IProxy` that was removed from the `Model`
    */
    func removeProxy(proxyName: String) -> IProxy?
    
    /**
    Check if a Proxy is registered
    
    :param: proxyName
    :returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    func hasProxy(proxyName: String) -> Bool
    
    /**
    Register an `ICommand` with the `Controller`.
    
    :param: noteName the name of the `INotification` to associate the `ICommand` with.
    :param: closure reference that returns `ICommand`
    */
    func registerCommand(notificationName: String, closure: () -> ICommand)
    
    /**
    Remove a previously registered `ICommand` to `INotification` mapping from the Controller.
    
    :param: notificationName the name of the `INotification` to remove the `ICommand` mapping for
    */
    func removeCommand(notificationName: String)
    
    /**
    Check if a Command is registered for a given Notification
    
    :param: notificationName
    :returns: whether a Command is currently registered for the given `notificationName`.
    */
    func hasCommand(notificationName: String) -> Bool
    
    /**
    Register an `IMediator` instance with the `View`.
    
    :param: mediator a reference to the `IMediator` instance
    */
    func registerMediator(mediator: IMediator)
    
    /**
    Retrieve an `IMediator` instance from the `View`.
    
    :param: mediatorName the name of the `IMediator` instance to retrievve
    :returns: the `IMediator` previously registered with the given `mediatorName`.
    */
    func retrieveMediator(mediatorName: String) -> IMediator?
    
    /**
    Remove a `IMediator` instance from the `View`.
    
    :param: mediatorName name of the `IMediator` instance to be removed.
    :returns: the `IMediator` instance previously registered with the given `mediatorName`.
    */
    func removeMediator(mediatorName: String) -> IMediator?
    
    /**
    Check if a Mediator is registered or not
    
    :param: mediatorName
    :returns: whether a Mediator is registered with the given `mediatorName`.
    */
    
    func hasMediator(mediatorName: String) -> Bool
    
    /**
    Notify `Observer`s.
    
    This method is left public mostly for backward
    compatibility, and to allow you to send custom
    notification classes using the facade.
    
    Usually you should just call sendNotification
    and pass the parameters, never having to
    construct the notification yourself.
    
    :param: notification the `INotification` to have the `View` notify `Observers` of.
    */
    func notifyObservers(notification: INotification)
    
}
