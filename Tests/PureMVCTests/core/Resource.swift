//
//  TestResource.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

public class Resource {
    
    enum State {
        case ALLOCATED
        case RELEASED
    }
    
    var _state:State = .ALLOCATED
    
    var state: State {
        get { return _state }
        set { _state = newValue }
    }
    
}
