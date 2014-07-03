//
//  MainScreen.swift
//  Qtty
//
//  Created by AndrewShmig on 03/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit

class MainScreen: UIViewController {

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
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
        
        authorizationButton.frame = CGRectMake(authorizationButtonX, authorizationButtonY, authorizationButtonWidth, authorizationButtonHeight)
        authorizationButton.backgroundColor = UIColor(red:0.439, green:0.286, blue:0.549, alpha:1)
        authorizationButton.setTitleColor(UIColor(red:0.749, green:0.749, blue:0.749, alpha:1), forState:.Normal)
        authorizationButton.setTitle("Авторизоваться", forState:.Normal)
        authorizationButton.titleLabel.font = UIFont(name:"Helvetica Light", size:25)
        authorizationButton.layer.shadowPath = self.stickerShadow(forView: authorizationButton)
        authorizationButton.addTarget(self, action:Selector("authorizationButtonTappedInside:"), forControlEvents:.TouchUpInside)
        authorizationButton.addTarget(self, action:Selector("authorizationButtonTappedOutside:"), forControlEvents:.TouchUpOutside)
        authorizationButton.addTarget(self, action:Selector("authorizationButtonDown:"), forControlEvents:.TouchDown)
        
        view.addSubview(authorizationButton)
        
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
        sender.layer.shadowOpacity = 0.6
    }
    
    func authorizationButtonDown(sender:UIButton) {
        sender.layer.shadowOpacity = 0.0
    }
    
    func authorizationButtonTappedOutside(sender:UIButton) {
        self.authorizationButtonTappedInside(sender)
    }
    
//    функция возвращает каркас для отрисовки стикерной тени для элемента
    func stickerShadow(forView view:UIView) -> CGPath {
        var shadowPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(shadowPath, nil, 0, 0)
        CGPathAddLineToPoint(shadowPath, nil, CGRectGetWidth(view.frame), CGPathGetCurrentPoint(shadowPath).y)
        CGPathAddLineToPoint(shadowPath, nil, CGPathGetCurrentPoint(shadowPath).x, CGRectGetHeight(view.frame))
        CGPathAddLineToPoint(shadowPath, nil, view.frame.size.width / 2, CGRectGetHeight(view.frame) - 8)
        CGPathAddLineToPoint(shadowPath, nil, 0, CGRectGetHeight(view.frame))
        CGPathCloseSubpath(shadowPath)
        
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = CGSizeMake(0, 7)
        
        return shadowPath
    }
}
