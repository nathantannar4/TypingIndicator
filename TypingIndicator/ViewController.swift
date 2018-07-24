//
//  ViewController.swift
//  TypingIndicator
//
//  Created by Nathan Tannar on 2018-07-03.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let typingBubble = TypingBubble(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 60)))
    
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 44, weight: .medium)
        label.text = "TypingIndicator"
        label.textAlignment = .center
        view.addSubview(label)
        label.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        
        view.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        view.addSubview(typingBubble)
        typingBubble.center = CGPoint(x: view.center.x, y: view.center.y - 20)
        
        let bounceSwitch = UISwitch()
        bounceSwitch.isOn = typingBubble.typingIndicator.isBounceEnabled
        bounceSwitch.addTarget(self, action: #selector(toggleBounce), for: .valueChanged)
        let bounceLabel = UILabel()
        bounceLabel.textColor = .white
        bounceLabel.text = "isBounceEnabled"
        let stackViewA = UIStackView(arrangedSubviews: [bounceSwitch, bounceLabel])
        stackViewA.axis = .horizontal
        stackViewA.alignment = .fill
        stackViewA.distribution = .fill
        stackViewA.spacing = 8
        view.addSubview(stackViewA)
        stackViewA.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        stackViewA.center = CGPoint(x: view.center.x, y: view.center.y + 100)
        
        let fadeSwitch = UISwitch()
        fadeSwitch.isOn = typingBubble.typingIndicator.isFadeEnabled
        fadeSwitch.addTarget(self, action: #selector(toggleFade), for: .valueChanged)
        let fadeLabel = UILabel()
        fadeLabel.textColor = .white
        fadeLabel.text = "isFadeEnabled"
        let stackViewB = UIStackView(arrangedSubviews: [fadeSwitch, fadeLabel])
        stackViewB.axis = .horizontal
        stackViewB.alignment = .fill
        stackViewB.distribution = .fill
        stackViewB.spacing = 8
        view.addSubview(stackViewB)
        stackViewB.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        stackViewB.center = CGPoint(x: view.center.x, y: view.center.y + 140)
        
        let pulseSwitch = UISwitch()
        pulseSwitch.isOn = typingBubble.isPulseEnabled
        pulseSwitch.addTarget(self, action: #selector(togglePulse), for: .valueChanged)
        let pulseLabel = UILabel()
        pulseLabel.textColor = .white
        pulseLabel.text = "isPulseEnabled"
        let stackViewC = UIStackView(arrangedSubviews: [pulseSwitch, pulseLabel])
        stackViewC.axis = .horizontal
        stackViewC.alignment = .fill
        stackViewC.distribution = .fill
        stackViewC.spacing = 8
        view.addSubview(stackViewC)
        stackViewC.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        stackViewC.center = CGPoint(x: view.center.x, y: view.center.y + 180)
        
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Start Animating", for: .normal)
        button.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        view.addSubview(button)
        button.center = CGPoint(x: view.center.x, y: view.center.y + 220)

    }
    
    @objc
    func toggleAnimation() {
        if typingBubble.isAnimating {
            typingBubble.stopAnimating()
            button.setTitle("Start Animating", for: .normal)
        } else {
            typingBubble.startAnimating()
            button.setTitle("End Animating", for: .normal)
        }
    }

    @objc
    func toggleBounce() {
        typingBubble.typingIndicator.isBounceEnabled = !typingBubble.typingIndicator.isBounceEnabled
        restart()
    }
    
    @objc
    func toggleFade() {
        typingBubble.typingIndicator.isFadeEnabled = !typingBubble.typingIndicator.isFadeEnabled
        restart()
    }
    
    @objc
    func togglePulse() {
        typingBubble.isPulseEnabled = !typingBubble.isPulseEnabled
        restart()
    }
    
    func restart() {
        if typingBubble.isAnimating {
            typingBubble.stopAnimating()
            typingBubble.startAnimating()
        }
    }

}

