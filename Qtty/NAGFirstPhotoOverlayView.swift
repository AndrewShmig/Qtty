//
//  NAGPhotoOverlayVIew.swift
//  Qtty
//
//  Created by AndrewShmig on 17/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit
import Foundation

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

class NAGFirstPhotoOverlayView: UIView {
  
  let screenHeight = CGRectGetHeight(UIScreen.mainScreen().bounds)
  let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
  let kButtonSize = CGSize(width: 60, height: 60)
  let kLeftButtonTag = 1
  let kRightButtonTag = 2
  let kGridViewTag = 3
  let kButtonOffset: CGFloat = 10
  
  var leftButton: UIButton!
  var rightButton: UIButton!
  var prevDeviceOrientation: UIDeviceOrientation = .Portrait
  
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
    
    // обновляем расположение кнопок на экране
    switch currentOrientation {
    case .LandscapeLeft, .LandscapeRight, .Portrait, .PortraitUpsideDown:
      self.layout(currentOrientation, animation: .AfterAnimation)
    default:
      break
    }
    
    // анимируем поворот кнопок в зависимости от текущей ориентации устройства
    UIView.animateWithDuration(0.3, animations: {
      self.rotate(from: self.prevDeviceOrientation, to: currentOrientation)
      })
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
  
  // создаем кнопки сетки и фиксации фотографии + саму сетку на доп слое
  private func createControlElements() {
    leftButton = createLeftButton()
    rightButton = createRightButton()
    
    let orientation = UIDevice.currentDevice().orientation
    layout(orientation, animation: .BeforeAnimation)
    rotate(from:prevDeviceOrientation, to:orientation)
    
    addSubview(leftButton)
    addSubview(rightButton)
  }
  
  // создаем левую кнопку
  private func createLeftButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.setImage(UIImage(named: "grid_icon"), forState: UIControlState.Normal)
    button.backgroundColor = UIColor(red: 0.803, green: 0.788, blue: 0.788, alpha: 0.5)
    button.addTarget(self, action: "showGrid:", forControlEvents: .TouchUpInside)
    
    return button
  }
  
  // создаем правую кнопку
  private func createRightButton() -> UIButton {
    let button = UIButton()
    button.frame.size = kButtonSize
    button.setImage(UIImage(named: "rotate_camera"), forState: UIControlState.Normal)
    button.backgroundColor = UIColor(red: 0.803, green: 0.788, blue: 0.788, alpha: 0.5)
    button.addTarget(self, action: "flipCameras:", forControlEvents: .TouchUpInside)
    
    return button
  }
  
  // поворачиваем кнопку на нужное кол-во радиан
  private func rotate(#from: UIDeviceOrientation, to: UIDeviceOrientation) {
    println(__FUNCTION__)
    
    var angle: CGFloat
    
    switch (from, to) {
    case (.Portrait, .LandscapeLeft), (.LandscapeLeft, .PortraitUpsideDown), (.PortraitUpsideDown, .LandscapeRight), (.LandscapeRight, .Portrait): // +90 degrees
      angle = CGFloat(M_PI) / 2.0
    case (.Portrait, .LandscapeRight), (.LandscapeRight, .PortraitUpsideDown), (.PortraitUpsideDown, .LandscapeLeft), (.LandscapeLeft, .Portrait): // -90 degrees
      angle = -CGFloat(M_PI) / 2.0
    case (.Portrait, .PortraitUpsideDown), (.PortraitUpsideDown, .Portrait), (.LandscapeRight, .LandscapeLeft), (.LandscapeLeft, .LandscapeRight): // +180 degrees
      angle = CGFloat(M_PI)
    default:
      angle = 0.0
    }
    
    let rotationTransformation = CGAffineTransformMakeRotation(angle)
    leftButton.transform = CGAffineTransformConcat(leftButton.transform, rotationTransformation)
    rightButton.transform = CGAffineTransformConcat(rightButton.transform, rotationTransformation)
    
    // обновим предыдущее значение ориентации устройства
    if to != .Unknown && to != .FaceUp && to != .FaceDown {
      prevDeviceOrientation = to
    }
  }
  
  // в зависимости от текущей ориентации и до/после анимации меняем положение левой и правой кнопок
  private func layout(orientation: UIDeviceOrientation, animation: NAGAnimatedElementPosition) {
    println(__FUNCTION__)
    
    switch orientation {
    case .Portrait, .FaceDown, .FaceUp, .Unknown:
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
    }
    
    switch orientation {
    case .Portrait, .FaceUp, .FaceDown, .Unknown:
      leftButton.frame.origin.y += kButtonOffset
      rightButton.frame.origin.y += kButtonOffset
    case .PortraitUpsideDown:
      leftButton.frame.origin.y -= kButtonOffset
      rightButton.frame.origin.y -= kButtonOffset
    case .LandscapeLeft:
      leftButton.frame.origin.x -= kButtonOffset
      rightButton.frame.origin.x -= kButtonOffset
    case .LandscapeRight:
      leftButton.frame.origin.x += kButtonOffset
      rightButton.frame.origin.x += kButtonOffset
    }
    
    if animation == .BeforeAnimation {
      switch orientation {
      case .Portrait, .FaceDown, .FaceUp, .Unknown:
        leftButton.frame.origin.x -= CGRectGetWidth(leftButton.frame)
        rightButton.frame.origin.x += CGRectGetWidth(rightButton.frame)
      case .PortraitUpsideDown:
        leftButton.frame.origin.x += CGRectGetWidth(leftButton.frame)
        rightButton.frame.origin.x -= CGRectGetWidth(rightButton.frame)
      case .LandscapeLeft:
        leftButton.frame.origin.y -= CGRectGetHeight(leftButton.frame)
        rightButton.frame.origin.y += CGRectGetHeight(rightButton.frame)
      case .LandscapeRight:
        leftButton.frame.origin.y += CGRectGetHeight(leftButton.frame)
        rightButton.frame.origin.y -= CGRectGetHeight(rightButton.frame)
      }
    }
  }
  
  // функция возвращает frame элемента, который был передан с измененным положением на
  // один из четырех возможных: верхний левый угол, верхний правый, нижний левый, нижний правый
  private func position(element:UIButton, atCorner: NAGCorner) -> CGRect {
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
  
  // отписываемся от уведомлений и отключаем генерирование нотификаций о поворотах
  deinit {
    UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
}
