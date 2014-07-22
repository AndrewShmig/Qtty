//
//  NAGGridView.swift
//  Qtty
//
//  Created by AndrewShmig on 22/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class NAGGridView: UIView {
  
  let kVisualBlocks: CGFloat = 3
  
  init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.clearColor()
  }
  
  override func drawRect(rect: CGRect)
  {
    let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
    let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
    let context = UIGraphicsGetCurrentContext()
    
    CGContextSetLineWidth(context, 1.0)
    CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
    
    // чертим горизонтальные линии (портретный режим)
    let horizontalLines = screenHeight / kVisualBlocks
    let countHLines = screenHeight / horizontalLines
    for i in 1..<countHLines {
      CGContextMoveToPoint(context, 0, i * horizontalLines)
      CGContextAddLineToPoint(context, screenWidth, i * horizontalLines)
    }
    
    // чертим вертикальные линиии (портретный режим)
    let verticalLines = screenWidth / kVisualBlocks
    let countVLines = screenWidth / verticalLines
    for i in 1..<countVLines {
      CGContextMoveToPoint(context, i * verticalLines, 0)
      CGContextAddLineToPoint(context, i * verticalLines, screenHeight)
    }
    
    CGContextStrokePath(context)
  }
  
}
