//
//  Login.m
//  UMSocial
//
//  Created by mani on 14-3-12.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#import "Login.h"
#import "UMSocial.h"
#import "UMSocialAccountManager.h"
#import "UMSocialSnsPlatformManager.h"

#define AuthResult (const uint8_t*)"AuthResult"
#define CancelAuthResult (const uint8_t*)"CancelAuthResult"

@interface Login ()

@end

@implementation Login

@synthesize window = _window;
@synthesize loginPlatform = _loginPlatform;

 
-(void) cancelLogin:(NSString *)platform
{
    NSLog(@"to cancel login 2 %@ ", platform);
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
    
    NSString *platformType = [UMSocialSnsPlatformManager getSnsPlatformString:snsPlatform.shareToType];
    
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:platformType completion:^(UMSocialResponseEntity *response) {
        NSLog(@"unOauth response is %@",response);
//        NSString *result = [NSString stringWithFormat:@"%@", [response data]];
        FREDispatchStatusEventAsync(self.freContext, CancelAuthResult, (const uint8_t *)[[JSONKit ToDictToJSonString:response.data] UTF8String]);
        [self release];
    }];
}
-(void) setAcountInfo:(NSString*)platform usid:(NSString*)usid accessToken:(NSString*)accessToken openId:(NSString*)openId
{
    self.loginPlatform =platform;
    UMSocialAccountEntity *weiboAccount = [[UMSocialAccountEntity alloc] initWithPlatformName:platform];
    weiboAccount.usid = usid;
    weiboAccount.accessToken = accessToken;
    if(![openId isEqualToString:@""]){
            weiboAccount.openId = openId;          //腾讯微博账户必需设置openId
    }
    //同步用户信息
    [UMSocialAccountManager postSnsAccount:weiboAccount completion:^(UMSocialResponseEntity *response){
        NSLog(@"call setAcountInfo callback %d",response.responseCode);
        if (response.responseCode == UMSResponseCodeSuccess) {
            //在本地缓存设置得到的账户信息
            [UMSocialAccountManager setSnsAccount:weiboAccount];
            //进入你自定义的分享内容编辑页面或者使用我们的内容编辑页面
            [self handleAuthorResult];
        }
        else
        {
            FREDispatchStatusEventAsync(self.freContext, AuthResult, (const uint8_t *)response.responseCode);
        }
    }];
    
}

-(void) doLogin:(NSString*)platform
{
    NSLog(@"to get isOauth  %@",platform);
    
    BOOL isOauth = [UMSocialAccountManager isOauthAndTokenNotExpired:platform];
    self.loginPlatform = platform;
    NSLog(@"isOauth %d", isOauth);
    
    if(isOauth){
//        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
//        UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:platform];
//        NSLog(@"Release if oauthed %@", sinaAccount);
//        NSString* s = [JSONKit ToAccountToJSonString:sinaAccount];
//        FREDispatchStatusEventAsync(self.freContext, AuthResult, (const uint8_t *)[s UTF8String]);
        [self handleAuthorResult];
        [self release];
    }else{
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
        NSLog(@"platform: %@ snsPlatform.description: %@", platform,snsPlatform.description);
        snsPlatform.loginClickHandler(self.window.rootViewController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            NSLog(@"login response is %@",response);
            [self didFinishGetUMSocialDataInViewController:response];
        });
//
        
//        UIViewController *uic = self.window.rootViewController;
//        [uic addChildViewController:self];
//        [uic.view addSubview:self.view];
//        

//        UINavigationController *oauthController = [[UMSocialControllerService defaultControllerService] getSocialOauthController:platform];
//        [self.window.rootViewController presentModalViewController:oauthController animated:YES];
    }
}
-(void) unOAuth:(NSString *)platform token:(NSString *)token
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:platform  completion:^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
//        NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
//        UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:self.loginPlatform];
        
        NSLog(@"Removed From Superview");
        [self.view removeFromSuperview];
        [self handleAuthorResult];
//        FREDispatchStatusEventAsync(self.freContext, AuthResult, (const uint8_t *)[[sinaAccount description] UTF8String]);

    }];
}
-(BOOL) isOauth:(NSString *)platform
{
    return    [UMSocialAccountManager isOauthAndTokenNotExpired:platform];
}
-(void) getUserInformation:(NSString *)platform token:(NSString *)token
{
    [[UMSocialDataService defaultDataService] requestSnsInformation:platform  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSString *json;
        json = [JSONKit ToDictToJSonString:response.data];
        FREDispatchStatusEventAsync(self.freContext, (const uint8_t *)[token UTF8String], (const uint8_t *)[json UTF8String]);
        [self release];

    }];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"Response %@, %d", response, UMSViewControllerOauth);
    if (response.viewControllerType == UMSViewControllerOauth) {
//        NSString *result = [NSString stringWithFormat:@"%@", [response data]];
        NSLog(@"Removed From Superview");
        [self.view removeFromSuperview];
        [self release];
        
        [self handleAuthorResult];
       //        FREDispatchStatusEventAsync(self.freContext, AuthResult, (const uint8_t *)[result UTF8String]);
    }
}

-(void)handleAuthorResult
{
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:self.loginPlatform];
    FREDispatchStatusEventAsync(self.freContext, AuthResult, (const uint8_t *)[[JSONKit ToAccountToJSonString:sinaAccount] UTF8String]);

}
-(void)cancelUm:(NSString *)token
{
    [[UMSocialDataService defaultDataService] requestUnBindToSnsWithCompletion:^(UMSocialResponseEntity *response){
        NSLog(@"cancelUM response is %@",response);
        FREDispatchStatusEventAsync(self.freContext, (const uint8_t *)[token UTF8String], (uint8_t*)response.responseCode);
        [self release];
    }];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
