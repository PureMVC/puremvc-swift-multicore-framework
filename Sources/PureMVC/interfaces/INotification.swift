//
//  INotification.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

/**
The interface definition for a PureMVC Notification.

PureMVC does not rely upon underlying event models such
as the one provided with Flash, and ActionScript 3 does
not have an inherent event model.

The Observer Pattern as implemented within PureMVC exists
to support event-driven communication between the
application and the actors of the MVC triad.

Notifications are not meant to be a replacement for Events
in Flex/Flash/AIR. Generally, `IMediator` implementors
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

`@see org.puremvc.swift.multicore.interfaces.IView IView`

`@see org.puremvc.swift.multicore.interfaces.IObserver IObserver`
*/
public protocol INotification: AnyObject {
    
    /// Get the name of the `INotification` instance.
    var name: String { get }
    
    /// Get or set the body of the `INotification` instance
    var body: Any? { get set }
    
    /// Get or set the type of the `INotification` instance
    var type: String? { get set }
    
    /// Get the string representation of the `INotification` instance
    func description() -> String
    
}
