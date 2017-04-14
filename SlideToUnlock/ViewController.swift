//
//  ViewController.swift
//  SlideToUnlock
//
//  Created by Dirk Gerretz on 08/03/2017.
//  Copyright © 2017 [code2 app];. All rights reserved.
//

import UIKit

class ViewController: UIViewController, C2ASliderDelegate {

    // MARK: - Properties
    @IBOutlet weak var slider: C2ASlider!

    
    // MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		slider.delegate = self
	}

    
    // MARK: - other
    @IBAction func resetTapped(_ sender: UIButton) {
        slider.resetSlider(animated: false)
    }

    
    // MARK: - Slider Delegate
    func didCompleteSlide(sender: C2ASlider) {
        print("VC: slide complete")
    }
    
    
    func didEndIncompleteSlide(sender: C2ASlider) {
        print("VC: did incomplete slide")
    }
    
}

