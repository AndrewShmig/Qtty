//
//  NAGPhotoOverlayVIew.swift
//  Qtty
//
//  Created by AndrewShmig on 17/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit
import Foundation

class NAGFirstPhotoOverlayView: UIView {
  
  enum NAGCorner {
    case UpperLeftCorner
    case UpperRightCorner
    case LowerLeftCorner
    case LowerRightCorner
  }
  
  let buttonSize = CGSize(width: 60, height: 60) // размеры левой и правой кнопок
  let kLeftButtonTag = 1
  let kRightButtonTag = 2
  let kButtonOffset: CGFloat = 5
  
  var leftButton: UIButton!
  var rightButton: UIButton!
  
  init(frame: CGRect) {
    super.init(frame: frame)
    
    // создаем кнопки создания сетки и фиксации фотографии
    leftButton = createLeftButton()
    rightButton = createRightButton()
    
    addSubview(leftButton)
    addSubview(rightButton)
    
    // подстройка под первоначальное положение девайса до начала получения уведомлений
    layout(UIDevice.currentDevice().orientation)
    
    // подписываемся на получение уведомлений об изменении ориентации девайса
    UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDidChangeOrientation:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imagePickerControllerViewDidAppear:", name: kNAGImagePickerControllerViewDidAppear, object: nil)
  }
  
  // обрабатываем повороты девайса
  func deviceDidChangeOrientation(sender: NSNotification!) {
    let currentOrientation = UIDevice.currentDevice().orientation
    
    switch currentOrientation {
    case .LandscapeLeft, .LandscapeRight, .Portrait, .PortraitUpsideDown:
      layout(currentOrientation)
    default:
      break
    }
  }
  
  // в зависимости от текущей ориентации меняем положение левой и правой кнопок
  func layout(orientation: UIDeviceOrientation) {
    switch orientation {
    case .Portrait:
      leftButton.frame = position(leftButton, atCorner: .UpperLeftCorner)
      rightButton.frame = position(rightButton, atCorner: .UpperRightCorner)
    case .PortraitUpsideDown:
      leftButton.frame = position(leftButton, atCorner: .LowerRightCorner)
      rightButton.frame = position(rightButton, atCorner: .LowerLeftCorner)
    case .LandscapeRight:
      leftButton.frame = position(leftButton, atCorner: .LowerLeftCorner)
      rightButton.frame = position(rightButton, atCorner: .UpperLeftCorner)
    case .LandscapeLeft:
      leftButton.frame = position(leftButton, atCorner: .UpperRightCorner)
      rightButton.frame = position(rightButton, atCorner: .LowerRightCorner)
    default:
      break
    }
  }
  
  // функция возвращает frame элемента, который был передан с измененным положением на
  // один из четырех возможных: верхний левый угол, верхний правый, нижний левый, нижний правый
  func position(element:UIButton, atCorner: NAGCorner) -> CGRect {
    var newFrame = element.frame
    let screenBounds = UIScreen.mainScreen().bounds
    let screenHeight = CGRectGetHeight(screenBounds)
    let screenWidth = CGRectGetWidth(screenBounds)
    let elementHeight = CGRectGetHeight(element.bounds)
    let elementWidth = CGRectGetWidth(element.bounds)
    
    switch atCorner {
    case .LowerLeftCorner:
      newFrame.origin = CGPoint(x: kButtonOffset, y: screenHeight - kButtonOffset - elementHeight)
    case .LowerRightCorner:
      newFrame.origin = CGPoint(x: screenWidth - kButtonOffset - elementWidth, y: screenHeight - kButtonOffset - elementHeight)
    case .UpperLeftCorner:
      newFrame.origin = CGPoint(x: kButtonOffset, y: kButtonOffset)
    case .UpperRightCorner:
      newFrame.origin = CGPoint(x: screenWidth - kButtonOffset - elementWidth, y: kButtonOffset)
    }
    
    return newFrame
  }
  
  // создаем левую кнопку
  func createLeftButton() -> UIButton {
    let button = UIButton(frame: CGRect(origin: CGPointZero, size: buttonSize))
    button.tag = kLeftButtonTag
    button.backgroundColor = UIColor.blueColor()
    
    return button
  }
  
  // создаем правую кнопку
  func createRightButton() -> UIButton {
    let button = UIButton(frame: CGRect(origin: CGPointZero, size: buttonSize))
    button.tag = kRightButtonTag
    button.backgroundColor = UIColor.redColor()
    
    return button
  }
  
  // метод вызывается в момент вызова метода viewDidAppear: UIImagePickerController'а
  func imagePickerControllerViewDidAppear(sender: NSNotification) {
    println("viewDidAppear in firstPhotoOverlayView...")
  }
  
  // отписываемся от уведомлений и отключаем генерирование нотификаций о поворотах
  deinit {
    UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

}
