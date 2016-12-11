//
//  Notification.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
A base `INotification` implementation.

PureMVC does not rely upon underlying event models such
as the one provided with Flash, and ActionScript 3 does
not have an inherent event model.

The Observer Pattern as implemented within PureMVC exists
to support event-driven communication between the
application and the actors of the MVC triad.

Notifications are not meant to be a replacement for Events
in Flex/Flash/Apollo. Generally, `IMediator` implementors
place event listeners on their view components, which they
then handle in the usual way. This may lead to the broadcast of `Notification`s to
trigger `ICommand`s or to communicate with other `IMediators`. `IProxy` and `ICommand`
instances communicate with each other and `IMediator`s
by broadcasting `INotification`s.

A key difference between Flash `Event`s and PureMVC
`Notification`s is that `Event`s follow the
'Chain of Responsibility' pattern, 'bubbling' up the display hierarchy
until some parent component handles the `Event`, while
PureMVC `Notification`s follow a 'Publish/Subscribe'
pattern. PureMVC classes need not be related to each other in a
parent/child relationship in order to communicate with one another
using `Notification`s.

`@see org.puremvc.swift.multicore.patterns.observer.Observer Observer`
*
*/
open class Notification : INotification {
    
    // the name of the notification instance
    fileprivate var _name: String
    // the body of the notification instance
    fileprivate var _body: Any?
    // the type of the notification instance
    fileprivate var _type: String?
    
    /**
    Constructor.
    
    - parameter name: name of the `Notification` instance. (required)
    - parameter body: the `Notification` body. (optional)
    - parameter type: the type of the `Notification` (optional)
    */
    public init(name: String, body: Any?=nil, type: String?=nil) {
        _name = name
        _body = body
        _type = type
    }
    
    /// Get the name of notification instance
    open var name: String {
        return _name
    }
    
    /// Get or set the body of notification instance
    open var body: Any? {
        get { return _body }
        set { _body = newValue }
    }
    
    /// Get or set the type of notification instance
    open var type: String? {
        get { return _type }
        set { _type = newValue }
    }
    
    /**
    Get the string representation of the `Notification` instance.
    
    - returns: the string representation of the `Notification` instance.
    */
    open func description() -> String {
        return "Notification Name: \(self.name) \(self.body) \(self.type)"
    }
    
}
