//
//  IView.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
The interface definition for a PureMVC View.

In PureMVC, `IView` implementors assume these responsibilities:

In PureMVC, the `View` class assumes these responsibilities:

* Maintain a cache of `IMediator` instances.
* Provide methods for registering, retrieving, and removing `IMediators`.
* Managing the observer lists for each `INotification` in the application.
* Providing a method for attaching `IObservers` to an `INotification`'s observer list.
* Providing a method for broadcasting an `INotification`.
* Notifying the `IObservers` of a given `INotification` when it broadcast.

`@see org.puremvc.swift.multicore.interfaces.IMediator IMediator`

`@see org.puremvc.swift.multicore.interfaces.IObserver IObserver`

`@see org.puremvc.swift.multicore.interfaces.INotification INotification`
*/
public protocol IView {
    
    /**
    Register an `IObserver` to be notified
    of `INotifications` with a given name.
    
    :param: notificationName the name of the `INotifications` to notify this `IObserver` of
    :param: observer the `IObserver` to register
    */
    func registerObserver(notificationName: String, observer: IObserver)
    
    /**
    Remove a group of observers from the observer list for a given Notification name.
    
    :param: notificationName which observer list to remove from
    :param: notifyContext removed the observers with this object as their notifyContext
    */
    func removeObserver(notificationName: String, notifyContext: AnyObject)
    
    /**
    Notify the `IObservers` for a particular `INotification`.
    
    All previously attached `IObservers` for this `INotification`'s
    list are notified and are passed a reference to the `INotification` in
    the order in which they were registered.
    
    :param: notification the `INotification` to notify `IObservers` of.
    */
    func notifyObservers(notification: INotification)
    
    /**
    Register an `IMediator` instance with the `View`.
    
    Registers the `IMediator` so that it can be retrieved by name,
    and further interrogates the `IMediator` for its
    `INotification` interests.
    
    If the `IMediator` returns any `INotification`
    names to be notified about, an `Observer` is created encapsulating
    the `IMediator` instance's `handleNotification` method
    and registering it as an `Observer` for all `INotifications` the
    `IMediator` is interested in.
    
    :param: mediatorName the name to associate with this `IMediator` instance
    :param: mediator a reference to the `IMediator` instance
    */
    func registerMediator(mediator: IMediator)
    
    /**
    Retrieve an `IMediator` from the `View`.
    
    :param: mediatorName the name of the `IMediator` instance to retrieve.
    :returns: the `IMediator` instance previously registered with the given `mediatorName`.
    */
    func retrieveMediator(mediatorName: String) -> IMediator?
    
    /**
    Remove an `IMediator` from the `View`.
    
    :param: mediatorName name of the `IMediator` instance to be removed.
    :returns: the `IMediator` that was removed from the `View`
    */
    func removeMediator(mediatorName:String) -> IMediator?
    
    /**
    Check if a Mediator is registered or not
    
    :param: mediatorName
    :returns: whether a Mediator is registered with the given `mediatorName`.
    */
    func hasMediator(mediatorName:String) -> Bool
    
}
