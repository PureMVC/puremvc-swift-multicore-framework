//
//  Facade.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import Foundation

/**
A base Multiton `IFacade` implementation.

`@see org.puremvc.swift.multicore.core.Model Model`

`@see org.puremvc.swift.multicore.core.View View`

`@see org.puremvc.swift.multicore.core.Controller Controller`
*/
public class Facade: IFacade {
    
    // The Multiton Key for this app
    private var _multitonKey: String
    
    // References to Model, View and Controller
    private var _controller: IController?
    private var _model: IModel?
    private var _view: IView?
    
    // The Multiton Facade instanceMap.
    private static var instanceMap = [String: IFacade]()
    
    // Concurrent queue for instanceMap
    // for speed and convenience of running concurrently while reading, and thread safety of blocking while mutating
    private static let instanceMapQueue = dispatch_queue_create("org.puremvc.facade.instanceMapQueue", DISPATCH_QUEUE_CONCURRENT)
    
    /// Message constant
    public static let MULTITON_MSG = "Facade instance for this Multiton key already constructed!"
    
    /**
    Constructor.
    
    This `IFacade` implementation is a Multiton,
    so you should not call the constructor
    directly, but instead call the static Factory method,
    passing the unique key for this instance and the closure reference
    that returns the `IFacade` implementation.
    `Facade.getInstance( multitonKey ) { Facade(key: multitonKey) }`
    
    @throws Error Error if instance for this Multiton key has already been constructed
    */
    public init(key: String) {
        assert(Facade.instanceMap[key] == nil, Facade.MULTITON_MSG)
        _multitonKey = key
        Facade.instanceMap[key] = self
        initializeFacade()
    }
    
    /**
    Initialize the Multiton `Facade` instance.
    
    Called automatically by the constructor. Override in your
    subclass to do any subclass specific initializations. Be
    sure to call `super.initializeFacade()`, though.
    */
    public func initializeFacade() {
        initializeModel()
        initializeController()
        initializeView()
    }
    
