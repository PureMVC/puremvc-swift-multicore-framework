//
//  Observer.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
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
open class Observer: IObserver {
    
    public var notifyMethod: ((_ notification: INotification) -> ())?
    
    weak public var notifyContext: AnyObject?
    
    /**
    Constructor.
    
    The notification method on the interested object should take
    one parameter of type `INotification`
    
    - parameter notifyMethod: the notification method of the interested object
    - parameter notifyContext: the notification context of the interested object
    */
    public init(notifyMethod: ((INotification) -> ())?, notifyContext: AnyObject?) {
        self.notifyMethod = notifyMethod
        self.notifyContext = notifyContext
    }
    
    /**
    Notify the interested object.
    
    - parameter notification: the `INotification` to pass to the interested object's notification method.
    */
    open func notifyObserver(_ notification: INotification) {
        notifyMethod?(notification)
    }
    
    /**
    Compare an object to the notification context.
    
    - parameter object: the object to compare
    - returns: boolean indicating if the object and the notification context are the same
    */
    open func compareNotifyContext(_ object: AnyObject) -> Bool {
        object === notifyContext
    }
    
}
