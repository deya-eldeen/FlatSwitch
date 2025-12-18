//
//  FlatCheckBox.swift
//  FlatCheckBox
//
//  Created by deya on 11/22/19.
//  Copyright © 2019 deyaeldeen. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable open class FlatCheckBox: UIControl {
	

	//MARK: Properties
	
	open override var isEnabled: Bool {
		didSet {
			if _wasEnabledSettedByMethod {
				_wasEnabledSettedByMethod = false
				return
			}
			
			set(isEnabled: isEnabled, animated: false)
		}
	}
	
	public var onConfiguration: FlatSwitchConfiguration = .defaultOn() {
		didSet {
			reloadForConfiguration()
		}
	}
	
	public var offConfiguration: FlatSwitchConfiguration = .defaultOff() {
		didSet {
			reloadForConfiguration()
		}
	}
	
	
	public var labelFont: UIFont = .systemFont(ofSize: 15, weight: .medium) {
		didSet {
			label.font = labelFont
			disabledStateView.label.font = labelFont
		}
	}
	
	public var offBorderColor: UIColor? = .lightGray {
		didSet {
			if !isOn {
				borderColor = offBorderColor
			}
		}
	}
	
	// default to be the background color, dimmed with 0.3 alpha
	public var disabledBackgroundColor: UIColor? {
		didSet {
			disabledStateView.backgroundColor = disabledBackgroundColor
		}
	}
	
	public var disabledTitle: String? {
		didSet {
			disabledStateView.label.text = disabledTitle
		}
	}
	
	@IBInspectable public var borderWidth : CGFloat {
		set {
			self.backgroundView.layer.borderWidth = newValue
			
			if !isOn {
				thumbHeightConstraint.constant = -borderWidth
				layoutIfNeeded()
			}
		}
		
		get {
			return self.backgroundView.layer.borderWidth
		}
	}
	
	
	@IBInspectable open var isOn : Bool = true {
		didSet {
			if _wasSettedByMethod {
				_wasSettedByMethod = false
				return
			}
			
			set(isOn: isOn, animated: false)
		}
	}

	
	private var borderColor : UIColor? {
		set {
			self.backgroundView.layer.borderColor = newValue?.cgColor
		}
		get {
			if let cgColor = self.backgroundView.layer.borderColor {
				return UIColor(cgColor: cgColor)
			}
			return nil
		}
	}
    
    var thumbEdgeConstraint : NSLayoutConstraint!
    var labelThumbConstraint : NSLayoutConstraint!
    var labelEdgeConstraint : NSLayoutConstraint!
    var thumbHeightConstraint: NSLayoutConstraint!


	private let backgroundView: UIView = .init()
	private let disabledStateView: DisabledStateView = .init()
	private let label: UILabel = .init()
	private let thumb: FlatCheckBoxThumb = .init()
	
	private var _wasSettedByMethod = false
	private var _wasEnabledSettedByMethod = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
	
	public init(onConfiguration: FlatSwitchConfiguration, offConfiguration: FlatSwitchConfiguration){
		self.onConfiguration = onConfiguration
		self.offConfiguration = offConfiguration
		super.init(frame: .zero)
		setup()
	}

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		self.backgroundView.layer.cornerRadius = self.frame.height / 2.0
	}
    
    private func setupConstraints(){
        thumb.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
		disabledStateView.translatesAutoresizingMaskIntoConstraints = false

        thumbHeightConstraint = thumb.heightAnchor.constraint(equalTo: self.heightAnchor)
        thumbHeightConstraint.isActive = true
        
        let thumbConstraints = [
            thumb.centerYAnchor.constraint(equalTo:     self.centerYAnchor),
            thumb.widthAnchor.constraint(equalTo:       thumb.heightAnchor),
        ]
        

        let labelConstraints = [
            label.centerYAnchor.constraint(equalTo:     self.centerYAnchor),
            label.heightAnchor.constraint(equalTo:      self.heightAnchor)
        ]
        
        let backgroundViewConstraints = [
            backgroundView.trailingAnchor.constraint(equalTo:   self.trailingAnchor, constant: 0),
            backgroundView.leadingAnchor.constraint(equalTo:    self.leadingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo:        self.topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo:     self.bottomAnchor, constant: 0)
        ]
        
		let disabledViewConstraints = [
			disabledStateView.trailingAnchor.constraint(equalTo:   self.trailingAnchor, constant: 0),
			disabledStateView.leadingAnchor.constraint(equalTo:    self.leadingAnchor, constant: 0),
			disabledStateView.topAnchor.constraint(equalTo:        self.topAnchor, constant: 0),
			disabledStateView.bottomAnchor.constraint(equalTo:     self.bottomAnchor, constant: 0)
		]
		
		(thumbConstraints + labelConstraints + backgroundViewConstraints + disabledViewConstraints).forEach {
			$0.isActive = true
		}
    }
    
    fileprivate func setup(){
        backgroundView.isUserInteractionEnabled = true
        
        addSubview(backgroundView)
        addSubview(label)
        addSubview(thumb)
		addSubview(disabledStateView)
        setupConstraints()

		borderColor = offBorderColor
		set(isEnabled: isEnabled, animated: false)
        set(isOn: isOn, animated: false)
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
		setupGestureRecognizers()
    }
	
	@objc func didTap(){
		internal_set(isOn: !self.isOn, animated: true)
	}
	
	@objc func didSwipe(sender: UISwipeGestureRecognizer){
		switch (sender.direction, isOn) {
		case (.right, false):
			internal_set(isOn: true, animated: true)
		case (.left, true):
			internal_set(isOn: false, animated: true)
		default:
			break
		}
	}
	
	fileprivate func setupGestureRecognizers(){
		let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
		let rightSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipe))
		rightSwipeGesture.direction = .right
		let leftSwipeGesture = UISwipeGestureRecognizer.init(target: self, action: #selector(didSwipe))
		leftSwipeGesture.direction = .left
		
		[tapGesture,rightSwipeGesture,leftSwipeGesture].forEach { gesture in
			self.addGestureRecognizer(gesture)
		}
		
	}
	
	private func reloadForConfiguration(){
		set(isOn: isOn, animated: false)
	}
	
	private func internal_set(isOn: Bool, animated: Bool){
		set(isOn: isOn, animated: animated)
		sendActions(for: .valueChanged)
	}
	
	open func set(isEnabled: Bool, animated: Bool){
		_wasEnabledSettedByMethod = true
		self.isEnabled = isEnabled
		
		if isEnabled {
			self.bringSubview(toFront: disabledStateView)
		}
		
		let changesBlock = {
			self.disabledStateView.alpha = isEnabled ? 0 : 1
			self.backgroundView.alpha = isEnabled ? 1 : 0
			self.label.alpha = isEnabled ? 1 : 0
			self.thumb.alpha = isEnabled ? 1 : 0
		}
		
		if animated {
			UIView.animate(withDuration: 0.3, animations: changesBlock)
		} else {
			changesBlock()
		}
	}
    
    open func set(isOn: Bool, animated: Bool){
        _wasSettedByMethod = true
        self.isOn = isOn
        
        let changesBlock = {
			self.backgroundView.backgroundColor = isOn ? self.onConfiguration.backgroundColor : self.offConfiguration.backgroundColor
			self.thumb.backgroundColor = isOn ? self.onConfiguration.thumbBackgroundColor : self.offConfiguration.thumbBackgroundColor
			self.thumb.imageView.image = isOn ? self.onConfiguration.thumbImage : self.offConfiguration.thumbImage
			
			self.label.textColor = isOn ? self.onConfiguration.titleColor : self.offConfiguration.titleColor
			self.label.text = isOn ? self.onConfiguration.title : self.offConfiguration.title
            self.thumb.shadowOffsetX = isOn ? -2 : 2
        }
        
        if animated {
            let animation = CABasicAnimation.init(keyPath: "borderColor")
            animation.fromValue = !isOn ?  self.onConfiguration.backgroundColor?.cgColor : self.offBorderColor?.cgColor
            animation.toValue = isOn ?  self.onConfiguration.backgroundColor?.cgColor : self.offBorderColor?.cgColor
            animation.duration = 0.3
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            self.backgroundView.layer.add(animation, forKey: "borderColorAnim")
            UIView.animate(withDuration: 0.3, animations: changesBlock)
        } else {
			self.backgroundView.layer.borderColor = isOn ? self.onConfiguration.backgroundColor?.cgColor : self.offBorderColor?.cgColor
            changesBlock()
        }
        
        setConstraintsForIsOn(isOn, animated: animated)
    }
    
    fileprivate func setConstraintsForIsOn(_ isOn: Bool, animated: Bool){

        thumbHeightConstraint.constant = isOn ? 0 : -borderWidth/2.0
        
        if thumbEdgeConstraint != nil {
            NSLayoutConstraint.deactivate([
                thumbEdgeConstraint,
                labelThumbConstraint,
                labelEdgeConstraint
            ])
        }
        
        
        if (isOn){
            thumbEdgeConstraint = thumb.trailingAnchor.constraint(equalTo:    self.trailingAnchor)
            labelThumbConstraint = label.trailingAnchor.constraint(equalTo:    thumb.leadingAnchor, constant: -8)
            labelEdgeConstraint = label.leadingAnchor.constraint(equalTo:     self.leadingAnchor, constant: 8)
        } else {
            thumbEdgeConstraint = thumb.leadingAnchor.constraint(equalTo:    self.leadingAnchor)
            labelThumbConstraint = label.leadingAnchor.constraint(equalTo:    thumb.trailingAnchor, constant: 8)
            labelEdgeConstraint = label.trailingAnchor.constraint(equalTo:     self.trailingAnchor, constant: -8)
        }
        
        NSLayoutConstraint.activate([
            thumbEdgeConstraint,
            labelThumbConstraint,
            labelEdgeConstraint
        ])
        
        if animated {
            UIView.animate(withDuration: 0.3) { 
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
}

