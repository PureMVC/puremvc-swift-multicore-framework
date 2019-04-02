//
//  Notifier.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

/**
A Base `INotifier` implementation.

`MacroCommand, Command, Mediator` and `Proxy`
all have a need to send `Notifications`. 

The `INotifier` interface provides a common method called
`sendNotification` that relieves implementation code of
the necessity to actually construct `Notifications`.

The `Notifier` class, which all of the above mentioned classes
extend, provides an initialized reference to the `Facade`
Multiton, which is required for the convienience method
for sending `Notifications`, but also eases implementation as these
classes have frequent `Facade` interactions and usually require
access to the facade anyway.

NOTE: In the MultiCore version of the framework, there is one caveat to
notifiers, they cannot send notifications or reach the facade until they
have a valid multitonKey.

The multitonKey is set:
* on a Command when it is executed by the Controller
* on a Mediator is registered with the View
* on a Proxy is registered with the Model.

`@see org.puremvc.swift.multicore.patterns.proxy.Proxy Proxy`

`@see org.puremvc.swift.multicore.patterns.facade.Facade Facade`

`@see org.puremvc.swift.multicore.patterns.mediator.Mediator Mediator`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommand MacroCommand`

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommand SimpleCommand`
*/
open class Notifier : INotifier {
    
    /// Message constant
    open class var MULTITON_MSG: String { return "multitonKey for this Notifier not yet initialized!" }
    
    // The Multiton Key for this app
    fileprivate var _multitonKey: String?
    
    /// Constructor
    public init() {
        
    }
    
    /// Reference to the Facade Multiton
    open var facade:IFacade {
        assert(multitonKey != nil, Notifier.MULTITON_MSG)
        
        // returns instance mapped to multitonKey if it exists otherwise defaults to Facade
        return Facade.getInstance(multitonKey!) { Facade(key: self.multitonKey!) }
    }
    
    /**
    Create and send an `INotification`.
    
    Keeps us from having to construct new INotification
    instances in our implementation code.
    
    - parameter notificationName: the name of the notification to send
    - parameter body: the body of the notification (optional)
    - parameter type: the type of the notification (optional)
    */
    open func sendNotification(_ notificationName: String, body: Any?=nil, type: String?=nil) {
        facade.sendNotification(notificationName, body: body, type: type)
    }
    
    /**
    Initialize this INotifier instance.
    
    This is how a Notifier gets its multitonKey.
    Calls to sendNotification or to access the
    facade will fail until after this method
    has been called.

    Mediators, Commands or Proxies may override
    this method in order to send notifications
    or access the Multiton Facade instance as
    soon as possible. They CANNOT access the facade
    in their constructors, since this method will not
    yet have been called.
    
    - parameter key: the multitonKey for this INotifier to use
    */
    open func initializeNotifier(_ key: String) {
        _multitonKey = key
    }
    
    /// The Multiton Key for this app
    open var multitonKey: String? {
        return _multitonKey
    }
    
}
