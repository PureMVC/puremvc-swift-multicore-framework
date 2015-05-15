//
//  View.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
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
public class View: IView {
    
    // Mapping of Mediator names to Mediator instances
    private var mediatorMap: [String: IMediator]
    
    // Concurrent queue for mediatorMap
   // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    private let mediatorMapQueue = dispatch_queue_create("org.puremvc.view.mediatorMapQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // Mapping of Notification names to Observer lists
    private var observerMap: [String: Array<IObserver>]
    
    // Concurrent queue for observerMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    private let observerMapQueue = dispatch_queue_create("org.puremvc.view.observerMapQueue", DISPATCH_QUEUE_CONCURRENT)
    
    // The Multiton Key for this Core
    private var _multitonKey: String
    
    // The Multiton View instanceMap.
    private static var instanceMap = [String: IView]()
    
    // instance Queue for thread safety
    private static let instanceQueue = dispatch_queue_create("org.puremvc.view.instanceQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// Message constant
    public static let MULTITON_MSG = "View instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IView` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Multiton
    Factory method `View.getInstance( multitonKey )`
    
    :param: key multitonKey
    
    @throws Error if instance for this Multiton key has already been constructed
    */
    public init(key: String) {
        assert(View.instanceMap[key] == nil, View.MULTITON_MSG)
        _multitonKey = key
        mediatorMap = [:]
        observerMap = [:]
        View.instanceMap[key] = self
        initializeView()
    }
    
    /**
    Initialize the Singleton View instance.
    
    Called automatically by the constructor, this
    is your opportunity to initialize the Singleton
    instance in your subclass without overriding the
    constructor.
    */
    public func initializeView() {
        
    }
    
    /**
    View Singleton Factory method.
    
    :param: key multitonKey
    :param: closure reference that returns `IView`
    :returns: the Singleton instance returned by executing the passed closure
    */
    public class func getInstance(key: String, closure: () -> IView) -> IView {
        dispatch_barrier_sync(instanceQueue) {
            if self.instanceMap[key] == nil {
                self.instanceMap[key] = closure()
            }
        }
        return instanceMap[key]!
    }
    
    /**
    Register an `IObserver` to be notified
    of `INotifications` with a given name.
    
    :param: notificationName the name of the `INotifications` to notify this `IObserver` of
    :param: observer the `IObserver` to register
    */
    public func registerObserver(notificationName: String, observer: IObserver) {
        dispatch_barrier_sync(observerMapQueue) {
            if self.observerMap[notificationName] != nil {
                self.observerMap[notificationName]!.append(observer)
            } else {
                self.observerMap[notificationName] = [observer]
            }
        }
    }

    /**
    Notify the `IObservers` for a particular `INotification`.
    
    All previously attached `IObservers` for this `INotification`'s
    list are notified and are passed a reference to the `INotification` in
    the order in which they were registered.
    
    :param: notification the `INotification` to notify `IObservers` of.
    */
    public func notifyObservers(notification: INotification) {
        var observers: [IObserver]?
        
        dispatch_sync(observerMapQueue) {
            // An immutable/constant reference to the observers list for this notification name
            // Swift Arrays are copied by value, and observers in this case a constant/immutable array
            // The original array may change during the notification loop but irrespective of that all observers will be notified
            if let observers_ref = self.observerMap[notification.name] {
                observers = observers_ref
            }
        }
        
        // Notify Observers
        if observers != nil {
            for observer in observers! {
                observer.notifyObserver(notification)
            }
        }
    }
    
    /**
    Remove the observer for a given notifyContext from an observer list for a given Notification name.
    
    :param: notificationName which observer list to remove from
    :param: notifyContext remove the observer with this object as its notifyContext
    */
    public func removeObserver(notificationName: String, notifyContext: AnyObject) {
        dispatch_barrier_sync(observerMapQueue) {
            // the observer list for the notification under inspection
            if let observers = self.observerMap[notificationName] {
                
                // find the observer for the notifyContext
                for (index, _) in enumerate(observers) {
                    if observers[index].compareNotifyContext(notifyContext) {
                        // there can only be one Observer for a given notifyContext
                        // in any given Observer list, so remove it and break
                        self.observerMap[notificationName]!.removeAtIndex(index)
                        break;
                    }
                }
                
                // Also, when a Notification's Observer list length falls to
                // zero, delete the notification key from the observer map
                if observers.isEmpty {
                    self.observerMap[notificationName] = nil
                }
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
    
    :param: mediator a reference to the `IMediator` instance
    */
    public func registerMediator(mediator: IMediator) {
        // do not allow re-registration (you must removeMediator fist)
        if (hasMediator(mediator.mediatorName)) {
            return
        }
        
        dispatch_barrier_sync(mediatorMapQueue) {
            mediator.initializeNotifier(self.multitonKey)
            
            // Register the Mediator for retrieval by name
            self.mediatorMap[mediator.mediatorName] = mediator
            
            // Get Notification interests, if any.
            var interests = mediator.listNotificationInterests()
            
            // Register Mediator as an observer for each notification of interests
            if !interests.isEmpty {
                // Create Observer referencing this mediator's handlNotification method
                
                var observer = Observer(notifyMethod: {notification in mediator.handleNotification(notification)}, notifyContext: mediator as! Mediator)
                
                // Register Mediator as Observer for its list of Notification interests
                for notificationName in interests {
                    self.registerObserver(notificationName, observer: observer)
                }
            }
            
            // alert the mediator that it has been registered
            mediator.onRegister()
        }
    }

    /**
    Retrieve an `IMediator` from the `View`.
    
    :param: mediatorName the name of the `IMediator` instance to retrieve.
    :returns: the `IMediator` instance previously registered with the given `mediatorName`.
    */
    public func retrieveMediator(mediatorName: String) -> IMediator? {
        var mediator: IMediator?
        dispatch_sync(mediatorMapQueue) {
            mediator = self.mediatorMap[mediatorName]
        }
        return mediator
    }

    /**
    Remove an `IMediator` from the `View`.
    
    :param: mediatorName name of the `IMediator` instance to be removed.
    :returns: the `IMediator` that was removed from the `View`
    */
    public func removeMediator(mediatorName: String) -> IMediator? {
        var removed: IMediator?
        dispatch_barrier_sync(mediatorMapQueue) {
            if let mediator = self.mediatorMap[mediatorName] {
                // for every notification this mediator is interested in...
                var interests = mediator.listNotificationInterests()
                
                for notificationName in interests {
                    // remove the observer linking the mediator
                    // to the notification interest
                    self.removeObserver(notificationName, notifyContext: mediator as! Mediator)
                }
                
                // remove the mediator from the map
                self.mediatorMap[mediatorName] = nil
                
                // alert the mediator that it has been removed
                mediator.onRemove()
                removed = mediator
            }
        }
        return removed
    }
    
    /**
    Check if a Mediator is registered or not
    
    :param: mediatorName
    :returns: whether a Mediator is registered with the given `mediatorName`.
    */
    public func hasMediator(mediatorName: String) -> Bool {
        var result = false
        dispatch_sync(mediatorMapQueue) {
            result = self.mediatorMap[mediatorName] != nil
        }
        return result
    }
    
    /**
    Remove an IView instance
    
    :param: multitonKey of IView instance to remove
    */
    public class func removeView(key: String) {
        dispatch_barrier_sync(instanceQueue) {
            self.instanceMap[key] = nil
        }
    }
    
    /// The Multiton Key
    public var multitonKey: String {
        return _multitonKey
    }

}
