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
  
  enum NAGCorner: Int {
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
  let kGridViewTag = 3
  let kButtonOffset: CGFloat = 5
  
  var leftButton: UIButton!
  var rightButton: UIButton!
  
  init(frame: CGRect) {
    super.init(frame: frame)
    
    // создаем вьюху с сеткой и вставляем за управляющие элементы
    let grid = NAGGridView(frame: self.frame)
    grid.hidden = true
    grid.tag = kGridViewTag
    self.insertSubview(grid, belowSubview: self)
    
    // по тапу будем делать фотографию
    let tapGR = UITapGestureRecognizer(target: self, action: "captureImage")
    self.addGestureRecognizer(tapGR)
    
    // подписываем на нотификации о вызове метода viewDidAppear: нашего ImagePickerController
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imagePickerControllerViewDidAppear:", name: kNAGImagePickerControllerViewDidAppearNotification, object: nil)
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
    case .LandscapeLeft, .FaceDown, .FaceUp, .Unknown:
      leftButton.frame = position(leftButton, atCorner: .UpperRightCorner)
      rightButton.frame = position(rightButton, atCorner: .LowerRightCorner)
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
  
  // создаем кнопки сетки и фиксации фотографии + саму сетку на доп слое
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
    button.setImage(UIImage(named: "grid_icon"), forState: UIControlState.Normal)
    button.backgroundColor = UIColor(red: 0.803, green: 0.788, blue: 0.788, alpha: 0.5)
    button.addTarget(self, action: "showGrid:", forControlEvents: .TouchUpInside)
    
    switch UIDevice.currentDevice().orientation {
    case .Portrait:
      button.frame = CGRect(origin: CGPoint(x: -CGRectGetWidth(button.frame), y: kButtonOffset), size: kButtonSize)
    case .PortraitUpsideDown:
      button.frame = CGRect(origin: CGPoint(x: screenWidth, y: screenHeight - CGRectGetHeight(button.frame) - kButtonOffset), size: kButtonSize)
    case .LandscapeRight:
      button.frame = CGRect(origin: CGPoint(x: kButtonOffset, y: screenHeight), size: kButtonSize)
    default:
      button.frame = CGRect(origin: CGPoint(x: screenWidth - kButtonOffset - CGRectGetWidth(button.frame), y: -CGRectGetHeight(button.frame)), size: kButtonSize)
    }
    
    return button
  }
  
  // создаем правую кнопку
  func createRightButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.setImage(UIImage(named: "rotate_camera"), forState: UIControlState.Normal)
    button.backgroundColor = UIColor(red: 0.803, green: 0.788, blue: 0.788, alpha: 0.5)
    button.addTarget(self, action: "flipCameras:", forControlEvents: .TouchUpInside)
    
    switch UIDevice.currentDevice().orientation {
    case .Portrait:
      button.frame = CGRect(origin: CGPoint(x: screenWidth, y: kButtonOffset), size: kButtonSize)
    case .PortraitUpsideDown:
      button.frame = CGRect(origin: CGPoint(x: -CGRectGetWidth(button.frame), y: screenHeight - CGRectGetHeight(button.frame) - kButtonOffset), size: kButtonSize)
    case .LandscapeRight:
      button.frame = CGRect(origin: CGPoint(x: kButtonOffset, y: -CGRectGetHeight(button.frame)), size: kButtonSize)
    default:
      button.frame = CGRect(origin: CGPoint(x: screenWidth - kButtonOffset - CGRectGetWidth(button.frame), y: screenHeight), size: kButtonSize)
    }
    
    return button
  }
  
  // после нажатия на кнопку "Показать сетку" отображаем сетку
  func showGrid(sender:UIButton) {
    self.superview.viewWithTag(self.kGridViewTag).hidden = !self.superview.viewWithTag(self.kGridViewTag).hidden
  }
  
  // переключаемся на фронтальную камеру
  func flipCameras(sender:UIButton) {
    // чтобы не выносить cameraView в глобальную область видимости воспользуемся нотификациями
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerFlipCameraNotification, object: nil)
  }
  
  // делаем фотографию
  func captureImage() {
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerCaptureImageNotification, object: nil)
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
