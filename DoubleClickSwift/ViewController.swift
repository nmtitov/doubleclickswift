//
//  ViewController.swift
//  DoubleClickSwift
//
//  Created by Nikita on 11/02/16.
//  Copyright © 2016 Nikita Mikhailovich Titov. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let touch = button.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().flatMapError { _ in SignalProducer<AnyObject?, NoError>.empty }
        let throttle = touch.throttle(0.25, onScheduler: QueueScheduler.mainQueueScheduler).map { _ in () }
        let touches = touch.takeUntil(throttle).collect().times(Int.max).map { $0.count }
        
        let click = touches.filter { $0 == 1 }.map { _ in "Click" }
        let clicks = touches.filter { $0 >= 2 }.map { "Clicks: \($0)" }
        let clear = touches.throttle(1, onScheduler: QueueScheduler.mainQueueScheduler).map { _ in "" }
        let text = SignalProducer(values: [click, clicks, clear]).flatten(.Merge)
        
        DynamicProperty(object: label, keyPath: "text") <~ text.map { $0 }
    }


}

