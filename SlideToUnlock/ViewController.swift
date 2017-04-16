//
//  ViewController.swift
//  SlideToUnlock
//
//  Created by Dirk Gerretz on 08/03/2017.
//  Copyright © 2017 [code2 app];. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var slider: C2ASlider!

    
    // MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		slider.delegate = self
	}

    
    // MARK: - Actions
    @IBAction func resetTapped(_ sender: UIButton) {
        slider.resetSlider(animated: false)
    }

}


extension ViewController: C2ASliderDelegate {
    
    func didCompleteSlide(sender: C2ASlider) {
        print("Delegate: slide complete")
    }
    
    
    func didEndIncompleteSlide(sender: C2ASlider) {
        print("Delegate: did incomplete slide")
    }
    
}
