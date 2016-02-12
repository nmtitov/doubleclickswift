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

public extension SignalProducerType {
    @warn_unused_result
    public func debounce(interval: NSTimeInterval, onScheduler scheduler: DateSchedulerType) -> SignalProducer<Value, Error>
    {
        return flatMap(.Latest, transform: { next in
            SignalProducer(value: next).delay(interval, onScheduler: scheduler)
        })
    }
}

public extension SignalProducerType {
    @warn_unused_result
    public func debounce(interval: NSTimeInterval) -> SignalProducer<Value, Error>
    {
        return flatMap(.Latest, transform: { next in
            SignalProducer(value: next).delay(interval, onScheduler: QueueScheduler.mainQueueScheduler)
        })
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let touch = button.rac_signalForControlEvents(.TouchUpInside).toSignalProducer().flatMapError { _ in SignalProducer<AnyObject?, NoError>.empty }
        
        let delay = touch.debounce(0.25).map { _ in () }
        
        let touches = touch.takeUntil(delay).collect().times(Int.max).map { $0.count }
        
        let click = touches.filter { $0 == 1 }.map { _ in "Click" }
        let clicks = touches.filter { $0 >= 2 }.map { "Clicks: \($0)" }
        
        let clear = touches.debounce(1).map { _ in "" }
        
        let text = SignalProducer(values: [click, clicks, clear]).flatten(.Merge)
        
        DynamicProperty(object: label, keyPath: "text") <~ text.map { $0 }
    }


}

