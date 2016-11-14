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

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var drawingView: DrawPathsView!
    @IBOutlet weak var colourSlider: UISlider!
    @IBOutlet weak var colourDisplay: UIImageView!
    @IBOutlet weak var brushSlider: UISlider!
    @IBOutlet weak var brushDisplay: UIImageView!
    @IBOutlet weak var undoButton: UIButton!
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        drawingView.undo()
    }
}
