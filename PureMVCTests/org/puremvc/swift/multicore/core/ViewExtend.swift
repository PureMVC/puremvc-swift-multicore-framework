//
//  ViewExtend.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import PureMVC

public class ViewExtend: View {
    
    public var resource: Resource?
    
    public class func getInstance(key: String) -> IView {
        return View.getInstance(key) { ViewExtend(key: key) }
    }
    
    public override class func removeView(key: String) {
        View.removeView(key)
    }
    
    deinit {
        resource?.state = .RELEASED
    }
    
}