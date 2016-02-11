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
        let touches = touch.takeUntil(touch.throttle(0.25)).collect().map({ $0.count }).`repeat`()
        
        let click = touches.filter { $0 as! Int == 1 }.mapReplace("Click")
        let clicks = touches.filter { $0 as! Int >= 2 }.map { "Clicks: \($0)" }
        let clear = RACSignal.merge([click, clicks]).throttle(1).mapReplace("")
        
        let all = RACSignal.merge([click, clicks, clear])
        
        all.subscribeNext { (next: AnyObject!) -> Void in
            self.label.text = next as! String
        }

    }


}

