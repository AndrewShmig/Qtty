//
//  NAGPhotoFiltersOverlayView.swift
//  Qtty
//
//  Created by AndrewShmig on 28/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class NAGPhotoFiltersOverlayView: UIView {
  
  init(imageInfo: [NSObject : AnyObject]!, frame: CGRect) {
    super.init(frame: frame)
    
    let imageView = UIImageView(frame: frame)
    imageView.image = imageInfo[UIImagePickerControllerOriginalImage] as UIImage
    addSubview(imageView)
  }
  
}
