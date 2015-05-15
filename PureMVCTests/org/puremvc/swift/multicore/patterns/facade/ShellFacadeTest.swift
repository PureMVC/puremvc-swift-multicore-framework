//
//  ShellFacadeTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2015-2025 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the Creative Commons Attribution 3.0 License
//

import UIKit
import XCTest

class ShellFacadeTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testShellFacade() {
        var vo:FacadeTestVO = FacadeTestVO(input: 5)
        
        var shellFacade = ShellFacade.getInstance("App") as! ShellFacade
        shellFacade.startup(vo)
        
        XCTAssertTrue(vo.result == 10, "Expecting v.result == 10")
        
        shellFacade.testMediator(vo)
        XCTAssertTrue(vo.result == 25, "Expecting v.result == 25")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
