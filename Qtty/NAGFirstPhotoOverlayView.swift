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
  
  let screenHeight = { CGRectGetHeight(UIScreen.mainScreen().bounds) }()
  let screenWidth = { CGRectGetWidth(UIScreen.mainScreen().bounds) }()
  let kButtonSize = CGSize(width: 60, height: 60)
  let kLeftButtonTag = 1
  let kRightButtonTag = 2
  let kButtonOffset: CGFloat = 5
  
  var leftButton: UIButton!
  var rightButton: UIButton!
  
  init(frame: CGRect) {
    super.init(frame: frame)
    
    // подписываем на нотификации о вызове метода viewDidAppear: нашего ImagePickerController
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imagePickerControllerViewDidAppear:", name: kNAGImagePickerControllerViewDidAppear, object: nil)
  }
  
  // обрабатываем повороты девайса
  func deviceDidChangeOrientation(sender: NSNotification!) {
    let currentOrientation = UIDevice.currentDevice().orientation
    
    switch currentOrientation {
    case .LandscapeLeft, .LandscapeRight, .Portrait, .PortraitUpsideDown:
      self.layout(currentOrientation)
      
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
  
  // создаем кнопки сетки и фиксации фотографии
  func createControlElements() {
    leftButton = createLeftButton()
    rightButton = createRightButton()
    
    addSubview(leftButton)
    addSubview(rightButton)
  }
  
  // создаем левую кнопку
  func createLeftButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.backgroundColor = UIColor.blueColor()
    
    switch UIDevice.currentDevice().orientation {
    case .Portrait:
      button.frame = CGRect(origin: CGPoint(x: -CGRectGetWidth(button.frame), y: kButtonOffset), size: kButtonSize)
    case .PortraitUpsideDown:
      button.frame = CGRect(origin: CGPoint(x: screenWidth, y: screenHeight - CGRectGetHeight(button.frame) - kButtonOffset), size: kButtonSize)
    case .LandscapeRight:
      button.frame = CGRect(origin: CGPoint(x: kButtonOffset, y: screenHeight), size: kButtonSize)
    case .LandscapeLeft:
      button.frame = CGRect(origin: CGPoint(x: screenWidth - kButtonOffset - CGRectGetWidth(button.frame), y: -CGRectGetHeight(button.frame)), size: kButtonSize)
    default:
      break
    }
    
    return button
  }
  
  // создаем правую кнопку
  func createRightButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.backgroundColor = UIColor.redColor()
    
    switch UIDevice.currentDevice().orientation {
    case .Portrait:
      button.frame = CGRect(origin: CGPoint(x: screenWidth, y: kButtonOffset), size: kButtonSize)
    case .PortraitUpsideDown:
      button.frame = CGRect(origin: CGPoint(x: -CGRectGetWidth(button.frame), y: screenHeight - CGRectGetHeight(button.frame) - kButtonOffset), size: kButtonSize)
    case .LandscapeRight:
      button.frame = CGRect(origin: CGPoint(x: kButtonOffset, y: -CGRectGetHeight(button.frame)), size: kButtonSize)
    case .LandscapeLeft:
      button.frame = CGRect(origin: CGPoint(x: screenWidth - kButtonOffset - CGRectGetWidth(button.frame), y: screenHeight), size: kButtonSize)
    default:
      break
    }
    
    return button
  }
  
  // метод вызывается в момент вызова метода viewDidAppear: UIImagePickerController'а
  func imagePickerControllerViewDidAppear(sender: NSNotification) {
    createControlElements()
    
    // единожды анимируем появление управляющих элементов - кнопок
    UIView.animateWithDuration(1.0, animations: {
      self.layout(UIDevice.currentDevice().orientation)
      })
    
    // подписываемся на получение уведомлений об изменении ориентации девайса
    UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDidChangeOrientation:", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  // отписываемся от уведомлений и отключаем генерирование нотификаций о поворотах
  deinit {
    UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}
