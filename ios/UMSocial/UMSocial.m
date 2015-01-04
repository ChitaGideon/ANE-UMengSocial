//
//  UMengSocial.m
//  UMengSocial
//
//  Created by mani on 13-7-17.
//  Copyright (c) 2013年 yeahugo. All rights reserved.
//

#import "UMSocial.h"
#import "FlashRuntimeExtensions.h"
#import "SocialControler.h"
#import "Login.h"
#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialWechatHandler.h"
 #import "UMSocialQQHandler.h"

@implementation UMSocial

FREObject init(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call Init Function");
    
    uint32_t stringLength;
    const uint8_t* appKey;
    NSString *appKeyString = nil;
    
    
    uint32_t isopenLog = 0;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &appKey) == FRE_OK)){
        appKeyString = [NSString stringWithUTF8String:(char*)appKey];
        [UMSocialData setAppKey:appKeyString];
    }
    if(argv[1] && (FREGetObjectAsBool(argv[1], &isopenLog) == FRE_OK)){
        [UMSocialData openLog:(BOOL)isopenLog];
    }

    
//    uint32_t useSocialBar = 0;
//    BOOL status = YES;
//    
//    if(argv[2] && (FREGetObjectAsUint32(argv[2], &useSocialBar)==FRE_OK)){
//        status = useSocialBar == 1;
//        if(status){
//            SocialControler* sc = funcData;
//            [sc initBar];
//        }
//    }
    
//    [UMSocialConfig setSupportSinaSSO:NO];
    
    NSLog(@"Called Init Function Finished %@    log? %d", appKeyString,isopenLog);
    
    return nil;
}
FREObject initWeChat(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    uint32_t stringLength;
      uint32_t stringLength2;
      uint32_t stringLength3;
    const uint8_t* appKey;
    NSString *appKeyString = nil;
    const uint8_t* wechatKey;
    NSString *wechatKeyString = nil;
    const uint8_t* wxurl;
    NSString *wxurlString = nil;
    
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &appKey) == FRE_OK)){
        appKeyString = [NSString stringWithUTF8String:(char*)appKey];
//        [UMSocialData setAppKey:appKeyString];
    }
    
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength2, &wxurl) == FRE_OK)){
        wxurlString = [NSString stringWithUTF8String:(char*)wxurl];
    }
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength3, &wechatKey) == FRE_OK)){
        wechatKeyString = [NSString stringWithUTF8String:(char*)wechatKey];
        NSLog(@"setWXAppId %@ %@ %@",appKeyString,wechatKeyString,wxurlString);
        [UMSocialWechatHandler setWXAppId:appKeyString appSecret:wechatKeyString url:wxurlString];
    }
    
    return nil;
}

FREObject initQQ(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    uint32_t stringLength;
    uint32_t stringLength2;
    uint32_t stringLength3;
    const uint8_t* appKey;
    NSString *appKeyString = nil;
    const uint8_t* wechatKey;
    NSString *wechatKeyString = nil;
    const uint8_t* wxurl;
    NSString *wxurlString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &appKey) == FRE_OK)){
        appKeyString = [NSString stringWithUTF8String:(char*)appKey];
        //        [UMSocialData setAppKey:appKeyString];
    }
    
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength2, &wxurl) == FRE_OK)){
        wxurlString = [NSString stringWithUTF8String:(char*)wxurl];
    }
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength3, &wechatKey) == FRE_OK)){
        wechatKeyString = [NSString stringWithUTF8String:(char*)wechatKey];
//        [UMSocialQQHandler setSupportWebView:YES];
        NSLog(@"initQQ %@ %@ %@",appKeyString,wechatKeyString,wxurlString);
//        [UMSocialWechatHandler setWXAppId:appKeyString appSecret:wechatKeyString url:wxurlString];
        [UMSocialQQHandler setQQWithAppId:appKeyString appKey:wechatKeyString url:wxurlString];
//        [UMSocialQQHandler setSupportWebView:YES];
    }
    
    return nil;
}

