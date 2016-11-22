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
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: Private Member Variables
    private var prevTextFieldPosition : CGFloat?
    
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
                                  action: #selector(submitToChallenge))
        navigationItem.rightBarButtonItem = rbbi
        navigationItem.title = "Draw"
        
    }
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
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
    
    @IBAction func addTextButtonPressed(_ sender: UIButton) {
        textField.isHidden = false
        textField.becomeFirstResponder()
    }
    
    @IBAction func textFieldDragged(_ sender: Any, forEvent event: UIEvent) {
        
        if let point = event.allTouches?.first?.location(in: drawingView) {
            
            let textFrame = textField.frame
            let drawFrame = drawingView.frame
            
            let bottomOfDraw = drawFrame.height
            let topOfDraw = CGFloat(0.0)
            let bottomOfText = point.y + textFrame.height/2
            let topOfText = point.y - textFrame.height/2
            
            if bottomOfText <= bottomOfDraw &&
                topOfText >= topOfDraw {
                textField.center.y = point.y
            }
        }
    }
    
    @IBAction func textFieldTapped(_ sender: Any) {
        textField.becomeFirstResponder()
    }
    
    @IBAction func submitToChallenge() {
        
    }
    
    // MARK: Private Custom Methods
    
    private func setColourSliderTrackTint(withColour colour:UIColor) {
        colourSlider.minimumTrackTintColor = colour
        colourSlider.maximumTrackTintColor = colour
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            let keyboardHeight = keyboardFrame.height
            textField.frame.origin.y = view.frame.height - 65 - textField.frame.height - keyboardHeight
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
    }
    
}

extension DrawViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != nil {
            if textField.text!.isEmpty != true {
                textField.isHidden = false
            } else {
                textField.isHidden = true
            }
        }
        
        view.endEditing(true)
        return false
    }
}
