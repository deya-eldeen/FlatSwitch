//
//  FlatSwitchConfiguration.swift
//  FlatSwitch
//
//  Created by Hussein AlRyalat on 1/10/20.
//

import Foundation

public struct FlatSwitchConfiguration {
	
	public let disabledStateTitle: String?
	public let onStateLabel: String?
	public let offStateLabel: String?
	
	public let backgroundColor: UIColor?
	public let tintColor: UIColor?
	public let borderColor: UIColor?
	
	public let disabledStateLabelColor: UIColor?
	public let offThumbImage: UIImage?
	public let onThumbImage: UIImage?
	
	public static func `default`() -> FlatSwitchConfiguration {
		return .init(disabledStateTitle: "Disabled", onStateLabel: "On", offStateLabel: "Off", backgroundColor: UIColor.blue, tintColor: UIColor.blue, borderColor: UIColor.blue, disabledStateLabelColor: UIColor.white, offThumbImage: UIImage(named: "check"), onThumbImage: UIImage(named: "check"))
	}
}
