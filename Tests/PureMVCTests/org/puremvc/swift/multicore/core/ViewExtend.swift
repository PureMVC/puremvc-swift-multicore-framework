//
//  ViewExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2019 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

@testable import puremvc_swift_multicore_framework

public class ViewExtend: View {
    
    public var resource: Resource?
    
    public class func getInstance(key: String) -> IView {
        return View.getInstance(key) { ViewExtend(key: key) }
    }
    
    public override class func removeView(_ key: String) {
        View.removeView(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
    
}