FREObject status(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call status Function");
    
    uint32_t statusInt = 0;
    BOOL status = YES;
    
    if(argv[0] && (FREGetObjectAsUint32(argv[0], &statusInt)==FRE_OK)){
        status = statusInt == 1;
    }
    
    SocialControler* sc = funcData;
    [sc status:status];

    NSLog(@"Called status Function %d, %d", status, statusInt);
    
    return nil;
}

FREObject login(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    
    NSLog(@"Call login Function");
    
    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    
    Login* lc = [[Login alloc] init];
    lc.freContext = context;
    lc.window = funcData;
    
    [lc doLogin:platformString];
    
    return nil;
}

FREObject isOauth(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"isOauth");
    Login* lc = (Login*)funcData;

    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    

    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    

    
    BOOL b = [lc isOauth:platformString];
    FREObject retBool = nil;
    FRENewObjectFromBool(b, &retBool);
    return retBool;
    
    
}

FREObject getUserInfo(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"getUserInfo");
    Login* lc = (Login*)funcData;

    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    
    const uint8_t* token;
    uint32_t tokenLength;
    NSString *tokenString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &tokenLength, &token) == FRE_OK)){
        tokenString = [NSString stringWithUTF8String:(char*)token];
    }
    [lc getUserInformation:platformString token:tokenString];
    return nil;
}

FREObject unOauth(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"unOauth");
    Login* lc = (Login*)funcData;
    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    
    const uint8_t* token;
    uint32_t tokenLength;
    NSString *tokenString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &tokenLength, &token) == FRE_OK)){
        tokenString = [NSString stringWithUTF8String:(char*)token];
    }
    [lc unOAuth:platformString token:tokenString];
    return nil;

}

FREObject cancelUM(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    
    const uint8_t* token;
    uint32_t tokenLength;
    NSString *tokenString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[1], &tokenLength, &token) == FRE_OK)){
        tokenString = [NSString stringWithUTF8String:(char*)token];
    }
    Login* lc = [[Login alloc] init];
    lc.freContext = context;
    lc.window = funcData;

    [lc cancelUm:tokenString];

    return nil;
}

FREObject cancelLogin(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    
    NSLog(@"Call cancelLogin Function");
    
    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    
    NSLog(@"Call cancelLogin Function %@", platformString);
    
    Login* lc = [[Login alloc] init];
    lc.freContext = context;
    lc.window = funcData;
    
    [lc cancelLogin:platformString];
    
    return nil;
}

FREObject setAccountInfo(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call setAccountInfo Function");
    
    const uint8_t* platform;
    uint32_t stringLength;
    NSString *platformString = nil;
    
    const uint8_t* usid;
    uint32_t stringLength2;
    NSString *usidString = nil;
    
    const uint8_t* accessToken;
    uint32_t stringLength3;
    NSString *accessTokenString = nil;
    
    const uint8_t* openid;
    uint32_t stringLength4;
    NSString *openidString = nil;
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &platform) == FRE_OK)){
        platformString = [NSString stringWithUTF8String:(char*)platform];
    }
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength2, &usid) == FRE_OK)){
        usidString = [NSString stringWithUTF8String:(char*)usid];
    }
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength3, &accessToken) == FRE_OK)){
        accessTokenString = [NSString stringWithUTF8String:(char*)accessToken];
    }
    if(argv[3] && (FREGetObjectAsUTF8(argv[3], &stringLength4, &openid) == FRE_OK)){
        openidString = [NSString stringWithUTF8String:(char*)openid];
    }
    
    NSLog(@"Called setAccountInfo Function platformString: %@, usidString: %@, accessTokenString: %@, openId: %@ isEqualToString?:  %d", platformString, usidString, accessTokenString, openidString,[openidString isEqualToString:@""]);
    Login* lc = [[Login alloc] init];
    lc.freContext = context;
    lc.window = funcData;
    [lc setAcountInfo:platformString usid:usidString accessToken:accessTokenString openId:openidString];
    return nil;
}



