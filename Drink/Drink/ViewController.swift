//
//  ViewController.swift
//  TestController
//
//  Created by muhlenXi on 2019/7/30.
//  Copyright © 2019 muhlenXi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //Counter outlets
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var graphView: GraphView!
    
    
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var medalView: MedalView!
    
    var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        counterLabel.text = String(counterView.counter)
        checkTotal()
    }
    
    func setupGraphDisplay() {
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        
        graphView.graphicPoints[graphView.graphicPoints.count-1] = counterView.counter
        graphView.setNeedsDisplay()
        
        maxLabel.text = "\(graphView.graphicPoints.max()!)"
        
        let average = graphView.graphicPoints.reduce(0, +) / graphView.graphicPoints.count
        averageWaterDrunk.text = "\(average)"
        
        let today = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        for i in 0...maxDayIndex {
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
                let label = stackView.arrangedSubviews[maxDayIndex-i] as? UILabel {
                label.text = formatter.string(from: date)
            }
        }
        
    }
    
    func checkTotal() {
        let show = counterView.counter >= 8
        medalView.showMedal(show: show)
    }

    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        
        if isGraphViewShowing {
            counterViewTap(nil)
        } else {
            setupGraphDisplay()
        }
        checkTotal()
    }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if isGraphViewShowing {
            // hide Graph
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            // show Graph
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        isGraphViewShowing = !isGraphViewShowing
    }

}

