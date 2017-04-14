//
//  C2ASliderTest.swift
//  SlideToUnlock
//
//  Created by Dirk Gerretz on 06.04.17.
//  Copyright © 2017 [code2 app];. All rights reserved.
//

import XCTest

@testable import SlideToUnlock

class C2ASliderTest: XCTestCase {
    
    func testCalcualteAplha() {
        let cd = NSKeyedUnarchiver(forReadingWith: NSMutableData() as Data)
        let slider = C2ASlider(coder: cd)
        slider.endPoint = 250.0
        let result = slider.calcualteAplhaFor(position: CGFloat(10.0))
        let expected = CGFloat(0.92)
        XCTAssertTrue(result == expected)
    }
    
}
