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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func flatSwitchValueChanged(_ sender: FlatCheckBox) {
		sender.set(isOn: !sender.isOn, animated: true)
	}
	
	
	@IBAction func secondFlatSwitchValueChanged(_ sender: Any) {
		firstFlatSwitch.set(isEnabled: !firstFlatSwitch.isEnabled, animated: true)
	}
}

