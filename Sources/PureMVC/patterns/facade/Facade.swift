//
//  Facade.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A base Multiton `IFacade` implementation.

`@see org.puremvc.swift.multicore.core.Model Model`

`@see org.puremvc.swift.multicore.core.View View`

`@see org.puremvc.swift.multicore.core.Controller Controller`
*/
open class Facade: IFacade {
 
    /// Reference to the Controller
    internal var controller: IController!
    
    /// Reference to the Model
    internal var model: IModel!
    
    /// Reference to the View
    internal var view: IView!
    
    /// The Multiton Key for this app
    internal private(set) var multitonKey: String!
    
    // The Multiton Facade instanceMap.
    private static var instanceMap = [String: IFacade]()
    
    // Concurrent queue for instanceMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    private static let instanceMapQueue = DispatchQueue(label: "org.puremvc.facade.instanceMapQueue", attributes: DispatchQueue.Attributes.concurrent)
    
    /// Message constant
    internal static let MULTITON_MSG = "Facade instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IFacade` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Factory method,
    passing the unique key for this instance and the factory closure
    that returns the `IFacade` implementation.
    `Facade.getInstance( multitonKey ) { Facade(key: multitonKey) }`
    
    @throws Error Error if instance for this Multiton key has already been constructed
    */
    public init(key: String) {
        assert(Facade.instanceMap[key] == nil, Facade.MULTITON_MSG)
        initializeNotifier(key)
        Facade.instanceMap[key] = self
        initializeFacade()
    }
    
    /**
    Initialize the Multiton `Facade` instance.
    
    Called automatically by the constructor. Override in your
    subclass to do any subclass specific initializations. Be
    sure to call `super.initializeFacade()`, though.
    */
    open func initializeFacade() {
        initializeModel()
        initializeController()
        initializeView()
    }
    
    /**
    Facade Multiton Factory method
    
    - parameter key: multitonKey
    - parameter factory: reference that returns `IFacade`
    - returns: the Multiton instance of the `IFacade`
    */
    open class func getInstance(_ key: String, factory: (String) -> IFacade) -> IFacade {
        instanceMapQueue.sync(flags: .barrier) {
            if instanceMap[key] == nil {
                instanceMap[key] = factory(key)
            }
        }
        return instanceMap[key]!
    }
    
    /**
    Initialize the `Controller`.
    
    Called by the `initializeFacade` method.
    Override this method in your subclass of `Facade`
    if one or both of the following are true:
    
    * You wish to initialize a different `IController`.
    * You have `Commands` to register with the `Controller` at startup.`. 
    
    If you don't want to initialize a different `IController`,
    call `super.initializeController()` at the beginning of your
    method, then register `Command`s.
    */
    open func initializeController() {
        controller = Controller.getInstance(multitonKey) { key in Controller(key: key) }
    }
    
    /**
    Initialize the `Model`.
    
    Called by the `initializeFacade` method.
    Override this method in your subclass of `Facade`
    if one or both of the following are true:
    
    * You wish to initialize a different `IModel`.
    * You have `Proxy`s to register with the Model that do not retrieve a reference to the Facade at construction time.`
    
    If you don't want to initialize a different `IModel`,
    call `super.initializeModel()` at the beginning of your
    method, then register `Proxy`s.
    
    Note: This method is *rarely* overridden; in practice you are more
    likely to use a `Command` to create and register `Proxy`s
    with the `Model`, since `Proxy`s with mutable data will likely
    need to send `INotification`s and thus will likely want to fetch a reference to
    the `Facade` during their construction.
    */
    open func initializeModel() {
        model = Model.getInstance(multitonKey) { key in Model(key: key) }
    }
    
    /**
    Initialize the `View`.
    
    Called by the `initializeFacade` method.
    Override this method in your subclass of `Facade`
    if one or both of the following are true:
    
    * You wish to initialize a different `IView`.
    * You have `Observers` to register with the `View`
    
    If you don't want to initialize a different `IView`,
    call `super.initializeView()` at the beginning of your
    method, then register `IMediator` instances.
    
    Note: This method is *rarely* overridden; in practice you are more
    likely to use a `Command` to create and register `Mediator`s
    with the `View`, since `IMediator` instances will need to send
    `INotification`s and thus will likely want to fetch a reference
    to the `Facade` during their construction.
    */
    open func initializeView() {
        view = View.getInstance(multitonKey) { key in View(key: key) }
    }
    
    /**
    Register an `ICommand` with the `Controller` by Notification name.
    
    - parameter notificationName: the name of the `INotification` to associate the `ICommand` with
    - parameter factory: reference that returns `ICommand`
    */
    open func registerCommand(_ notificationName: String, factory: @escaping () -> ICommand) {
        controller.registerCommand(notificationName, factory: factory)
    }
    
    /**
    Check if a Command is registered for a given Notification
    
    - parameter notificationName:
    - returns: whether a Command is currently registered for the given `notificationName`.
    */
    open func hasCommand(_ notificationName: String) -> Bool {
        controller.hasCommand(notificationName)
    }
    
