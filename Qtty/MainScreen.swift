//
//  MainScreen.swift
//  Qtty
//
//  Created by AndrewShmig on 03/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit
import Foundation

class MainScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let authorizationButton = UIButton()
  
  override func loadView()  {
    //        настраиваем вьюху
    var view = UIView(frame:UIScreen.mainScreen().bounds)
    
    //        устанавливаем фоновое изображение
    let backgroundImage = UIImage(named:"backgroundImage")
    let backgroundImageView = UIImageView(image:backgroundImage)
    backgroundImageView.frame = UIScreen.mainScreen().bounds
    
    view.addSubview(backgroundImageView)
    
    //        накладываем прозрачность
    let glassView = UIView(frame:UIScreen.mainScreen().bounds)
    glassView.alpha = 0.65
    glassView.backgroundColor = UIColor(red:0.815, green:0.815, blue:0.815, alpha:1.0)
    
    let blurEffectView = UIVisualEffectView(effect:UIBlurEffect(style:.Light))
    blurEffectView.frame = glassView.frame
    glassView.addSubview(blurEffectView)
    
    view.addSubview(glassView)
    
    //        добавляем надпись с названием приложения
    let screenMidX = CGRectGetWidth(UIScreen.mainScreen().bounds) / 2
    let screenMidY = CGRectGetHeight(UIScreen.mainScreen().bounds) / 2
    
    let appNameImage = UIImage(named:"logo")
    let appNameImageView = UIImageView(image:appNameImage)
    appNameImageView.center = CGPointMake(screenMidX, screenMidY)
    
    view.addSubview(appNameImageView)
    
    //        добавляем кнопку авторизации в ВК
    let authorizationButtonHeight: Double = 40.0
    let authorizationButtonX: Double = 10.0
    let authorizationButtonWidth = Double(UIScreen.mainScreen().bounds.size.width) - authorizationButtonX * 2
    let authorizationButtonY = Double(UIScreen.mainScreen().bounds.size.height) - 10.0 - authorizationButtonHeight
    
    authorizationButton.backgroundColor = UIColor(red:0.439, green:0.286, blue:0.549, alpha:1)
    authorizationButton.setTitleColor(UIColor(red:0.749, green:0.749, blue:0.749, alpha:1), forState:.Normal)
    authorizationButton.setTitle("Авторизоваться", forState:.Normal)
    authorizationButton.titleLabel.font = UIFont(name:"Helvetica Light", size:25)
    authorizationButton.enabled = false
    authorizationButton.addTarget(self, action:"authorizationButtonTappedInside:", forControlEvents:.TouchUpInside)
    
    //        объединяем тень и кнопку в одну вьюху
    let compoundView = UIView(frame: CGRectMake(CGFloat(authorizationButtonX), CGFloat(authorizationButtonY), CGFloat(authorizationButtonWidth), CGFloat(authorizationButtonHeight)))
    let shadow = NAGShadowedView(frame: CGRectMake(0, 0, CGRectGetWidth(compoundView.frame), CGRectGetHeight(compoundView.frame)))
    
    authorizationButton.frame = shadow.frame
    authorizationButton.layer.cornerRadius = 6.0
    
    compoundView.addSubview(shadow)
    compoundView.addSubview(authorizationButton)
    
    view.addSubview(compoundView)
    
    //        устанавливаем текущую сконфигурированную вьюху
    self.view = view
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if VKUser.currentUser() {
      authorizationButton.enabled = false
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        println("We have camera...")
        
        let cameraView = UIImagePickerController()
        cameraView.sourceType = UIImagePickerControllerSourceType.Camera
        cameraView.showsCameraControls = false
        cameraView.delegate = self
        cameraView.cameraOverlayView = NAGPhotoOverlayView(frame: UIScreen.mainScreen().bounds)
        
        self.presentViewController(cameraView, animated: false, completion: nil)
      } else {
        UIAlertView(title: "Ошибка!", message: "Упс! Не можем достучаться до камеры.", delegate: nil, cancelButtonTitle: "OK").show()
      }
    } else {
      authorizationButton.enabled = true
      
      println("User is not authorized...")
    }
  }
  
  func authorizationButtonTappedInside(sender:UIButton) {
    let vkModal = VKAuthorizationViewController() as UIViewController
    
    vkModal.modalPresentationStyle = .FullScreen
    vkModal.modalTransitionStyle = .CoverVertical
    
    self.presentViewController(vkModal, animated:true, completion:nil)
  }
  
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.Portrait.toRaw() | UIInterfaceOrientationMask.PortraitUpsideDown.toRaw())
  }
  
  //  UIImagePickerControllerDelegate
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
    println(info)
  }
  
}
