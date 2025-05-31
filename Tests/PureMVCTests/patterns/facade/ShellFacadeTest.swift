//
//  ShellFacadeTest.swift
//  PureMVC SWIFT Multicore
//
//  Copyright(c) 2020 Saad Shams <saad.shams@puremvc.org>
//  Your reuse is governed by the BSD 3-Clause License
//

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
        let vo:FacadeTestVO = FacadeTestVO(input: 5)
        
        let shellFacade = ShellFacade.getInstance(key: "App") as! ShellFacade
        shellFacade.startup(vo: vo)
        
        XCTAssertTrue(vo.result == 10, "Expecting v.result == 10")
        
        shellFacade.testMediator(vo: vo)
        XCTAssertTrue(vo.result == 25, "Expecting v.result == 25")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }

}
