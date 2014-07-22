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
let kNAGImagePickerControllerFlipCameraNotification = "NAGImagePickerControllerFlipCameraNotification"


class NAGImagePickerController: UIImagePickerController {
  
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
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidDisappearNotification, object: self)
  }
  
  func flipCameras() {
    cameraDevice = (cameraDevice == .Rear ? .Front : .Rear)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
