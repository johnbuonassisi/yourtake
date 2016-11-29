//
//  PhotoPreviewViewController.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-26.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    
    // MARK: Members
    
    var imagePicker : UIImagePickerController?
    
    // MARK: Outlets
    
    @IBOutlet var previewView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet var overlayView: UIView!
    @IBOutlet weak var cropView: UIView!
    
    // MARK: Initializers
    
    // MARK: UIViewController Methods
    
    override func viewDidLoad() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentCamera()
        }
        
    }
    
    // MARK: UIImagePickerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // set picked image to previewImage
        var capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if imagePicker?.cameraDevice == .front {
            capturedImage = UIImage(cgImage: capturedImage!.cgImage!,
                                    scale: capturedImage!.scale,
                                    orientation: .leftMirrored)
        }
        let newBounds = CGRect(x: 0,
                               y: 0,
                               width: capturedImage!.size.width,
                               height: capturedImage!.size.width)
        
        let imageRef = capturedImage?.cgImage!.cropping(to: newBounds)
        let croppedImage = UIImage(cgImage: imageRef!,
                                   scale: capturedImage!.scale,
                                   orientation: capturedImage!.imageOrientation)
        
        
        // previewImage.contentMode = .scaleAspectFill
        // previewImage.clipsToBounds = true
        previewImage.image = croppedImage
        
        
        previewImage.setNeedsDisplay()
        dismiss(animated: true, completion: nil)
    }

    // MARK: Preview View Actions
    
    @IBAction func retake(_ sender: UIBarButtonItem) {
        presentCamera()
    }
    
    @IBAction func usePhoto(_ sender: UIBarButtonItem) {
        let covc = ChallengeOptionsViewController(withUser: "John")
        navigationController?.pushViewController(covc, animated: true)
    }
    
    // MARK: Camera View Actions
    
    @IBAction func cameraCancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: false)})
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        
        imagePicker?.takePicture()
    }
    
    @IBAction func changeCamera(_ sender: UIBarButtonItem) {
        
        if(imagePicker?.cameraDevice == .front) {
            imagePicker?.cameraDevice = .rear
        } else {
            imagePicker?.cameraDevice = .front
        }
        
    }
    
    private func presentCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.showsCameraControls = false
        imagePicker?.delegate = self
        
        Bundle.main.loadNibNamed("CameraOverlayView", owner: self, options: nil)
        overlayView.frame = imagePicker!.cameraOverlayView!.frame
        imagePicker!.cameraOverlayView = self.overlayView
        self.overlayView = nil // break a strong reference cycle
        
        // Why parent?? Because the view of this controller is detached??
        self.parent?.present(imagePicker!, animated: false, completion:nil)
    }
    
    
}
