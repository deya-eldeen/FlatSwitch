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
	
	public var configuration: FlatSwitchConfiguration = .default() {
		didSet {
			set(isOn: isOn, animated: false)
		}
	}
	
	
	@IBInspectable var offColor : UIColor? {
		didSet {
			if !isOn {
				set(isOn: false, animated: true)
			}
		}
	}
	
	@IBInspectable var borderWidth : CGFloat {
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
			self.layer.borderColor = newValue?.cgColor
		}
		get {
			if let cgColor = self.layer.borderColor {
				return UIColor(cgColor: cgColor)
			}
			return nil
		}
	}
    
    var thumbEdgeConstraint : NSLayoutConstraint!
    var labelThumbConstraint : NSLayoutConstraint!
    var labelEdgeConstraint : NSLayoutConstraint!
    var thumbHeightConstraint: NSLayoutConstraint!


    private let backgroundView : UIView = UIView()
	private let disabledStateView: UIView = DisabledStateView()
    private let label : UILabel = UILabel()
    private let thumb = FlatCheckBoxThumb()
	
	private var _wasSettedByMethod = false
	private var _wasEnabledSettedByMethod = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
	
	public init(configuration: FlatSwitchConfiguration){
		self.configuration = configuration
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
        
		set(isEnabled: true, animated: false)
        set(isOn: true, animated: false)
        
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
	
	private func internal_set(isOn: Bool, animated: Bool){
		sendActions(for: .valueChanged)
		set(isOn: isOn, animated: animated)
	}
	
	open func set(isEnabled: Bool, animated: Bool){
		_wasEnabledSettedByMethod = true
		self.isEnabled = isEnabled
		
		if isEnabled {
			self.bringSubview(toFront: disabledStateView)
		}
		
		UIView.animate(withDuration: 0.3) {
			self.disabledStateView.alpha = isEnabled ? 0 : 1
			self.thumb.alpha = isEnabled ? 1 : 0
		}
	}
    
    open func set(isOn: Bool, animated: Bool){
        _wasSettedByMethod = true
        self.isOn = isOn
        
        let changesBlock = {
            self.backgroundView.backgroundColor = isOn ? self.tintColor : self.backgroundColor 
            self.thumb.backgroundColor = isOn ? self.tintColor : self.offColor
            self.label.textColor = isOn ? .white : self.offColor  
			self.label.text = isOn ? self.configuration.onStateLabel : self.configuration.offStateLabel
            self.thumb.shadowOffsetX = isOn ? -2 : 2
        }
        
        if animated {
            let animation = CABasicAnimation.init(keyPath: "borderColor")
            animation.fromValue = !isOn ? self.tintColor.cgColor : self.offColor?.cgColor
            animation.toValue = isOn ? self.tintColor.cgColor : self.offColor?.cgColor
            animation.duration = 0.3
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            self.backgroundView.layer.add(animation, forKey: "borderColorAnim")
            UIView.animate(withDuration: 0.3, animations: changesBlock)
        } else {
            self.backgroundView.layer.borderColor = isOn ? self.tintColor.cgColor : self.offColor?.cgColor
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

