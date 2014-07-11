//
//  VKConnectorDelegate.h
//  Qtty
//
//  Created by AndrewShmig on 10/07/14.
//  Copyright (c) 2014 Non Atomic Games Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VKAccessToken;

/** Protocol incapsulates methods that are triggered during user authorization
 process or access token status changes.
 */
@protocol VKConnectorDelegate <NSObject>

@optional
/**
 @name Show/hide web view
 */
/** Method is called when user needs to perform some action (enter login and
 password, authorize your application etc)
 
 @param connector VKConnector instance that sends notifications
 @param webView UIWebView that displays authorization page
 */
- (void)VKMediator:(VKConnector *)connector
    willShowWebView:(UIWebView *)webView;

/** Method is called when UIWebView should be hidden, this method is called after
 user has entered login+password or has authorized an application (or pressed
 cancel button etc).
 
 @param connector VKConnector instance that sends notifications
 @param webView UIWebView that displays authorization page and needs to be hidden
 */
- (void)VKMediator:(VKConnector *)connector
    willHideWebView:(UIWebView *)webView;

/**
 @name UIWebView started/finished loading a frame
 */
/** Method is called when UIWebView starts loading a frame
 
 @param connector VKConnector instance that sends notifications
 @param webView UIWebView that displays authorization page
 */
- (void)VKMediator:(VKConnector *)connector
webViewDidStartLoad:(UIWebView *)webView;

/** Method is called when UIWebView finishes loading a frame
 
 @param connector VKConnector instance that sends notifications
 @param webView UIWebView that displays authorization page
 */
- (void) VKMediator:(VKConnector *)connector
webViewDidFinishLoad:(UIWebView *)webView;

/**
 @name Access token
 */
/** Method is called when access token is successfully updated
 
 @param connector VKConnector instance that sends notifications
 @param accessToken updated access token
 */
- (void)        VKMediator:(VKConnector *)connector
accessTokenRenewalSucceeded:(VKAccessToken *)accessToken;

/** Method is called when access token failed to be updated. The main reason
 could be that user denied/canceled to authorize your application.
 
 @param connector VKConnector instance that sends notifications
 @param accessToken access token (equals to nil)
 */
- (void)     VKMediator:(VKConnector *)connector
accessTokenRenewalFailed:(VKAccessToken *)accessToken;

/**
 @name Connection & Parsing
 */
/** Method is called when connection error occurred during authorization process.
 
 @param connector VKConnector instance that sends notifications
 @param error error description
 */
- (void)VKMediator:(VKConnector *)connector
    connectionError:(NSError *)error;

/** Method is called if VK application was deleted.
 
 @param connector VKConnector instance that sends notifications
 @param error error description
 */
- (void)  VKMediator:(VKConnector *)connector
applicationWasDeleted:(NSError *)error;

@end

