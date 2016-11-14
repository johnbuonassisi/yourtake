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
}

class DrawPathsView: UIView {
    
    private var completedPaths: [Path] = [Path]()
    private var currentPath: Path?
    private var incrementalImage : UIImage?
    var backgroundImage: UIImage?
    
    // MARK: Custom Drawing
    
    override func draw(_ rect: CGRect) {
        
        incrementalImage?.draw(in: rect)
        
        if let currentPath = currentPath {
            stroke(withPath: currentPath)
        }
        
    }
    
    // MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        var currentPathPoints = [CGPoint]()
        currentPathPoints.reserveCapacity(1000)
        currentPathPoints.append(touchLocation)
        currentPath = Path(points: currentPathPoints)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        currentPath!.points.append(touchLocation)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        completedPaths.append(currentPath!)
        drawBitmap()
        setNeedsDisplay()
        currentPath = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // MARK: Internal Custom Methods
    
    func setBackground(withImage image: UIImage?) {
        backgroundImage = image
        drawBitmap()
        setNeedsDisplay()
    }
    
    func undo()
    {
        if completedPaths.count > 0 {
            completedPaths.removeLast()
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
        
    }
    
    // MARK: Private Custom Methods
    
    private func stroke(withPath path: Path?){
        
        if let path = path {
            let bp : UIBezierPath = UIBezierPath()
            bp.lineWidth = 10
            bp.lineCapStyle = CGLineCap.round
        
            for index in 0...path.points.count - 2 {
                bp.move(to: path.points[index])
                bp.addLine(to: path.points[index+1])
                bp.stroke()
            }
        }
    }
    
    private func drawBitmap() {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        UIColor.black.setStroke()
        
        if incrementalImage == nil {
            if backgroundImage == nil {
                let rectPath = UIBezierPath(rect: self.bounds)
                UIColor.white.setFill()
                rectPath.fill()
            }
            else
            {
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
