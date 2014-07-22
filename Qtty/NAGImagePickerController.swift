//
//  NAGImagePickerController.swift
//  Qtty
//
//  Created by AndrewShmig on 21/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

let kNAGImagePickerControllerViewDidLoadNotification = "NAGImagePickerControllerViewDidLoadNotification"
let kNAGImagePickerControllerViewWillAppearNotification = "NAGImagePickerControllerViewWillAppearNotification"
let kNAGImagePickerControllerViewDidAppearNotification = "NAGImagePickerControllerViewDidAppearNotification"
let kNAGImagePickerControllerViewDidDisappearNotification = "NAGImagePickerControllerViewDidDisappearNotification"
let kNAGImagePickerControllerViewWillDisappearNotification = "NAGImagePickerControllerViewWillDisappearNotification"
let kNAGImagePickerControllerFlipCameraNotification = "NAGImagePickerControllerFlipCameraNotification"
let kNAGImagePickerControllerCaptureImageNotification = "NAGImagePickerControllerCaptureImageNotification"

class NAGImagePickerController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidLoadNotification, object: self)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewWillAppearNotification, object: self)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidAppearNotification, object: self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "flipCameras", name: kNAGImagePickerControllerFlipCameraNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "captureImage", name: kNAGImagePickerControllerCaptureImageNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewWillDisappearNotification, object: self)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidDisappearNotification, object: self)
    
    presentViewController(self, animated: false, completion: {})
  }
  
  // переключаемся между передней и задней камерами
  func flipCameras() {
    cameraDevice = (cameraDevice == .Rear ? .Front : .Rear)
  }
  
  // делаем фотографию
  func captureImage() {
    takePicture()
  }
  
  //  сделали фотографию, теперь надо её зафиксировать и отобразить другую оверлейную вьюху
  //TODO:
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
    println(info)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
