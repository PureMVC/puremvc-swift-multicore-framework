//
//  Controller.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A Multiton `IController` implementation.

In PureMVC, the `Controller` class follows the
'Command and Controller' strategy, and assumes these
responsibilities:

* Remembering which `ICommand`s are intended to handle which `INotifications`.
* Registering itself as an `IObserver` with the `View` for each `INotification` that it has an `ICommand` mapping for.
* Creating a new instance of the proper `ICommand` to handle a given `INotification` when notified by the `View`.
* Calling the `ICommand`'s `execute` method, passing in the `INotification`.

Your application must register `ICommands` with the
Controller.

The simplest way is to subclass `Facade`,
and use its `initializeController` method to add your
registrations.

`@see org.puremvc.swift.multicore.core.View View`

`@see org.puremvc.swift.multicore.patterns.observer.Observer Observer`

`@see org.puremvc.swift.multicore.patterns.observer.Notification Notification`

`@see org.puremvc.swift.multicore.patterns.command.SimpleCommand SimpleCommand`

`@see org.puremvc.swift.multicore.patterns.command.MacroCommand MacroCommand`
*/
open class Controller: IController {
    
    /// Local reference to View
    internal var view: IView!
    
    // Mapping of Notification names to factories that instanties and returns `ICommand` Class instances
    internal var commandMap = [String: () -> ICommand]()
    
    // Concurrent queue for commandMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    internal let commandMapQueue = DispatchQueue(label: "org.puremvc.controller.commandMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// The Multiton Key for this app
    internal private(set) var multitonKey: String
    
    // The Multiton Controller instanceMap.
    private static var instanceMap = [String: IController]()
    
    // instance Queue for thread safety
    private static let instanceQueue = DispatchQueue(label: "org.puremvc.controller.instanceQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// Message constant
    internal static let MULTITON_MSG = "Controller instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IController` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Factory method,
    passing the unique key for this instance
    `Controller.getInstance( multitonKey )`
    
    @throws Error if instance for this Multiton key has already been constructed
    */
    public init(key: String) {
        assert(Controller.instanceMap[key] == nil, Controller.MULTITON_MSG)
        multitonKey = key
        Controller.instanceMap[key] = self
        initializeController()
    }
    
    /**
    Initialize the Multiton `Controller` instance.
    
    Called automatically by the constructor.
    
    Note that if you are using a subclass of `View`
    in your application, you should *also* subclass `Controller`
    and override the `initializeController` method in the
    following way:
    
        // ensure that the Controller is talking to my IView implementation
        override public func initializeController(  ) {
            view = MyView.getInstance(multitonKey) { MyView(key: self.multitonKey) }
        }
    */
    open func initializeController() {
        view = View.getInstance(multitonKey) { key in View(key: key) }
    }
    
    /**
    `Controller` Multiton Factory method.
    
    - parameter key: multitonKey
    - parameter factory: reference that returns `IController`
    - returns: the Multiton instance
    */
    open class func getInstance(_ key:String, factory: (String) -> IController) -> IController {
        instanceQueue.sync(flags: .barrier, execute: {
            if instanceMap[key] == nil {
                instanceMap[key] = factory(key)
            }
        })
        return instanceMap[key]!
    }
    
    /**
    Register a particular `ICommand` class as the handler
    for a particular `INotification`.
    
    If an `ICommand` has already been registered to
    handle `INotification`s with this name, it is no longer
    used, the new `ICommand` is used instead.
    
    The Observer for the new ICommand is only created if this the
    first time an ICommand has been regisered for this Notification name.
    
    - parameter notificationName: the name of the `INotification`
    - parameter factory: reference that returns `ICommand`
    */
    open func registerCommand(_ notificationName: String, factory: @escaping () -> ICommand) {
        commandMapQueue.sync(flags: .barrier, execute: {
            if commandMap[notificationName] == nil { // weak reference to Controller (self) to avoid reference cycle with View and Observer
                view.registerObserver(notificationName, observer: Observer(notifyMethod: {[weak self] notification in self?.executeCommand(notification)}, notifyContext: self))
            }
            commandMap[notificationName] = factory
        })
    }
    
    /**
    If an `ICommand` has previously been registered
    to handle a the given `INotification`, then it is executed.
    
    - parameter note: an `INotification`
    */
    open func executeCommand(_ notification: INotification) {
        commandMapQueue.sync {
            if let factory = commandMap[notification.name] {
                let commandInstance = factory()
                commandInstance.initializeNotifier(multitonKey)
                commandInstance.execute(notification)
            }
        }
    }
    
    /**
    Check if a Command is registered for a given Notification
    
    - parameter notificationName:
    - returns: whether a Command is currently registered for the given `notificationName`.
    */
    open func hasCommand(_ notificationName: String) -> Bool {
        var result = false
        commandMapQueue.sync {
            result = commandMap[notificationName] != nil
        }
        return result
    }
    
    /**
    Remove a previously registered `ICommand` to `INotification` mapping.
    
    - parameter notificationName: the name of the `INotification` to remove the `ICommand` mapping for
    */
    open func removeCommand(_ notificationName: String) {
        if hasCommand(notificationName) {
            commandMapQueue.sync(flags: .barrier, execute: {
                view.removeObserver(notificationName, notifyContext: self)
                commandMap.removeValue(forKey: notificationName)
            }) 
        }
    }
    
    /**
    Remove an IController instance
    
    - parameter multitonKey: of IController instance to remove
    */
    open class func removeController(_ key: String) {
        instanceQueue.sync(flags: .barrier, execute: {
            _ = instanceMap.removeValue(forKey: key)
        })
    }
    
}