    /**
    Facade Multiton Factory method
    
    :param: key multitonKey
    :param: closure reference that returns `IFacade`
    :returns: the Multiton instance of the `IFacade`
    */
    public class func getInstance(key: String, closure: (() -> IFacade)) -> IFacade {
        dispatch_barrier_sync(instanceMapQueue) {
            if self.instanceMap[key] == nil {
                self.instanceMap[key] = closure()
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
    public func initializeController() {
        if controller != nil {
            return
        }
        controller = Controller.getInstance(multitonKey) { Controller(key: self.multitonKey) }
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
    public func initializeModel() {
        if model != nil {
            return
        }
        model = Model.getInstance(multitonKey) { Model(key: self.multitonKey) }
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
    public func initializeView() {
        if view != nil {
            return
        }
        view = View.getInstance(multitonKey) { View(key: self.multitonKey) }
    }
    
    /**
    Register an `ICommand` with the `Controller` by Notification name.
    
    :param: notificationName the name of the `INotification` to associate the `ICommand` with
    :param: closure reference that returns `ICommand`
    */
    public func registerCommand(notificationName: String, closure: () -> ICommand) {
        controller!.registerCommand(notificationName, closure: closure)
    }
    
    /**
    Remove a previously registered `ICommand` to `INotification` mapping from the Controller.
    
    :param: notificationName the name of the `INotification` to remove the `ICommand` mapping for
    */
    public func removeCommand(notificationName: String) {
        controller!.removeCommand(notificationName)
    }
    
    /**
    Check if a Command is registered for a given Notification
    
    :param: notificationName
    :returns: whether a Command is currently registered for the given `notificationName`.
    */
    public func hasCommand(notificationName: String) -> Bool {
        return controller!.hasCommand(notificationName)
    }
    
    /**
    Register an `IProxy` with the `Model` by name.
    
    :param: proxy the `IProxy` instance to be registered with the `Model`.
    */
    public func registerProxy(proxy: IProxy) {
        model!.registerProxy(proxy)
    }
    
    /**
    Retrieve an `IProxy` from the `Model` by name.
    
    :param: proxyName the name of the proxy to be retrieved.
    :returns: the `IProxy` instance previously registered with the given `proxyName`.
    */
    public func retrieveProxy(proxyName: String) -> IProxy? {
        return model!.retrieveProxy(proxyName)
    }
    
    /**
    Remove an `IProxy` from the `Model` by name.
    
    :param: proxyName the `IProxy` to remove from the `Model`.
    :returns: the `IProxy` that was removed from the `Model`
    */
    public func removeProxy(proxyName: String) -> IProxy? {
        return model!.removeProxy(proxyName)
    }
    
    /**
    Check if a Proxy is registered
    
    :param: proxyName
    :returns: whether a Proxy is currently registered with the given `proxyName`.
    */
    public func hasProxy(proxyName: String) -> Bool {
        return model!.hasProxy(proxyName)
    }
    
    /**
    Register a `IMediator` with the `View`.
    
    :param: mediator a reference to the `IMediator`
    */
    public func registerMediator(mediator: IMediator) {
        view!.registerMediator(mediator)
    }
    
    /**
    Retrieve an `IMediator` from the `View`.
    
    :param: mediatorName
    :returns: the `IMediator` previously registered with the given `mediatorName`.
    */
    public func retrieveMediator(mediatorName: String) -> IMediator? {
        return view!.retrieveMediator(mediatorName)
    }
    
    /**
    Remove an `IMediator` from the `View`.
    
    :param: mediatorName name of the `IMediator` to be removed.
    :returns: the `IMediator` that was removed from the `View`
    */
    public func removeMediator(mediatorName: String) -> IMediator? {
        return view!.removeMediator(mediatorName)
    }
    
    /**
    Check if a Mediator is registered or not
    
    :param: mediatorName
    :returns: whether a Mediator is registered with the given `mediatorName`.
    */
    public func hasMediator(mediatorName: String) -> Bool {
        return view!.hasMediator(mediatorName)
    }
    
    /**
    Create and send an `INotification`.
    
    Keeps us from having to construct new notification
    instances in our implementation code.
    
    :param: notificationName the name of the notiification to send
    :param: body the body of the notification (optional)
    :param: type the type of the notification (optional)
    */
    public func sendNotification(notificationName: String, body: Any?=nil, type: String?=nil) {
        notifyObservers(Notification(name: notificationName, body: body, type: type))
    }
    
    /**
    Notify `Observer`s.
    
    This method is left public mostly for backward
    compatibility, and to allow you to send custom
    notification classes using the facade.
    
    Usually you should just call sendNotification
    and pass the parameters, never having to
    construct the notification yourself.
    
    :param: notification the `INotification` to have the `View` notify `Observers` of.
    */
    public func notifyObservers(notification: INotification) {
        view!.notifyObservers(notification)
    }
    
    /**
    Set the Multiton key for this facade instance.
    
    Not called directly, but instead from the
    constructor when getInstance is invoked.
    It is necessary to be public in order to
    implement INotifier.
    */
    public func initializeNotifier(key: String) {
        _multitonKey = key
    }
    
    /**
    Check if a Core is registered or not
    
    :param: key the multiton key for the Core in question
    :returns: whether a Core is registered with the given `key`.
    */
    public class func hasCore(key: String) -> Bool {
        var result = false
        dispatch_sync(instanceMapQueue) {
            result = self.instanceMap[key] != nil
        }
        return result
    }
    
    /**
    Remove a Core.
    
    Remove the Model, View, Controller and Facade
    instances for the given key.
    
    :param: key multitonKey of the Core to remove
    */
    public class func removeCore(key: String) {
        Model.removeModel(key)
        View.removeView(key)
        Controller.removeController(key)
        dispatch_barrier_sync(instanceMapQueue) {
            self.instanceMap[key] = nil
        }
    }
    
    /// Reference to the Controller
    public var controller: IController? {
        get { return _controller }
        set { _controller = newValue }
    }
    
    /// References to the Model
    public var model: IModel? {
        get { return _model }
        set { _model = newValue }
    }
    
    /// References to the View
    public var view: IView? {
        get { return _view }
        set { _view = newValue }
    }
    
    /// The Multiton Key
    public var multitonKey: String {
        return _multitonKey
    }

}
