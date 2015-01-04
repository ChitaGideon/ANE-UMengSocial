//
//  JSONKit.h
//  UMSocial
//
//  Created by Pamakids－Dev - Chita on 14-10-2.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#ifndef UMSocial_JSONKit_h
#define UMSocial_JSONKit_h


#endif

#import "UMSocialAccountManager.h"

@interface JSONKit : NSObject 

+(NSString*) ToDictToJSonString:(NSDictionary*)dict;

+(NSString*) ToAccountToJSonString:(UMSocialAccountEntity*)account;
@end