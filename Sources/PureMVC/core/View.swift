//
//  View.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A Multiton `IView` implementation.

In PureMVC, the `View` class assumes these responsibilities:

* Maintain a cache of `IMediator` instances.
* Provide methods for registering, retrieving, and removing `IMediators`.
* Notifiying `IMediators` when they are registered or removed.
* Managing the observer lists for each `INotification` in the application.
* Providing a method for attaching `IObservers` to an `INotification`'s observer list.
* Providing a method for broadcasting an `INotification`.
* Notifying the `IObservers` of a given `INotification` when it broadcast.

`@see org.puremvc.swift.multicore.patterns.mediator.Mediator Mediator`

`@see org.puremvc.swift.multicore.patterns.observer.Observer Observer`

`@see org.puremvc.swift.multicore.patterns.observer.Notification Notification`
*/
open class View: IView {
    
    // Mapping of Mediator names to Mediator instances
    internal var mediatorMap = [String: IMediator]()
    
    // Concurrent queue for mediatorMap
   // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    internal let mediatorMapQueue = DispatchQueue(label: "org.puremvc.view.mediatorMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    // Mapping of Notification names to Observer lists
    internal var observerMap = [String: Array<IObserver>]()
    
    // Concurrent queue for observerMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    internal let observerMapQueue = DispatchQueue(label: "org.puremvc.view.observerMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// The Multiton Key for this app
    internal private(set) var multitonKey: String
    
    // The Multiton View instanceMap.
    private static var instanceMap = [String: IView]()
    
    // instance Queue for thread safety
    private static let instanceQueue = DispatchQueue(label: "org.puremvc.view.instanceQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// Message constant
    internal static let MULTITON_MSG = "View instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IView` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Multiton
    Factory method `View.getInstance( multitonKey )`
    
    - parameter key: multitonKey
    
    @throws Error if instance for this Multiton key has already been constructed
    */
    public init(key: String) {
        assert(View.instanceMap[key] == nil, View.MULTITON_MSG)
        multitonKey = key
        View.instanceMap[key] = self
        initializeView()
    }
    
    /**
    Initialize the Multiton View instance.
    
    Called automatically by the constructor, this
    is your opportunity to initialize the Multiton
    instance in your subclass without overriding the
    constructor.
    */
    open func initializeView() {
        
    }
    
    /**
    View Multiton Factory method.
    
    - parameter key: multitonKey
    - parameter factory: reference that returns `IView`
    - returns: the Multiton instance returned by executing the passed closure
    */
    open class func getInstance(_ key: String, factory: (String) -> IView) -> IView? {
        instanceQueue.sync(flags: .barrier) {
            if instanceMap[key] == nil {
                instanceMap[key] = factory(key)
            }
        }
        return instanceMap[key]
    }
    
    /**
    Register an `IObserver` to be notified
    of `INotifications` with a given name.
    
    - parameter notificationName: the name of the `INotifications` to notify this `IObserver` of
    - parameter observer: the `IObserver` to register
    */
    open func registerObserver(_ notificationName: String, observer: IObserver) {
        observerMapQueue.sync(flags: .barrier) {
            if observerMap[notificationName] != nil {
                observerMap[notificationName]!.append(observer)
            } else {
                observerMap[notificationName] = [observer]
            }
        }
    }

    /**
    Notify the `IObservers` for a particular `INotification`.
    
    All previously attached `IObservers` for this `INotification`'s
    list are notified and are passed a reference to the `INotification` in
    the order in which they were registered.
    
    - parameter notification: the `INotification` to notify `IObservers` of.
    */
    open func notifyObservers(_ notification: INotification) {
        // Iteration Safe, the original array may change during the notification loop but irrespective of that all observers will be notified
        let observers = observerMapQueue.sync {
            observerMap[notification.name]
        }
        
        // Notify Observers
        observers?.forEach { observer in
            observer.notifyObserver(notification)
        }
    }
    
    /**
    Remove the observer for a given notifyContext from an observer list for a given Notification name.
    
    - parameter notificationName: which observer list to remove from
    - parameter notifyContext: remove the observer with this object as its notifyContext
    */
    open func removeObserver(_ notificationName: String, notifyContext: AnyObject) {
        observerMapQueue.sync(flags: .barrier) {
            // the observer list for the notification under inspection
            guard var observers = observerMap[notificationName] else { return }
            
            // find the observer for the notifyContext
            if let index = observers.firstIndex(where: { observer in observer.compareNotifyContext(notifyContext) }) {
                // there can only be one Observer for a given notifyContext
                // in any given Observer list, so remove it and break
                observers.remove(at: index)
            }
            
            // Also, when a Notification's Observer list length falls to
            // zero, delete the notification key from the observer map
            if observers.isEmpty {
                observerMap.removeValue(forKey: notificationName)
            } else {
                observerMap[notificationName] = observers
            }
        }
    }
    
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
    
    - parameter mediator: a reference to the `IMediator` instance
    */
    open func registerMediator(_ mediator: IMediator) {
        // do not allow re-registration (you must removeMediator first)
        if hasMediator(mediator.name) { return }
        
        mediator.initializeNotifier(multitonKey)
        
        mediatorMapQueue.sync(flags: .barrier) {
            // Register the Mediator for retrieval by name
            mediatorMap[mediator.name] = mediator
        }
        
        // Create Observer referencing this mediator's handlNotification method
        let observer = Observer(notifyMethod: mediator.handleNotification, notifyContext: mediator)
        
        let interests = mediator.listNotificationInterests()
        
        // Register Mediator as an observer for each notification of interests
        for notificationName in interests {
            registerObserver(notificationName, observer: observer)
        }
        
        // alert the mediator that it has been registered
        mediator.onRegister()
    }

    /**
    Retrieve an `IMediator` from the `View`.
    
    - parameter mediatorName: the name of the `IMediator` instance to retrieve.
    - returns: the `IMediator` instance previously registered with the given `mediatorName`.
    */
    open func retrieveMediator(_ mediatorName: String) -> IMediator? {
        mediatorMapQueue.sync {
            mediatorMap[mediatorName]
        }
    }
    
    /**
    Check if a Mediator is registered or not
    
    - parameter mediatorName:
    - returns: whether a Mediator is registered with the given `mediatorName`.
    */
    open func hasMediator(_ mediatorName: String) -> Bool {
        mediatorMapQueue.sync {
            mediatorMap[mediatorName] != nil
        }
    }

    /**
    Remove an `IMediator` from the `View`.
    
    - parameter mediatorName: name of the `IMediator` instance to be removed.
    - returns: the `IMediator` that was removed from the `View`
    */
    @discardableResult open func removeMediator(_ mediatorName: String) -> IMediator? {
        // remove the mediator from the map
        let removed = mediatorMapQueue.sync(flags: .barrier) {
            mediatorMap.removeValue(forKey: mediatorName)
        }
    
        guard let mediator = removed else { return nil }
        
        // for every notification this mediator is interested in...
        let interests = mediator.listNotificationInterests()
        for notificationName in interests {
            // remove the observer linking the mediator
            // to the notification interest
            removeObserver(notificationName, notifyContext: mediator as! Mediator)
        }
        
        // alert the mediator that it has been removed
        mediator.onRemove()
        return mediator
    }
    
    /**
    Remove an IView instance
    
    - parameter key: of IView instance to remove
    */
    open class func removeView(_ key: String) {
        instanceQueue.sync(flags: .barrier) {
            _ = instanceMap.removeValue(forKey: key)
        }
    }

}
