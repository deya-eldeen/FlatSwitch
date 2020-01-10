//
//  DisabledStateView.swift
//  FlatSwitch
//
//  Created by Hussein AlRyalat on 1/10/20.
//

import UIKit

class DisabledStateView: UIView {
	
	let label : UILabel = UILabel()
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override open func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height / 2.0
	}
	
	fileprivate func setup(){
		isUserInteractionEnabled = false
		label.translatesAutoresizingMaskIntoConstraints = false
		label.textAlignment = .center
		addSubview(label)
		
		[label.centerYAnchor.constraint(equalTo: centerYAnchor),
		 label.topAnchor.constraint(equalTo:     topAnchor),
		 label.centerXAnchor.constraint(equalTo: centerXAnchor),
		 label.leadingAnchor.constraint(equalTo: leadingAnchor)
		].forEach {
			$0.isActive = true
		}
		
		label.textColor = UIColor.white
		label.text = "Disabled"
		backgroundColor = .green
	}
}
