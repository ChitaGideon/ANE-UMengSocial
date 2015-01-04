//
//  SocialControler.h
//  UMSocial_Sdk_Demo
//
//  Created by mani on 13-7-18.
//  Copyright (c) 2013年 yeahugo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "UMSocialSnsService.h"
#import "UMSocialControllerService.h"
#import "JSONKit.h"

@interface Login : UIViewController
<
UMSocialUIDelegate
>

@property ( nonatomic, assign ) FREContext      *freContext;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *loginPlatform;

-(void) doLogin:(NSString*) platform;

-(void) cancelLogin:(NSString*) platform;
-(void) unOAuth:(NSString *)platform token:(NSString *)token;
-(BOOL) isOauth:(NSString *)platform;
-(void) getUserInformation:(NSString *)platform token:(NSString *)token;

-(void) setAcountInfo:(NSString*)platform usid:(NSString*)usid accessToken:(NSString*)accessToken openId:(NSString*)openId;
-(void)cancelUm:(NSString *)token;
@end
