//
//  C2ASlider.swift
//  SlideToUnlock
//
//  Created by Dirk Gerretz on 08/03/2017.
//  Copyright © 2017 [code2 app];. All rights reserved.
//


import UIKit
import AVFoundation

class C2ASlider: UIView {
	
	//MARK: - Properties
    let sliderText                  = "Jetzt einzahlen"
    var startPoint: CGFloat         = 0.0
    var endPoint: CGFloat           = 0.0
	var sliderEndPointX: CGFloat    = 0.0
    var offset: CGFloat             = 0.0
    var innerView: UIView!
    
    // Audio
    var player: AVAudioPlayer?
    
    
	//MARK: - Liefcycle
	override func awakeFromNib() {
		
		// add label to slider frame
		let labelFrame = CGRect(x: 0 , y: 0, width: self.frame.size.width, height: self.frame.size.height)
		self.addSubview(addLabel(frame: labelFrame, text: sliderText, textColor: .white))

		// add inner button to slider
		setupSlider()
	}
	
    
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	
    
	//MARK: - Slider
	func setupSlider(){
		self.addSubview(setupInnerView())
        endPoint = self.frame.size.width - innerView.frame.size.width
	}

    
    func setupInnerView() -> UIView {
        // the actual slider button
        let buttonHeight = self.frame.size.height
        let buttonWidth = buttonHeight * 1.5
        innerView = UIView(frame: CGRect(x: 0 , y: 0, width: buttonWidth, height: buttonHeight))
        innerView.backgroundColor = UIColor.orange
        innerView.cornerRadius = self.cornerRadius
        innerView.addSubview(addLabel(frame: innerView.frame, text: ">>>", textColor: .white))
        
        // add gesture recognizer
        innerView.addGestureRecognizer(setupPanGesture())
        
        return innerView
    }
    
   
    func setupPanGesture() -> UIPanGestureRecognizer {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.slide(sender:)))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        return panRecognizer
    }
    
    
    func addLabel(frame: CGRect, text: String, textColor: UIColor) -> UILabel{
		let label = UILabel(frame: frame)
		label.textAlignment = .center
		label.text = text
		label.textColor = textColor
		return label
	}
	
    
	func slide(sender: UIPanGestureRecognizer){
        
        let positionInSuperView = sender.view!.frame.origin.x
        let translation = sender.translation(in: sender.view?.superview)
        sender.setTranslation(CGPoint.zero, in: sender.view?.superview)
		let translatedPosition = translation.x
        
		if sender.state == .began {
            offset = translatedPosition
		}

        // allow sliding only to the right
        if translatedPosition <= 0 {return}
        
        print("PISV \(positionInSuperView); EP \(endPoint), TP: \(translatedPosition); State: \(sender.state)")

        // make sure slider is still within limits of its superview
		if ((sender.state == .changed) &&
            (sender.state != .failed)) {

            if ((positionInSuperView + translatedPosition) < endPoint) {
                sender.view!.frame.origin.x = positionInSuperView + translatedPosition
            }else if ((positionInSuperView + translatedPosition) > endPoint) {
                /* Move slider to far right position if last position is already 3/4 of the total distance.
                 * Otherwise move slider back to its starting position.
                 */
            }
        }
    }
    
    
    func slideToFarRightPosition(animated: Bool) {
        //TODO: implement me
    }
    
    
    func resetSlider(animated: Bool){
        startPoint         = 0.0
        sliderEndPointX    = 0.0
        offset             = 0.0
        innerView.frame.origin.x = startPoint
    }
    
    
    // MARK: - Sound
    func playSound()  {
        
        guard let url = Bundle.main.url(forResource: "unlock", withExtension: "mp3") else {
            print("url for sound file not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}


extension UIView {
	
	@IBInspectable var shadow: Bool {
		get {
			return layer.shadowOpacity > 0.0
		}
		set {
			if newValue == true {
				self.addShadow()
			}
		}
	}
	
    
	@IBInspectable var cornerRadius: CGFloat{
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
			
			// Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
			if shadow == false {
				self.layer.masksToBounds = false
			}
		}
	}
	
    
	func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
	               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
	               shadowOpacity: Float = 0.4,
	               shadowRadius: CGFloat = 3.0) {
		layer.shadowColor	= shadowColor
		layer.shadowOffset	= shadowOffset
		layer.shadowOpacity = shadowOpacity
		layer.shadowRadius	= shadowRadius
	}
    
}
