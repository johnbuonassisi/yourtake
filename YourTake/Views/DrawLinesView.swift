//
//  DrawView.swift
//  YourTake
//
//  Created by John Buonassisi on 2016-11-08.
//  Copyright © 2016 JAB. All rights reserved.
//

import UIKit

struct Line {
    var startPoint : CGPoint = CGPoint()
    var endPoint : CGPoint = CGPoint()
}

class DrawLinesView: UIView {
    
    var completedLines : [Line] = [Line]()
    var currentLine : Line?
    
    // Draw all the paths
    override func draw(_ rect: CGRect) {
        
        // Draw the completed lines
        for line in completedLines {
            strokeLine(line: line)
        }
        // Draw the current line
        if let currentLine = currentLine {
            strokeLine(line: currentLine)
        }
    }
    
    // Stroke a single path
    func strokeLine(line : Line){
        
        let bp : UIBezierPath = UIBezierPath()
        bp.lineWidth = 10
        bp.lineCapStyle = CGLineCap.round
        
        bp.move(to: line.startPoint)
        bp.addLine(to: line.endPoint)
        bp.stroke()
        
    }
    
    // Start a new path by recording the location of the touch
    // Set needs display to redraw view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let location : CGPoint = touch.location(in: self)
        
        if currentLine == nil {
            currentLine = Line()
        }
        currentLine?.startPoint = location
        currentLine?.endPoint = location
        
        self.setNeedsDisplay()
    }
    
    // Add a point to an existing path
    // Set needs display to redraw view
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let location : CGPoint = touch.location(in: self)
        
        currentLine?.endPoint = location
        self.setNeedsDisplay()
    }
    
    // Add the last point to the path
    // Set needs display to redraw view
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first!
        let location : CGPoint = touch.location(in: self)
        
        currentLine?.endPoint = location
        completedLines.append(currentLine!)
        self.setNeedsDisplay()
    }
    
    // Do something to handle a cancelled touch
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // Remove last path from the list and signal redraw
    func undo(){
    }
    
    // Provide access to view controller to change the colour of the current path
    func colourChangedTo(colour : UIColor){
        
    }

}
