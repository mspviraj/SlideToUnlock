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
		// Do any additional setup after loading the view, typically from a nib.
	}

    
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    
    // MARK: - other
    @IBAction func resetTapped(_ sender: UIButton) {
        slider.resetSlider(animated: false)
    }

}

