//
//  ViewController.swift
//  FlatSwitch
//
//  Created by deya-eldeen on 11/22/2019.
//  Copyright (c) 2019 deya-eldeen. All rights reserved.
//

import UIKit
import FlatSwitch

class ViewController: UIViewController {

	
	@IBOutlet weak var firstFlatSwitch: FlatCheckBox!
	@IBOutlet weak var secondFlatSwitch: FlatCheckBox!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		let turquise = UIColor(red: 0.10588, green: 0.73725, blue: 0.61176, alpha: 1.0)
		let blue = UIColor(red: 0.16078, green: 0.50196, blue: 0.72549, alpha: 1.0)
		let lightGray = UIColor(red: 0.74117, green: 0.76470, blue: 0.78039, alpha: 1.0)
		
		firstFlatSwitch.onConfiguration = .init(backgroundColor: turquise,
												title: "Hola",
												thumbBackgroundColor: turquise,
												thumbImage: UIImage(named: "check"),
												thumbTintColor: .white,
												titleColor: .white)
		firstFlatSwitch.offConfiguration = .init(backgroundColor: .white,
												 title: "Off",
												 thumbBackgroundColor: lightGray,
												 thumbImage: UIImage(named: "check"),
												 thumbTintColor: .white,
												 titleColor: lightGray)
		firstFlatSwitch.offBorderColor = lightGray
		firstFlatSwitch.disabledBackgroundColor = turquise.withAlphaComponent(0.75)
		firstFlatSwitch.labelFont = UIFont.systemFont(ofSize: 15, weight: .medium)
		firstFlatSwitch.disabledTitle = "Disabled"
		
		secondFlatSwitch.onConfiguration.backgroundColor = blue
		secondFlatSwitch.onConfiguration.thumbBackgroundColor = blue
		secondFlatSwitch.onConfiguration.title = "Enabled"
		secondFlatSwitch.offConfiguration.title = "Disabled"
    }

	@IBAction func flatSwitchValueChanged(_ sender: FlatCheckBox) {
	}
	
	
	@IBAction func secondFlatSwitchValueChanged(_ sender: FlatCheckBox) {
		firstFlatSwitch.set(isEnabled: sender.isOn, animated: true)
	}
}

