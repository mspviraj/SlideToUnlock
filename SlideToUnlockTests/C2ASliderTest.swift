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
    
    var slider: C2ASlider?
    
    override func setUp() {
        let cd = NSKeyedUnarchiver(forReadingWith: NSMutableData() as Data)
        slider = C2ASlider(coder: cd)
        XCTAssertTrue(slider != nil, "Slider is nil")
    }
    
    
    func testSetupSlider() {
        XCTAssertNotNil(slider?.setupSlider())
        XCTAssertNotNil(slider?.buttonView)
        XCTAssertNotNil(slider)
        XCTAssertTrue(slider?.slideIsComplete == false)
        XCTAssertTrue(slider?.soundIsOn == true)
    }
    

    func testSetupPanGesture() {
        XCTAssertNotNil(slider?.setupPanGesture())
    }
    
    
    func testAddLabel() {
        let rect = CGRect(x: 20, y: 20, width: 50, height: 10)
        let label = slider?.addLabel(frame: rect, text: "Test", textColor: .green)
        XCTAssertNotNil(label)
        XCTAssertTrue(label?.text == "Test")
    }
    
    
    func testSlide() {
        slider?.setupSlider()
        let panRecognizer = UIPanGestureRecognizer(target: slider, action: #selector(slider?.slide(sender:)))
        slider?.buttonView.addGestureRecognizer(panRecognizer)
        XCTAssertTrue(((slider?.slide(sender: panRecognizer)) != nil))
    }
    
    
    func testUpdateSliderPosition() {
        let originalPosition = slider?.startPoint
        slider?.setupSlider()
        XCTAssertTrue(slider?.buttonView.frame.origin.x == originalPosition)
        let newPosition: CGFloat = 20.0
        slider?.update(position: newPosition)
        XCTAssertTrue(slider?.buttonView.frame.origin.x == newPosition)
    }
    
    
    func testSlideTo() {
        let originalPosition = slider?.startPoint
        slider?.setupSlider()
        XCTAssertTrue(slider?.buttonView.frame.origin.x == originalPosition)
        let newPosition: CGFloat = 20.0
        slider?.slideTo(position: newPosition, animated: true, completionHandler: { 
            _ in
            XCTAssertTrue(self.slider?.buttonView.frame.origin.x == newPosition)
        })
    }
    
    
    func testResetSlider() {
        slider?.setupSlider()
        let newPosition: CGFloat = 40.0
        slider?.slideTo(position: newPosition, animated: false, completionHandler: nil)
        XCTAssertTrue(self.slider?.buttonView.frame.origin.x == newPosition)
        slider?.resetSlider(animated: false)
        XCTAssertTrue(self.slider?.buttonView.frame.origin.x == slider?.startPoint)
    }
    
    
    func testDidCompleteSlide() {
        slider?.setupSlider()
        XCTAssertNil(slider?.player)
        slider?.didCompleteSlide()
        XCTAssertNotNil(slider?.player)
    }
    
    
    func testPlaySound() {
        XCTAssertNil(slider?.player)
        slider?.playSound()
        XCTAssertNotNil(slider?.player)
    }

    
    
    func testCalcualteAplha() {
        let expected = CGFloat(0.92)
        slider!.endPoint = 250.0
        let result = slider!.calcualteAplhaFor(position: CGFloat(10.0))
        XCTAssertTrue(result == expected)
    }
    
}
