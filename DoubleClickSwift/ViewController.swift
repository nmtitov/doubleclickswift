//
//  ViewController.swift
//  DoubleClickSwift
//
//  Created by Nikita on 11/02/16.
//  Copyright © 2016 Nikita Mikhailovich Titov. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let touch = button.rac_signalForControlEvents(.TouchUpInside)
        let touches = touch.takeUntil(touch.throttle(0.25)).collect()
        
        let click = touches.filter { $0.count == 1 }.mapReplace("Click")
        let clicks = touches.filter { $0.count >= 2 }.map { "Clicks: \($0.count)" }
        let clear = RACSignal.merge([click, clicks]).throttle(1).mapReplace("")
        
        let all = RACSignal.merge([click, clicks, clear]).map { $0 as AnyObject }
        
        let text = DynamicProperty(object:label, keyPath:"text")
        
    }


}

