//
//  FlatSwitchConfiguration.swift
//  FlatSwitch
//
//  Created by Hussein AlRyalat on 1/10/20.
//

import Foundation

let defaultTint: UIColor = .lightGray

public struct FlatSwitchConfiguration {
	
	// thumb background color ( on, off )
	// thumb tint color ( on, off )
	// background color ( on, off )
	// border color ( off )
	// title color ( on, off, disabled )
	// title ( on, off, disabled )
	// title font

	public var backgroundColor: UIColor?
	public var title: String?
	public var thumbBackgroundColor: UIColor?
	public var thumbImage: UIImage?
	public var thumbTintColor: UIColor?
	public var titleColor: UIColor?
	
	public init(backgroundColor: UIColor?, title: String?, thumbBackgroundColor: UIColor?, thumbImage: UIImage?, thumbTintColor: UIColor?, titleColor: UIColor?){
		self.backgroundColor = backgroundColor
		self.title = title
		self.thumbBackgroundColor = thumbBackgroundColor
		self.thumbImage = thumbImage
		self.thumbTintColor = thumbTintColor
		self.titleColor = titleColor
	}
	
	public static func defaultOn() -> FlatSwitchConfiguration {
		let bundle = Bundle(for: FlatCheckBox.self)
		let image = UIImage(named: "check", in: bundle, compatibleWith: nil)
		
		return .init(backgroundColor: defaultTint, title: "On", thumbBackgroundColor: defaultTint, thumbImage: image, thumbTintColor: .white, titleColor: .white)
	}
	
	public static func defaultOff() -> FlatSwitchConfiguration {
		let bundle = Bundle(for: FlatCheckBox.self)
		let image = UIImage(named: "check", in: bundle, compatibleWith: nil)

		
		return .init(backgroundColor: .clear, title: "Off", thumbBackgroundColor: .lightGray, thumbImage: image, thumbTintColor: .white, titleColor: .lightGray)
	}
}

