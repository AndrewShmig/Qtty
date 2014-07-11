//
//  PhotoScreen.swift
//  Qtty
//
//  Created by AndrewShmig on 11/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class PhotoScreen: UIViewController {

    override func loadView() {
        let view = UIView(frame:UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.blueColor()
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