FREObject dataID(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call dataID Function");
    
    const uint8_t* dataID;
    uint32_t stringLength;
    NSString *dataIDString = nil;
    
    const uint8_t* sahreText;
     uint32_t stringLength2;
    NSString *shareTextString = nil;
    
    const uint8_t* imageUrl;
     uint32_t stringLength3;
    NSString *imageUrlString = nil;
    
    const uint8_t* title;
     uint32_t stringLength4;
    NSString *titleString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &dataID) == FRE_OK)){
        dataIDString = [NSString stringWithUTF8String:(char*)dataID];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength2, &sahreText) == FRE_OK)){
        shareTextString = [NSString stringWithUTF8String:(char*)sahreText];
    }
    
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength3, &imageUrl) == FRE_OK)){
        imageUrlString = [NSString stringWithUTF8String:(char*)imageUrl];
    }
    
    if(argv[3] && (FREGetObjectAsUTF8(argv[3], &stringLength4, &title) == FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    
    SocialControler* sc = funcData;
    [sc dataID:dataIDString shareText:shareTextString imageUrl:imageUrlString title:titleString];
    
    NSLog(@"Called dataID Function DataID: %@, shareText: %@, imageURL: %@, title: %@", dataIDString, shareTextString, imageUrlString, titleString);
    
    return nil;
}

FREObject share(FREContext context, void* funcData, uint32_t argc, FREObject argv[]){
    NSLog(@"Call share Function");
    
    const uint8_t* dataID;
    uint32_t stringLength;
    NSString *dataIDString = nil;
    
    const uint8_t* sahreText;
    NSString *shareTextString = nil;
    
    const uint8_t* imageUrl;
    NSString *imageUrlString = nil;
    
    const uint8_t* title;
    NSString *titleString = nil;
    
    const uint8_t* type;
    NSString *typeString = nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &dataID) == FRE_OK)){
        dataIDString = [NSString stringWithUTF8String:(char*)dataID];
    }
    
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength, &sahreText) == FRE_OK)){
        shareTextString = [NSString stringWithUTF8String:(char*)sahreText];
    }
    
    if(argv[2] && (FREGetObjectAsUTF8(argv[2], &stringLength, &imageUrl) == FRE_OK)){
        imageUrlString = [NSString stringWithUTF8String:(char*)imageUrl];
    }
    
    if(argv[3] && (FREGetObjectAsUTF8(argv[3], &stringLength, &title) == FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    
    if(argv[4] && (FREGetObjectAsUTF8(argv[4], &stringLength, &type) == FRE_OK)){
        typeString = [NSString stringWithUTF8String:(char*)type];
    }
    
    NSLog(@"Called share Function DataID: %@, shareText: %@, imageURL: %@, title: %@, type: %@", dataIDString, shareTextString, imageUrlString, titleString, typeString);
    
    SocialControler* sc = funcData;
    [sc share:dataIDString shareText:shareTextString imageUrl:imageUrlString title:titleString type:typeString];
    
    return nil;
}

void AirUMSocialContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest,
                             const FRENamedFunction** functionsToSet){
    
    //    [NotificationChecker load];
    
    //injects our modified delegate functions into the sharedApplication delegate
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    if (modDelegate == nil) {
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:handleOpenURL:);
        
        SEL selectorToOverride2 = @selector(application:openURL:sourceApplication:annotation:);
        
//        SEL selectorToOverride3 = @selector(application:didReceiveRemoteNotification:);
        
        // get the info on the method we're going to override
        Method m1 = class_getInstanceMethod(objectClass, selectorToOverride1);
        Method m2 = class_getInstanceMethod(objectClass, selectorToOverride2);
//        Method m3 = class_getInstanceMethod(objectClass, selectorToOverride3);
        
        // add the method to the new class
        class_addMethod(modDelegate, selectorToOverride1, (IMP)handleOpenURL, method_getTypeEncoding(m1));
        class_addMethod(modDelegate, selectorToOverride2, (IMP)openURL, method_getTypeEncoding(m2));
//        class_addMethod(modDelegate, selectorToOverride3, (IMP)didReceiveRemoteNotification, method_getTypeEncoding(m3));
        
        // register the new class with the runtime
        objc_registerClassPair(modDelegate);
    }
    // change the class of the object
    object_setClass(delegate, modDelegate);
    
    
    uint numOfFun = 13;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * numOfFun);
    *numFunctionsToTest = numOfFun;
    
    SocialControler* socialControler = [[SocialControler alloc] init];
    socialControler.freContext = ctx;
    UIWindow * win = [delegate window];
    socialControler.window = win;
    
    Login* lc = [[Login alloc] init];
    lc.freContext = ctx;
    lc.window = win;

    FRESetContextNativeData( ctx, socialControler );
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = socialControler;
    func[0].function = &init;
    
    func[1].name = (const uint8_t*) "status";
    func[1].functionData = socialControler;
    func[1].function = &status;
    
    func[2].name = (const uint8_t*) "dataID";
    func[2].functionData = socialControler;
    func[2].function = &dataID;
    
    func[3].name = (const uint8_t*) "share";
    func[3].functionData = socialControler;
    func[3].function = &share;
    
    func[4].name = (const uint8_t*) "login";
    func[4].functionData = win;
    func[4].function = &login;
    
    func[5].name =(const uint8_t*) "cancelLogin";
    func[5].functionData = win;
    func[5].function = &cancelLogin;
    
    func[6].name =(const uint8_t*) "isoAuth";
    func[6].functionData = lc;
    func[6].function = &isOauth;
    
    func[7].name =(const uint8_t*) "unOauth";
    func[7].functionData = lc;
    func[7].function = &unOauth ;
    
    func[8].name =(const uint8_t*) "getSnsInformation";
    func[8].functionData = lc;
    func[8].function = &getUserInfo;
    
    func[9].name =(const uint8_t*) "initWeChat";
    func[9].functionData = lc;
    func[9].function = &initWeChat;
    
    func[10].name =(const uint8_t*) "initQQ";
    func[10].functionData = lc;
    func[10].function = &initQQ;
    
    func[11].name =(const uint8_t*) "setAccountInfo";
    func[11].functionData = win;
    func[11].function = &setAccountInfo;
    
    
    func[12].name =(const uint8_t*) "unBindUm";
    func[12].functionData = win;
    func[12].function = &cancelUM;

    
    
    *functionsToSet = func;
    
    NSLog(@"Inited");
    NSLog(@"%@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@  %@ %@  ",UMShareToSina, UMShareToTencent, UMShareToRenren, UMShareToDouban , UMShareToQzone  , UMShareToEmail  , UMShareToSms  , UMShareToWechatSession  , UMShareToWechatTimeline  ,UMShareToWechatFavorite  , UMShareToQQ  , UMShareToFacebook  , UMShareToTwitter  , UMShareToYXSession  , UMShareToYXTimeline  , UMShareToLWSession , UMShareToLWTimeline  ,UMShareToInstagram  , UMShareToWhatsapp  , UMShareToLine  , UMShareToTumblr  , UMShareToPinterest  , UMShareToKakaoTalk  , UMShareToFlickr);
}

void UMengExtFinalizer(void* extData)
{
    NSLog(@"Finalize!");
    return;
}

void AirUMSocialContextFinalizer(FREContext ctx) { }
void AirUMSocialFinalizer(void *extData) { }

void AirUMSocialInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirUMSocialContextInitializer;
    *ctxFinalizerToSet = &AirUMSocialContextFinalizer;
}

//custom implementations of empty signatures above. Used for push notification delegate implementation.
BOOL handleOpenURL(id self, SEL _cmd, UIApplication* application, NSURL* url)
{
    return [UMSocialSnsService handleOpenURL:url];
}

//custom implementations of empty signatures above. Used for push notification delegate implementation.
BOOL openURL(id self, SEL _cmd, UIApplication* application,  NSURL* url,NSString* sourceApplication,id* annotation)
{
    return  [UMSocialSnsService handleOpenURL:url];
}



- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{}
//
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{}

@end
