//
//  CAMediaTimingFunction+Properties.swift
//  MemoryChainKit
//
//  Created by Marc Steven on 2020/3/19.
//  Copyright © 2020 Marc Steven(https://github.com/MarcSteven). All rights reserved.
//

import QuartzCore
import UIKit

public extension CAMediaTimingFunction {
    
    /// default time
        static let `default` = CAMediaTimingFunction(name: .default)
    
    /// linear
        static let linear = CAMediaTimingFunction(name: .linear)
    
    /// ease in
        static let easeIn = CAMediaTimingFunction(name: .easeIn)
    
    /// ease out
        static let easeOut = CAMediaTimingFunction(name: .easeOut)
    
    /// ease in ease out
        static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)
}



public extension CAMediaTimingFunction {
    
    /// duration percentage for position percentage
    /// - Parameters:
    ///   - positionPercentage: position percentage
    ///   - duration: duraton
    /// - Returns: return duration percentage
   func durationPercentageForPositionPercentage(_ positionPercentage: CGFloat, duration: CGFloat) -> CGFloat {
       // Finds the animation duration percentage that corresponds with the given animation "position" percentage.
       // Utilizes Newton's Method to solve for the parametric Bezier curve that is used by CAMediaAnimation.
       
       let controlPoints = self.controlPoints()
       let epsilon: CGFloat = 1.0 / (100.0 * CGFloat(duration))
       
       // Find the t value that gives the position percentage we want
       let t_found = solveTforY(positionPercentage, epsilon: epsilon, controlPoints: controlPoints)
       
       // With that t, find the corresponding animation percentage
       let durationPercentage = XforCurveAt(t_found, controlPoints: controlPoints)
       
       return durationPercentage
   }
    
    /// solveTForY
    /// - Parameters:
    ///   - y_0: Y0
    ///   - epsilon: epsilon
    ///   - controlPoints: control point
    /// - Returns: return  the point 
   func solveTforY(_ y_0: CGFloat, epsilon: CGFloat, controlPoints: [CGPoint]) -> CGFloat {
       // Use Newton's Method: http://en.wikipedia.org/wiki/Newton's_method
       // For first guess, use t = y (i.e. if curve were linear)
       var t0 = y_0
       var t1 = y_0
       var f0, df0: CGFloat
       
       for _ in 0..<15 {
           // Base this iteration of t1 calculated from last iteration
           t0 = t1
           // Calculate f(t0)
           f0 = YforCurveAt(t0, controlPoints:controlPoints) - y_0
           // Check if this is close (enough)
           if abs(f0) < epsilon {
               // Done!
               return t0
           }
           // Else continue Newton's Method
           df0 = derivativeCurveYValueAt(t0, controlPoints:controlPoints)
           // Check if derivative is small or zero ( http://en.wikipedia.org/wiki/Newton's_method#Failure_analysis )
           if abs(df0) < 1e-6 {
               break
           }
           // Else recalculate t1
           t1 = t0 - f0/df0
       }
       
       // Give up - shouldn't ever get here...I hope
       print("AutoScrollLabel: Failed to find t for Y input!")
       return t0
   }

   func YforCurveAt(_ t: CGFloat, controlPoints: [CGPoint]) -> CGFloat {
       let P0 = controlPoints[0]
       let P1 = controlPoints[1]
       let P2 = controlPoints[2]
       let P3 = controlPoints[3]
       
       // Per http://en.wikipedia.org/wiki/Bezier_curve#Cubic_B.C3.A9zier_curves
       let y0 = (pow((1.0 - t), 3.0) * P0.y)
       let y1 = (3.0 * pow(1.0 - t, 2.0) * t * P1.y)
       let y2 = (3.0 * (1.0 - t) * pow(t, 2.0) * P2.y)
       let y3 = (pow(t, 3.0) * P3.y)
       
       return y0 + y1 + y2 + y3
   }
   
   func XforCurveAt(_ t: CGFloat, controlPoints: [CGPoint]) -> CGFloat {
       let P0 = controlPoints[0]
       let P1 = controlPoints[1]
       let P2 = controlPoints[2]
       let P3 = controlPoints[3]
       
       // Per http://en.wikipedia.org/wiki/Bezier_curve#Cubic_B.C3.A9zier_curves
       let x0 = (pow((1.0 - t), 3.0) * P0.x)
       let x1 = (3.0 * pow(1.0 - t, 2.0) * t * P1.x)
       let x2 = (3.0 * (1.0 - t) * pow(t, 2.0) * P2.x)
       let x3 = (pow(t, 3.0) * P3.x)
       
       return x0 + x1 + x2 + x3
   }
   
   func derivativeCurveYValueAt(_ t: CGFloat, controlPoints: [CGPoint]) -> CGFloat {
       let P0 = controlPoints[0]
       let P1 = controlPoints[1]
       let P2 = controlPoints[2]
       let P3 = controlPoints[3]
       
       let dy0 = (P0.y + 3.0 * P1.y + 3.0 * P2.y - P3.y) * -3.0
       let dy1 = t * (6.0 * P0.y + 6.0 * P2.y)
       let dy2 = (-3.0 * P0.y + 3.0 * P1.y)

       return dy0 * pow(t, 2.0) + dy1 + dy2
   }
   
   func controlPoints() -> [CGPoint] {
       // Create point array to point to
       var point: [Float] = [0.0, 0.0]
       var pointArray = [CGPoint]()
       for i in 0...3 {
           self.getControlPoint(at: i, values: &point)
           pointArray.append(CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1])))
       }
       
       return pointArray
   }
}

