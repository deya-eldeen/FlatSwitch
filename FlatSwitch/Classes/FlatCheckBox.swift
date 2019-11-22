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
    
    var thumbEdgeConstraint : NSLayoutConstraint!
    var labelThumbConstraint : NSLayoutConstraint!
    var labelEdgeConstraint : NSLayoutConstraint!
    var thumbHeightConstraint: NSLayoutConstraint!

    
    @IBInspectable var offColor : UIColor?

    private let backgroundView : UIView = UIView()
    private let label : UILabel = UILabel()

    private let thumb = FlatCheckBoxThumb()
    
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
    
    fileprivate var _wasSettedByMethod = false
    
    @IBInspectable open var isOn : Bool = true {
        didSet {
            if _wasSettedByMethod {
                _wasSettedByMethod = false
                return
            }
                
            set(isOn: isOn, animated: false)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView.layer.cornerRadius = self.frame.height / 2.0
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        set(isOn: !self.isOn, animated: true)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    private func setupConstraints(){
        thumb.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        backgroundView.translatesAutoresizingMaskIntoConstraints = false

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
        
        
        for constraint in thumbConstraints {
            constraint.isActive = true
        }
        
        for constraint in labelConstraints {
            constraint.isActive = true
        }
        
        for constraint in backgroundViewConstraints {
            constraint.isActive = true
        }
        
    }
    
    fileprivate func setup(){
        backgroundView.isUserInteractionEnabled = true
        
        addSubview(backgroundView)
        addSubview(label)
        addSubview(thumb)
        setupConstraints()
        
        set(isOn: true, animated: false)
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
    }
    
    open func set(isOn: Bool, animated: Bool){
        _wasSettedByMethod = true
        self.isOn = isOn
        
        let changesBlock = {
            self.backgroundView.backgroundColor = isOn ? self.tintColor : self.backgroundColor 
            self.thumb.backgroundColor = isOn ? self.tintColor : self.offColor
            self.label.textColor = isOn ? .white : self.offColor  
            self.label.text = isOn ? "ON" : "OFF"
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

