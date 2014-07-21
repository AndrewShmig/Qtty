//
//  NAGImagePickerController.swift
//  Qtty
//
//  Created by AndrewShmig on 21/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit


let kNAGImagePickerControllerViewDidLoad = "NAGImagePickerControllerViewDidLoad"
let kNAGImagePickerControllerViewWillAppear = "NAGImagePickerControllerViewWillAppear"
let kNAGImagePickerControllerViewDidAppear = "NAGImagePickerControllerViewDidAppear"
let kNAGImagePickerControllerViewDidDisappear = "NAGImagePickerControllerViewDidDisappear"


class NAGImagePickerController: UIImagePickerController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidLoad, object: self)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewWillAppear, object: self)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidAppear, object: self)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    
    NSNotificationCenter.defaultCenter().postNotificationName(kNAGImagePickerControllerViewDidDisappear, object: self)
  }
  
}
