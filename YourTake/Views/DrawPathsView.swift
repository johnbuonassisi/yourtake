//
//  DrawPathsView.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-13.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

struct Path {
    var points: [CGPoint]
    var colour: UIColor
    var strokeSize : CGFloat
}

class DrawPathsView: UIView {
    
    // MARK: Private Constant Member Variables
    private let maxPointsInCurrentPath : Int = 50
    
    // MARK: Private Mutable Member Variables
    
    private var completedPaths: [Path] = [Path]()
    private var currentPath: Path?
    private var incrementalImage : UIImage?
    
    // MARK: Internal Member Variables
    
    var backgroundImage: UIImage?
    var currentStrokeColour: UIColor = UIColor.blue
    var currentStrokeSize: CGFloat = 8.0
    
    // MARK: Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = false
    }
    
    // MARK: Custom Drawing
    
    override func draw(_ rect: CGRect) {
        
        incrementalImage?.draw(in: rect)
        
        if let currentPath = currentPath {
            currentPath.colour.setStroke()
            stroke(withPath: currentPath)
        }
        
    }
    
    // MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        var currentPathPoints = [CGPoint]()
        currentPathPoints.append(touchLocation)
        currentPath = Path(points: currentPathPoints,
                           colour: currentStrokeColour,
                           strokeSize: currentStrokeSize)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        currentPath!.points.append(touchLocation)
        
        if(currentPath!.points.count > maxPointsInCurrentPath)
        {
            touchesEnded(touches, with: event)
            touchesBegan(touches, with: event)
            return
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        completedPaths.append(currentPath!)
        drawBitmap()
        setNeedsDisplay()
        currentPath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    // MARK: Internal Custom Methods
    
    func setBackground(withImage image: UIImage?) {
        
        backgroundImage = image
        
        drawBitmap()
        setNeedsDisplay()
    }
    
    func undo() {
        
        if(completedPaths.count > 0) {
            
            // Remove completed paths if they are connected to eachother
            
            var firstPointLastPath: CGPoint? // first point in last connected path
            var lastPointNextPath: CGPoint? // last point in the next connected path
            repeat {
                firstPointLastPath = completedPaths.removeLast().points[0]
                if completedPaths.count == 0 {
                    break
                }
                lastPointNextPath = completedPaths.last!.points.last
            } while firstPointLastPath == lastPointNextPath
        }
        
        // Create the new context using the saved background image and the remaining paths
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        backgroundImage?.draw(at: CGPoint.zero)
        backgroundImage?.draw(in: self.bounds)
        
        for path in completedPaths {
            stroke(withPath: path)
        }
        
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setNeedsDisplay()
    }
    
    // MARK: Private Custom Methods
    
    private func stroke(withPath path: Path?) {
        
        if let path = path {
            
            if path.points.count < 2 {
                return
            }
            
            let bp : UIBezierPath = UIBezierPath()
            bp.lineWidth = path.strokeSize
            bp.lineCapStyle = CGLineCap.round
            path.colour.setStroke()
        
            for index in 0...path.points.count - 2 {
                bp.move(to: path.points[index])
                bp.addLine(to: path.points[index+1])
                bp.stroke()
            }
        }
    }
    
    private func drawBitmap() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        
        if incrementalImage == nil {
            if backgroundImage == nil {
                let rectPath = UIBezierPath(rect: self.bounds)
                UIColor.white.setFill()
                rectPath.fill()
            }else {
                incrementalImage = backgroundImage
            }
        }
        incrementalImage?.draw(at: CGPoint.zero)
        incrementalImage?.draw(in: self.bounds)
        stroke(withPath: currentPath)
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }


}
