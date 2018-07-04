//
//  TypingIndicator.swift
//  MessageKit
//
//  Created by Nathan Tannar on 2018-06-20.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit

/// A `UIView` subclass that maintains a mask to keep it fully circular
open class Circle: UIView {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = roundedMask(corners: .allCorners, radius: bounds.height / 2)
    }
    
    open func roundedMask(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        return mask
    }
    
}

/// A `UIView` subclass that holds 3 dots which can be animated
open class TypingIndicator: UIView {
    
    // MARK: - Properties
    
    /// The offset that each dot will transform by during the bounce animation
    open var bounceOffset: CGFloat = 7.5
    
    /// A convenience accessor for the `backgroundColor` of each dot
    open var dotColor: UIColor = UIColor.lightGray {
        didSet {
            dots.forEach { $0.backgroundColor = dotColor }
        }
    }
    
    /// A flag that determines if the bounce animation is added in `startAnimating()`
    open var isBounceEnabled: Bool = false
    
    /// A flag that determines if the opacity animation is added in `startAnimating()`
    open var isFadeEnabled: Bool = true
    
    /// A flag indicating the animation state
    public private(set) var isAnimating: Bool = false
    
    /// Keys for each animation layer
    private struct AnimationKeys {
        static let bounce = "typingIndicator.bounce"
        static let opacity = "typingIndicator.opacity"
    }
    
    // MARK: - Subviews

    public let stackView = UIStackView()
    
    public let dots: [Circle] = {
        return [Circle(), Circle(), Circle()]
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /// Sets up the view
    private func setupView() {
        dots.forEach {
            $0.backgroundColor = dotColor
            $0.heightAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
        stackView.spacing = bounds.width > 0 ? 5 : 0
    }
    
    // MARK: - Animation Layers
    
    /// The `CABasicAnimation` applied when `isBounceEnabled` is TRUE
    ///
    /// - Returns: `CABasicAnimation`
    open func bounceAnimationLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.byValue = -bounceOffset
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    /// The `CABasicAnimation` applied when `isFadeEnabled` is TRUE
    ///
    /// - Returns: `CABasicAnimation`
    open func opacityAnimationLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    // MARK: - Animation API
    
    /// Sets the state of the `TypingIndicator` to animating and applies animation layers
    open func startAnimating() {
        defer { isAnimating = true }
        guard !isAnimating else { return }
        var delay: TimeInterval = 0
        for dot in dots {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                guard let this = self else { return }
                if this.isBounceEnabled {
                    dot.layer.add(this.bounceAnimationLayer(), forKey: AnimationKeys.bounce)
                }
                if this.isFadeEnabled {
                    dot.layer.add(this.opacityAnimationLayer(), forKey: AnimationKeys.opacity)
                }
            }
            delay += 0.33
        }
    }
    
    /// Sets the state of the `TypingIndicator` to not animating and removes animation layers
    open func stopAnimating() {
        defer { isAnimating = false }
        guard isAnimating else { return }
        dots.forEach {
            $0.layer.removeAnimation(forKey: AnimationKeys.bounce)
            $0.layer.removeAnimation(forKey: AnimationKeys.opacity)
        }
    }
    
}

/// A `UIView` subclass that mimics the design of the typing bubble in iMessage
open class TypingBubble: UIView {
    
    // MARK: - Properties
    
    /// A flag that determines if the pulse animation is added in `startAnimating()`
    open var isPulseEnabled: Bool = true
    
    /// A flag indicating the animation state
    public private(set) var isAnimating: Bool = false
    
    /// Keys for each animation layer
    private struct AnimationKeys {
        static let pulse = "typingBubble.pulse"
    }
    
    // MARK: - Subviews
    
    /// A `UIView` subclass that holds 3 dots which can be animated
    open let typingIndicator = TypingIndicator()
    
    /// The main bubble that holds the `TypingIndicator`
    open let messageContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
        return view
    }()
    
    /// The lower left hand corner bubble that overlaps the `messageContainerView`
    open let cornerBubble: Circle = {
        let view = Circle()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
        return view
    }()
    
    /// The bottom left hand dot
    open let tinyBubble: Circle = {
        let view = Circle()
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
        return view
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    /// Sets up the view
    private func setupView() {
        addSubview(tinyBubble)
        addSubview(cornerBubble)
        addSubview(messageContainerView)
        messageContainerView.addSubview(typingIndicator)
    }
    
    // MARK: - Layout
    
    /// Lays out each of the bubbles
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // To maintain the iMessage like bubble the width:height ratio of the frame
        // must be close to 1.65
        let ratio = bounds.width / bounds.height
        let extraRightInset = bounds.width - 1.65/ratio*bounds.width
        
        let tinyBubbleRadius: CGFloat = bounds.height / 6
        tinyBubble.frame = CGRect(x: 0,
                                  y: bounds.height - tinyBubbleRadius,
                                  width: tinyBubbleRadius,
                                  height: tinyBubbleRadius)
        
        let cornerBubbleRadius = tinyBubbleRadius * 1.75
        let offset: CGFloat = tinyBubbleRadius / 6
        cornerBubble.frame = CGRect(x: tinyBubbleRadius - offset,
                                    y: bounds.height - (1.5 * cornerBubbleRadius) + offset,
                                    width: cornerBubbleRadius,
                                    height: cornerBubbleRadius)
        
        let msgFrame = CGRect(x: tinyBubbleRadius + offset,
                              y: 0,
                              width: bounds.width - (tinyBubbleRadius + offset) - extraRightInset,
                              height: bounds.height - tinyBubbleRadius + offset)
        let msgFrameCornerRadius = msgFrame.height / 2
        
        messageContainerView.frame = msgFrame
        messageContainerView.layer.cornerRadius = msgFrameCornerRadius
        
        
        let insets = UIEdgeInsets(top: offset, left: msgFrameCornerRadius / 1.5, bottom: offset, right: msgFrameCornerRadius / 1.5)
        typingIndicator.frame = CGRect(x: insets.left,
                                       y: insets.top,
                                       width: msgFrame.width - insets.left - insets.right,
                                       height: msgFrame.height - insets.top - insets.bottom)
    }
    
    // MARK: - Animation Layers
    
    /// The `CABasicAnimation` applied when `isPulseEnabled` is TRUE
    ///
    /// - Returns: `CABasicAnimation`
    open func pulseAnimationLayer() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = 1.05
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.autoreverses = true
        return animation
    }
    
    // MARK: - Animation API
    
    /// Sets the state of the `TypingIndicator` and `TypingBubble` to animating
    /// and applies animation layers
    open func startAnimating() {
        typingIndicator.startAnimating()
        defer { isAnimating = true }
        guard !isAnimating else { return }
        if isPulseEnabled {
            layer.add(pulseAnimationLayer(), forKey: AnimationKeys.pulse)
        }
    }
    
    /// Sets the state of the `TypingIndicator` and `TypingBubble` to not animating
    /// and removes animation layers
    open func stopAnimating() {
        typingIndicator.stopAnimating()
        defer { isAnimating = false }
        guard isAnimating else { return }
        layer.removeAnimation(forKey: AnimationKeys.pulse)
    }
    
}