    /**
    Remove a previously registered `ICommand` to `INotification` mapping from the Controller.
    
    - parameter notificationName: the name of the `INotification` to remove the `ICommand` mapping for
    */
    open func removeCommand(_ notificationName: String) {
        controller.removeCommand(notificationName)
    }
    
    /**
    Register an `IProxy` with the `Model` by name.
    
    - parameter proxy: the `IProxy` instance to be registered with the `Model`.
    */
    open func registerProxy(_ proxy: IProxy) {
        model.registerProxy(proxy)
    }
    
    /**
    Retrieve an `IProxy` from the `Model` by name.
    
    - parameter proxyName: the name of the proxy to be retrieved.
    - returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    open func retrieveProxy(_ proxyName: String) -> IProxy? {
        model.retrieveProxy(proxyName)
    }
    
    /**
    Check if a Proxy is registered
    
    - parameter proxyName:
    - returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    open func hasProxy(_ proxyName: String) -> Bool {
        model.hasProxy(proxyName)
    }
    
    /**
    Remove an `IProxy` from the `Model` by name.
    
    - parameter proxyName: the `IProxy` to remove from the `Model`.
    - returns: the `IProxy` that was removed from the `Model`
    */
    @discardableResult open func removeProxy(_ proxyName: String) -> IProxy? {
        model.removeProxy(proxyName)
    }
    
    /**
    Register a `IMediator` with the `View`.
    
    - parameter mediator: a reference to the `IMediator`
    */
    open func registerMediator(_ mediator: IMediator) {
        view.registerMediator(mediator)
    }
    
    /**
    Retrieve an `IMediator` from the `View`.
    
    - parameter mediatorName:
    - returns: the `IMediator` previously registered with the given `mediatorName`.
    */
    open func retrieveMediator(_ mediatorName: String) -> IMediator? {
        view.retrieveMediator(mediatorName)
    }
    
    /**
    Check if a Mediator is registered or not
    
    - parameter mediatorName:
    - returns: whether a Mediator is registered with the given `mediatorName`.
    */
    open func hasMediator(_ mediatorName: String) -> Bool {
        view.hasMediator(mediatorName)
    }
    
    /**
    Remove an `IMediator` from the `View`.
    
    - parameter mediatorName: name of the `IMediator` to be removed.
    - returns: the `IMediator` that was removed from the `View`
    */
    @discardableResult open func removeMediator(_ mediatorName: String) -> IMediator? {
        view.removeMediator(mediatorName)
    }
    
    /**
    Create and send an `INotification`.
    
    Keeps us from having to construct new notification
    instances in our implementation code.
    
    - parameter notificationName: the name of the notiification to send
    - parameter body: the body of the notification (
    - parameter type: the type of the notification
    */
    open func sendNotification(_ notificationName: String, body: Any, type: String) {
        notifyObservers(Notification(name: notificationName, body: body, type: type))
    }
    
    /**
    Create and send an `INotification`.
    
    Keeps us from having to construct new notification
    instances in our implementation code.
    
    - parameter notificationName: the name of the notiification to send
    - parameter body: the body of the notification (optional)
    */
    open func sendNotification(_ notificationName: String, body: Any) {
        notifyObservers(Notification(name: notificationName, body: body))
    }
    
    /**
    Create and send an `INotification`.
    
    Keeps us from having to construct new notification
    instances in our implementation code.
    
    - parameter notificationName: the name of the notiification to send
    */
    open func sendNotification(_ notificationName: String) {
        notifyObservers(Notification(name: notificationName))
    }
    
    /**
    Notify `Observer`s.
    
    This method is left public mostly for backward
    compatibility, and to allow you to send custom
    notification classes using the facade.
    
    Usually you should just call sendNotification
    and pass the parameters, never having to
    construct the notification yourself.
    
    - parameter notification: the `INotification` to have the `View` notify `Observers` of.
    */
    open func notifyObservers(_ notification: INotification) {
        view.notifyObservers(notification)
    }
    
    /**
    Set the Multiton key for this facade instance.
    
    Not called directly, but instead from the
    constructor when getInstance is invoked.
    It is necessary to be public in order to
    implement INotifier.
    */
    open func initializeNotifier(_ key: String) {
        multitonKey = key
    }
    
    /**
    Check if a Core is registered or not
    
    - parameter key: the multiton key for the Core in question
    - returns: whether a Core is registered with the given `key`.
    */
    open class func hasCore(_ key: String) -> Bool {
        var result = false
        instanceMapQueue.sync {
            result = instanceMap[key] != nil
        }
        return result
    }
    
    /**
    Remove a Core.
    
    Remove the Model, View, Controller and Facade
    instances for the given key.
    
    - parameter key: multitonKey of the Core to remove
    */
    open class func removeCore(_ key: String) {
        instanceMapQueue.sync(flags: .barrier) {
            Model.removeModel(key)
            View.removeView(key)
            Controller.removeController(key)
            instanceMap.removeValue(forKey: key)
        }
    }

}
