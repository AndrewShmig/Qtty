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
  
  enum NAGAnimatedElementPosition: Int {
    case BeforeAnimation
    case AfterAnimation
  }
  
  let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
  let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
  let kButtonSize = CGSize(width: 60, height: 60)
  let kLeftButtonTag = 1
  let kRightButtonTag = 2
  let kGridViewTag = 3
  let kButtonOffset: CGFloat = 10
  
  var leftButton: UIButton!
  var rightButton: UIButton!
  
  init(frame: CGRect) {
    super.init(frame: frame)
    
    // создаем вьюху с сеткой и вставляем за управляющие элементы
    let grid = NAGGridView(frame: self.frame)
    grid.hidden = true
    grid.tag = kGridViewTag
    insertSubview(grid, belowSubview: self)
    
    // по тапу будем делать фотографию
    let tapGR = UITapGestureRecognizer(target: self, action: "captureImage")
    addGestureRecognizer(tapGR)
    
    // блокируем стандартный контрол зума UIImagePickerController'а
    let pinchGR = UIPinchGestureRecognizer(target: self, action: nil)
    addGestureRecognizer(pinchGR)
    
    // подписываем на нотификации о вызове метода viewDidAppear: нашего ImagePickerController
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imagePickerControllerViewDidAppear:", name: kNAGImagePickerControllerViewDidAppearNotification, object: nil)
  }
  
  // обрабатываем повороты девайса
  func deviceDidChangeOrientation(sender: NSNotification!) {
    println(__FUNCTION__)
    
    let currentOrientation = UIDevice.currentDevice().orientation
    
    switch currentOrientation {
    case .LandscapeLeft, .LandscapeRight, .Portrait, .PortraitUpsideDown:
      self.layout(currentOrientation, animation: .AfterAnimation)
    default:
      break
    }
  }
  
  // в зависимости от текущей ориентации и до/после анимации меняем положение левой и правой кнопок
  func layout(orientation: UIDeviceOrientation, animation: NAGAnimatedElementPosition) {
    println(__FUNCTION__)
    
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
    default: // все другие варианты
      leftButton.frame = position(leftButton, atCorner: .UpperRightCorner)
      rightButton.frame = position(rightButton, atCorner: .LowerRightCorner)
    }
    
    switch orientation {
    case .Portrait:
      leftButton.frame.origin.y += kButtonOffset
      rightButton.frame.origin.y += kButtonOffset
    case .PortraitUpsideDown:
      leftButton.frame.origin.y -= kButtonOffset
      rightButton.frame.origin.y -= kButtonOffset
    case .LandscapeLeft:
      leftButton.frame.origin.x -= kButtonOffset
      rightButton.frame.origin.x -= kButtonOffset
    default:
      leftButton.frame.origin.x += kButtonOffset
      rightButton.frame.origin.x += kButtonOffset
    }
    
    if animation == .BeforeAnimation {
      switch orientation {
      case .Portrait:
        leftButton.frame.origin.x -= CGRectGetWidth(leftButton.frame)
        rightButton.frame.origin.x += CGRectGetWidth(rightButton.frame)
      case .PortraitUpsideDown:
        leftButton.frame.origin.x += CGRectGetWidth(leftButton.frame)
        rightButton.frame.origin.x -= CGRectGetWidth(rightButton.frame)
      case .LandscapeLeft:
        leftButton.frame.origin.y -= CGRectGetHeight(leftButton.frame)
        rightButton.frame.origin.y += CGRectGetHeight(rightButton.frame)
      default:
        leftButton.frame.origin.y += CGRectGetHeight(leftButton.frame)
        rightButton.frame.origin.y -= CGRectGetHeight(rightButton.frame)
      }
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
      newFrame.origin = CGPoint(x: 0, y: screenHeight - elementHeight)
    case .LowerRightCorner:
      newFrame.origin = CGPoint(x: screenWidth - elementWidth, y: screenHeight - elementHeight)
    case .UpperLeftCorner:
      newFrame.origin = CGPoint(x: 0, y: 0)
    case .UpperRightCorner:
      newFrame.origin = CGPoint(x: screenWidth - elementWidth, y: 0)
    }
    
    return newFrame
  }
  
  // создаем кнопки сетки и фиксации фотографии + саму сетку на доп слое
  func createControlElements() {
    leftButton = createLeftButton()
    rightButton = createRightButton()
    
    layout(UIDevice.currentDevice().orientation, animation: .BeforeAnimation)
    
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
    
    return button
  }
  
  // создаем правую кнопку
  func createRightButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.setImage(UIImage(named: "rotate_camera"), forState: UIControlState.Normal)
    button.backgroundColor = UIColor(red: 0.803, green: 0.788, blue: 0.788, alpha: 0.5)
    button.addTarget(self, action: "flipCameras:", forControlEvents: .TouchUpInside)
    
    return button
  }
  
  // после нажатия на кнопку "Показать сетку" отображаем сетку
  func showGrid(sender:UIButton) {
    println(__FUNCTION__)
    self.superview.viewWithTag(self.kGridViewTag).hidden = !self.superview.viewWithTag(self.kGridViewTag).hidden
  }
  
  // переключаемся на фронтальную камеру
  func flipCameras(sender:UIButton) {
    println(__FUNCTION__)
    // чтобы не выносить cameraView в глобальную область видимости воспользуемся нотификациями
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerFlipCameraNotification, object: nil)
  }
  
  // делаем фотографию
  func captureImage() {
    println(__FUNCTION__)
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerCaptureImageNotification, object: nil)
  }
  
  // метод вызывается в момент вызова метода viewDidAppear: UIImagePickerController'а
  func imagePickerControllerViewDidAppear(sender: NSNotification) {
    println(__FUNCTION__)
    
    createControlElements()
    
    // единожды анимируем появление управляющих элементов - кнопок
    UIView.animateWithDuration(1.0, animations: {
      self.layout(UIDevice.currentDevice().orientation, animation: .AfterAnimation)
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
