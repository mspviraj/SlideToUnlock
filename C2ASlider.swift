//
//  C2ASlider.swift
//  SlideToUnlock
//
//  Created by Dirk Gerretz on 08/03/2017.
//  Copyright © 2017 [code2 app];. All rights reserved.
//


import UIKit
import AVFoundation


@objc protocol C2ASliderDelegate{
    func didCompleteSwipe(sender: C2ASlider)
    @objc optional func didInclompleteSwipe(sender: C2ASlider)
}


class C2ASlider: UIView {
	
	//MARK: - Properties
    var delegate: C2ASliderDelegate?
    
    let sliderText                  = "Jetzt einzahlen"
    var startPoint: CGFloat         = 0.0
    var endPoint: CGFloat           = 0.0
    var offset: CGFloat             = 0.0
    var buttonView: UIView!
    var mainLabel: UILabel?
    var player: AVAudioPlayer?
    
    
	//MARK: - Liefcycle
	override func awakeFromNib() {
		
		// add label to slider frame
		let labelFrame = CGRect(x: 0 , y: 0, width: self.frame.size.width, height: self.frame.size.height)
        mainLabel = addLabel(frame: labelFrame, text: sliderText, textColor: .white)
		self.addSubview(mainLabel!)

		// add inner button to slider
		setupSlider()
        
	}
	
    
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	
    
	//MARK: - Slider
	func setupSlider(){
		self.addSubview(setupInnerView())
    }

    
    func setupInnerView() -> UIView {
        // the actual slider button
        let buttonHeight = self.frame.size.height
        let buttonWidth = buttonHeight * 1.5
        buttonView = UIView(frame: CGRect(x: 0 , y: 0, width: buttonWidth, height: buttonHeight))
        buttonView.backgroundColor = UIColor.orange
        buttonView.cornerRadius = self.cornerRadius
        buttonView.addSubview(addLabel(frame: buttonView.frame, text: ">>>", textColor: .white))
        
        // add gesture recognizer
        buttonView.addGestureRecognizer(setupPanGesture())
        
        return buttonView
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

        // make sure slider is still within limits of its superview
		if ((sender.state == .changed) &&
            (sender.state != .failed)) {
            
            let newPosition = positionInSuperView + translatedPosition

            if (newPosition < endPoint) {
                if newPosition > endPoint - 4.0{
                    // end point is reached. Invoke action accordingly
                    delegate?.didCompleteSwipe(sender: self)
                    playSound()
                    return
                } else {
                    updateSliderPosition(position: newPosition)
                }
                
            }else if (newPosition > endPoint) {
                /* Move slider to far right position if last position is already 3/4 of the total distance.
                 * Otherwise move slider back to its starting position.
                 */
            }
        }            
    }
    
    func updateSliderPosition(position: CGFloat) {
        // dim label to be invisisble half the way
        mainLabel?.alpha = calcualteAplhaFor(position: position)
        
        // redraw slider button
        buttonView.frame.origin.x = position
        
    }
    
    func slideToFarRightPosition(animated: Bool) {
        //TODO: implement me
    }
    
    
    func resetSlider(animated: Bool){
        mainLabel?.alpha   = 1.0
        startPoint         = 0.0
        offset             = 0.0
        buttonView.frame.origin.x = startPoint
    }
    
    
    // MARK: - Sound
    func playSound()  {
        
        guard let url = Bundle.main.url(forResource: "unlock", withExtension: "mp3") else {
            print("sound file missing?!")
            return
        }
        
        if player == nil {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
                
                /// change fileTypeHint according to the type of your audio file (you can omit this)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
        
        player!.play()
    }
    
    
    
    // MARK: - Main Label
    
    /*
     * Convert slider width to alpha value to fade in/out the main label
     * depending on the position of the slider. 0% distance = 1.0 alpha
     */
    func calcualteAplhaFor(position: CGFloat) -> CGFloat {
        // leave alpha at max if endpoint has not been set yet
        if endPoint == 0.0 {return CGFloat(1.0)}
        
        // devide endPoint /2 so alpha is down to 0% when the slider reaches 
        // half the distance
        return 1.0 - (CGFloat(position / (endPoint / 2)))
    }
    
    // redraw label upon orientation change
    override func layoutSubviews() {
        endPoint = self.frame.size.width - buttonView.frame.size.width
        if let label = mainLabel {
            label.frame = self.bounds
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
