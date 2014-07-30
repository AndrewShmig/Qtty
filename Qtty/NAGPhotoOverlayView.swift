//
//  NAGPhotoFiltersOverlayView.swift
//  Qtty
//
//  Created by AndrewShmig on 28/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class NAGPhotoOverlayView: UIView {
  
  var photoView: UIImageView!
  var originalPhoto: UIImage!
  
  init(imageInfo: [NSObject : AnyObject]!, frame: CGRect) {
    super.init(frame: frame)
    
    originalPhoto = imageInfo[UIImagePickerControllerOriginalImage] as UIImage
    photoView = createPhotoLayer(image: originalPhoto)
    addSubview(photoView)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDidChangeOrientation:", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  func deviceDidChangeOrientation(notification: NSNotification) {
    rotateImage(toOrientation: UIDevice.currentDevice().orientation)
  }
  
  private func rotateImage(toOrientation orientation: UIDeviceOrientation) {
    let orientation = UIDevice.currentDevice().orientation
    let photoOrientation = originalPhoto.imageOrientation
    let isLandscapedPhoto = photoOrientation == .Down || photoOrientation == .Up
    
    if isLandscapedPhoto && (orientation == .LandscapeLeft || orientation == .LandscapeRight) {
      photoView.image = UIImage(CGImage: originalPhoto.CGImage, scale: originalPhoto.scale, orientation: orientation == .LandscapeRight ? .Right : .Left)
    } else if !isLandscapedPhoto && (orientation == .Portrait || orientation == .PortraitUpsideDown){
      photoView.image = UIImage(CGImage: originalPhoto.CGImage, scale: originalPhoto.scale, orientation: orientation == .Portrait ? .Right : .Left)
    }
  }
  
  private func createPhotoLayer(#image: UIImage!) -> UIImageView {
    let layer = UIImageView(frame: frame)
    layer.image = (image.imageOrientation == .Down || image.imageOrientation == .Up) ? UIImage(CGImage: image.CGImage, scale: image.scale, orientation: .Right) : image
    
    return layer
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
}
