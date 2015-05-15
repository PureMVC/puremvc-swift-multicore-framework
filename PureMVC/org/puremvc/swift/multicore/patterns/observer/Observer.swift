//
//  Observer.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
A base `IObserver` implementation.

An `Observer` is an object that encapsulates information
about an interested object with a method that should
be called when a particular `INotification` is broadcast.

In PureMVC, the `Observer` class assumes these responsibilities:

* Encapsulate the notification (callback) method of the interested object.
* Encapsulate the notification context (this) of the interested object.
* Provide methods for setting the notification method and context.
* Provide a method for notifying the interested object.

`@see org.puremvc.swift.multicore.core.View View`

`@see org.puremvc.swift.multicore.patterns.observer.Notification Notification`
*/
public class Observer: IObserver {
    
    private var _notifyMethod: ((notification: INotification) -> ())?
    
    weak private var _notifyContext: AnyObject?
    
    /**
    Constructor.
    
    The notification method on the interested object should take
    one parameter of type `INotification`
    
    :param: notifyMethod the notification method of the interested object
    :param: notifyContext the notification context of the interested object
    */
    public init(notifyMethod: (INotification -> ())?, notifyContext: AnyObject?) {
        _notifyMethod = notifyMethod
        _notifyContext = notifyContext
    }
    
    /**
    Notify the interested object.
    
    :param: notification the `INotification` to pass to the interested object's notification method.
    */
    public func notifyObserver(notification: INotification) {
        self.notifyMethod?(notification: notification)
    }
    
    /**
    Compare an object to the notification context.
    
    :param: object the object to compare
    :returns: boolean indicating if the object and the notification context are the same
    */
    public func compareNotifyContext(object: AnyObject) -> Bool {
        return object === _notifyContext
    }
    
    /// Get or set the notification method.
    public var notifyMethod: ((notification: INotification) -> ())? {
        get { return _notifyMethod }
        set { _notifyMethod = newValue }
    }
    
    /// Get or set the notification context.
    public var notifyContext: AnyObject? {
        get { return _notifyContext }
        set { _notifyContext = newValue }
    }
    
}
