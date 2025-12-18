//
//  FlatCheckBoxThumb.swift
//  FlatCheckBox
//
//  Created by deya on 11/22/19.
//  Copyright © 2019 deyaeldeen. All rights reserved.
//

import Foundation
import UIKit

open class FlatCheckBoxThumb: UIView {
    
    var shadowOffsetX : CGFloat = -2 {
        didSet {
            self.layer.shadowOffset = .init(width: shadowOffsetX, height: 0)
        }
    }
    
    public lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        let bundle = Bundle(for: type(of: self))
        
        imageView.image = UIImage(named: "check", in: bundle, compatibleWith: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    fileprivate var sizeConstraint: NSLayoutConstraint?
    
    
    public var imageViewSizeRatio: CGFloat = 0.4 {
        didSet {
            if let constraint = sizeConstraint {
                NSLayoutConstraint.deactivate([constraint])
            }
            
            sizeConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageViewSizeRatio)
            sizeConstraint?.isActive = true
            layoutIfNeeded()
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2.0
    }
    
    func setup(){
        addSubview(imageView)
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 4.0
        self.layer.shadowOffset = .init(width: shadowOffsetX, height: 0)
        self.layer.shadowOpacity = 0.4
        
        self.imageView.tintColor = .white
        self.imageView.contentMode = .scaleAspectFit
        
        
        sizeConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: imageViewSizeRatio)
        sizeConstraint?.isActive = true
        
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
}
