//
//  CreateTakeViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2017-04-12.
//  Copyright © 2017 Enovi Inc. All rights reserved.
//

import UIKit

class CreateTakeViewController: UIViewController,
                                UINavigationControllerDelegate {
  // MARK: Members
  
  @IBOutlet weak var drawingView: DrawPathsView!
  @IBOutlet weak var colourSlider: UISlider!
  @IBOutlet weak var brushSlider: UISlider!
  @IBOutlet weak var undoButton: UIButton!
  @IBOutlet weak var textField: UITextField!
  
  private var prevTextFieldPosition : CGFloat?
    private var wasTextFieldDragged = false
  
  private let challengeId: String
  private let challengeImage: UIImage
  
  // MARK: Initializers
  
  init(challengeId: String, challengeImage: UIImage) {
    
    self.challengeId = challengeId
    self.challengeImage = challengeImage
    
    super.init(nibName: "CreateTakeViewController", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: UIViewController methods
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    drawingView.setBackground(withImage: challengeImage)
    
    let rbbi = UIBarButtonItem(title: "Submit",
                               style: UIBarButtonItemStyle.plain,
                               target: self,
                               action: #selector(submitToChallenge))
    navigationItem.rightBarButtonItem = rbbi
    navigationItem.title = "Your Take"
    
    textField.delegate = self
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
        wasTextFieldDragged = true;
    }
  }
  
  
  @IBAction func textFieldTapped(_ sender: Any) {
    if !wasTextFieldDragged {
        textField.becomeFirstResponder()
    } else {
        wasTextFieldDragged = false
    }
  }
  
  @IBAction func submitToChallenge() {
    
    // Get snapshot of current view hierarchy
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let drawImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    // Only save the image portion of the view
    let imageRect = CGRect(x: 0,
                           y: Int(65*drawImage!.scale),
                           width: drawImage!.cgImage!.width,
                           height: drawImage!.cgImage!.width)
    let imageRef = drawImage?.cgImage?.cropping(to: imageRect)
    
    let newImage = UIImage(cgImage: imageRef!,
                           scale: drawImage!.scale,
                           orientation: drawImage!.imageOrientation)
    

    let take = TakeDto(id: "", challengeId: challengeId, imageId: "", author: "", votes: 0)
    take.overlay = newImage
    let backendClient = Backend.sharedInstance.getClient()
    backendClient.createTake(take, completion: { (success) -> Void in
      if(success) {
        print("Take successfuly created")
      } else {
        print("Error creating take")
      }
    })
    let _ = navigationController?.popToRootViewController(animated: false)
  }
  
  // MARK: Private Custom Methods
  
  private func setColourSliderTrackTint(withColour colour:UIColor) {
    colourSlider.minimumTrackTintColor = colour
    colourSlider.maximumTrackTintColor = colour
  }
}

extension CreateTakeViewController: UITextFieldDelegate {
  
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

