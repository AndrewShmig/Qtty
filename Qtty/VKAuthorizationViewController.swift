//
//  PhotoViewController.swift
//  Qtty
//
//  Created by AndrewShmig on 03/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

import UIKit
import Foundation

class VKAuthorizationViewController: UIViewController, VKConnectorDelegate, UIAlertViewDelegate {
  
  let kActivityIndicatorTag = 1
  var webView: UIWebView?
  
  override func loadView() {
    //        размеры экрана
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    //        основная вьюха
    self.view = UIView(frame:UIScreen.mainScreen().bounds)
    
    //         создаем верхнюю
    let topView = UIView(frame:CGRectMake(0, 0, screenWidth, 50))
    topView.backgroundColor = UIColor(red:0.439, green:0.286, blue:0.549, alpha:1)
    topView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    
    //        надпись "Авторизация" на верхнюю панель
    let authorizationLabel = UILabel(frame:CGRectMake(0, 0, topView.frame.size.width, topView.frame.size.height))
    authorizationLabel.textAlignment = .Center
    authorizationLabel.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    authorizationLabel.text = "Авторизация"
    authorizationLabel.font = UIFont(name:"Helvetica Light", size:20)
    authorizationLabel.textColor = UIColor(red:0.749, green:0.749, blue:0.749, alpha:1)
    
    topView.addSubview(authorizationLabel)
    
    //        добавляем кнопку "Закрыть"
    let closeButton = UIButton()
    closeButton.backgroundColor = UIColor(red:0.439, green:0.286, blue:0.549, alpha:1)
    closeButton.setTitleColor(UIColor(red:0.749, green:0.749, blue:0.749, alpha:1), forState:.Normal)
    closeButton.setTitle("X", forState:.Normal)
    closeButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
    closeButton.titleLabel.font = UIFont(name:"Helvetica Light", size:25)
    closeButton.addTarget(self, action:"closeButtonTapped:", forControlEvents:.TouchUpInside)
    
    //        создаем тень для кнопки закрыть, добавляем её на основную вьюху
    let compoundView = UIView(frame: CGRectMake(0, -2, 40, 40))
    let shadow = NAGShadowedView(frame: CGRectMake(8, -4, CGRectGetWidth(compoundView.frame), CGRectGetHeight(compoundView.frame)))
    
    closeButton.frame = CGRectMake(CGRectGetMinX(shadow.frame), CGRectGetMinY(shadow.frame) + 6, 40, 40)
    closeButton.layer.cornerRadius = 6.0
    
    compoundView.addSubview(shadow)
    compoundView.addSubview(closeButton)
    
    topView.addSubview(compoundView)
    
    //        добавляем веб вью для авторизации в ВК
    self.webView = UIWebView(frame:CGRectMake(0, topView.frame.size.height, screenWidth, screenHeight - topView.frame.size.height))
    self.webView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    
    //        добавляем вьюхи на основную
    self.view.addSubview(topView)
    self.view.addSubview(self.webView)
    
    //        начинаем уже осуществлять запрос к серверу ВК для загрузки страницы авторизации
    VKConnector.sharedInstance().startWithAppID("4455228", permissons: ["photo", "wall", "friends"], webView: self.webView, delegate: self)
  }
  
  func closeButtonTapped(sender:UIButton) {
    self.dismissViewControllerAnimated(true, completion:nil)
  }
  
  //    --- VKMediatorDelegate ---
  func connector(connector:VKConnector!, webViewDidStartLoad webView: UIWebView!) {
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    activityIndicator.tag = kActivityIndicatorTag
    activityIndicator.center = CGPointMake(CGRectGetWidth(webView.frame) / 2, CGRectGetHeight(webView.frame) / 2)
    activityIndicator.startAnimating()
    
    webView.addSubview(activityIndicator)
  }
  
  func connector(connector:VKConnector!, webViewDidFinishLoad webView: UIWebView!) {
    webView.viewWithTag(kActivityIndicatorTag).removeFromSuperview()
  }
  
  func connector(connector:VKConnector!, connectionError error: NSError!) {
    let connectionErroAlert = UIAlertView(title: "Ошибка соединения", message: "Проверьте подключение к интернету. ВКонтакте молчит.", delegate: self, cancelButtonTitle: "OK")
    connectionErroAlert.show()
  }
  
  func connector(connector:VKConnector!, accessTokenRenewalSucceeded accessToken: VKAccessToken!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func connector(connector:VKConnector!, accessTokenRenewalFailed accessToken: VKAccessToken!) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  //    --- UIAlertViewDelegate ---
  func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
    self.dismissViewControllerAnimated(true, completion:nil)
  }
  
  //    -- Device orientation
  override func supportedInterfaceOrientations() -> Int {
    return Int(UIInterfaceOrientationMask.Portrait.toRaw() | UIInterfaceOrientationMask.PortraitUpsideDown.toRaw())
  }
}
