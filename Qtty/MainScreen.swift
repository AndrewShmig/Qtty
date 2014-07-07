//
//  MainScreen.swift
//  Qtty
//
//  Created by AndrewShmig on 03/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class MainScreen: UIViewController {
    
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
        let screenMidX = CGRectGetMidX(UIScreen.mainScreen().bounds) / 2
        let screenMidY = CGRectGetMidY(UIScreen.mainScreen().bounds) / 2
        
        let appNameImage = UIImage(named:"logo")
        let appNameImageView = UIImageView(image:appNameImage)
        appNameImageView.frame = CGRectMake(screenMidX, screenMidY, appNameImage.size.width, appNameImage.size.height)
        
        view.addSubview(appNameImageView)
        
//        добавляем кнопку авторизации в ВК
        let authorizationButton = UIButton()
        let authorizationButtonHeight = 40.0
        let authorizationButtonX = 10.0
        let authorizationButtonWidth = UIScreen.mainScreen().bounds.size.width - authorizationButtonX * 2
        let authorizationButtonY = UIScreen.mainScreen().bounds.size.height - 10.0 - authorizationButtonHeight
        
        authorizationButton.backgroundColor = UIColor(red:0.439, green:0.286, blue:0.549, alpha:1)
        authorizationButton.setTitleColor(UIColor(red:0.749, green:0.749, blue:0.749, alpha:1), forState:.Normal)
        authorizationButton.setTitle("Авторизоваться", forState:.Normal)
        authorizationButton.titleLabel.font = UIFont(name:"Helvetica Light", size:25)
        
        authorizationButton.addTarget(self, action:Selector("authorizationButtonTappedInside:"), forControlEvents:.TouchUpInside)
        authorizationButton.addTarget(self, action:Selector("authorizationButtonTappedOutside:"), forControlEvents:.TouchUpOutside)
        authorizationButton.addTarget(self, action:Selector("authorizationButtonDown:"), forControlEvents:.TouchDown)
        
//        объединяем тень и кнопку в одну вьюху
        let compoundView = UIView(frame: CGRectMake(authorizationButtonX, authorizationButtonY, authorizationButtonWidth, authorizationButtonHeight))
        let shadow = NAGShadowedView(frame: CGRectMake(0, 0, CGRectGetWidth(compoundView.frame), CGRectGetHeight(compoundView.frame)))
        
        authorizationButton.frame = shadow.frame
        authorizationButton.layer.cornerRadius = 6.0
        
        compoundView.addSubview(shadow)
        compoundView.addSubview(authorizationButton)
        
        view.addSubview(compoundView)
        
//        устанавливаем текущую сконфигурированную вьюху
        self.view = view
    }

    override func shouldAutorotate() -> Bool {
        return true;
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.PortraitUpsideDown.toRaw() | UIInterfaceOrientationMask.Portrait.toRaw())
    }
    
    func authorizationButtonTappedInside(sender:UIButton) {
        let vkModal = VKAuthorizationViewController() as UIViewController
        vkModal.modalPresentationStyle = .FullScreen
        vkModal.modalTransitionStyle = .CoverVertical
        self.presentViewController(vkModal, animated:true, completion:nil)
    }
    
    func authorizationButtonDown(sender:UIButton) {
    }
    
    func authorizationButtonTappedOutside(sender:UIButton) {
        self.authorizationButtonTappedInside(sender)
    }
}
