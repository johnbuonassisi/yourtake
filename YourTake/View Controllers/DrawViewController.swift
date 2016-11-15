//
//  DrawViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-08.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController,
                          UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var drawingView: DrawPathsView!
    @IBOutlet weak var colourSlider: UISlider!
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var undoButton: UIButton!
    
    // MARK: Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        let rbbi = UIBarButtonItem(title: "Submit",
                                   style: UIBarButtonItemStyle.plain,
                                   target: self,
                                   action: nil)
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.title = "Draw"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let rbbi = UIBarButtonItem(title: "Submit",
                                  style: UIBarButtonItemStyle.plain,
                                  target: self,
                                  action: nil)
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.title = "Draw"
        
    }
    
    // MARK: Action Methods
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        drawingView.undo()
    }
    
    @IBAction func colourSliderValueChanged(_ sender: UISlider) {
        
        switch sender.value {
        case 0..<20:
            drawingView.currentStrokeColour = UIColor.yellow
            setColourSliderTrackTint(withColour: UIColor.yellow)
        case 20..<40:
            drawingView.currentStrokeColour = UIColor.red
            setColourSliderTrackTint(withColour: UIColor.red)
        case 40..<60:
            drawingView.currentStrokeColour = UIColor.blue
            setColourSliderTrackTint(withColour: UIColor.blue)
        case 60..<80:
            drawingView.currentStrokeColour = UIColor.green
            setColourSliderTrackTint(withColour: UIColor.green)
        default:
            drawingView.currentStrokeColour = UIColor.lightGray
            setColourSliderTrackTint(withColour: UIColor.lightGray)
        }
    }
    
    @IBAction func strokeSizeSliderValueChanged(_ sender: UISlider) {
        drawingView.currentStrokeSize = CGFloat(sender.value)
    }
    
    // MARK: Private Custom Methods
    
    private func setColourSliderTrackTint(withColour colour:UIColor) {
        colourSlider.minimumTrackTintColor = colour
        colourSlider.maximumTrackTintColor = colour
    }
}
