//
//  JSONKit.m
//  UMSocial
//
//  Created by Pamakids－Dev - Chita on 14-10-2.
//  Copyright (c) 2014年 pamakids. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"


@implementation JSONKit

-(NSString*) ToAccountToJSonString:(UMSocialAccountEntity*)account
{
    NSLog(@"ToAccountToJSonString~ ");
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:account.platformName,@"platformName",nil];
    
    
    NSDictionary *dictionary2 = [NSDictionary dictionaryWithObjectsAndKeys:account.platformName,@"platformName",account.userName,@"userName",account.usid,@"usid",account.iconURL,@"iconURL",account.accessToken,@"accessToken",nil];
    
    
    NSDictionary *dictionary3 = [NSDictionary dictionaryWithObjectsAndKeys:account.platformName,@"platformName",account.userName,@"userName",account.usid,@"usid",nil];
    
    
    NSDictionary *dictionary4 = [NSDictionary dictionaryWithObjectsAndKeys:account.platformName,@"platformName",account.userName,@"userName",account.usid,@"usid",account.iconURL,@"iconURL",account.accessToken,@"accessToken",account.profileURL,@"profileURL",account.expirationDate.description,@"expirationDate",nil];
    
    NSLog(@"dic: %@   \n%@   \n%@   \n%@   \n",dictionary,dictionary4,dictionary2,dictionary3);
    NSString* json = [self ToDictToJSonString:dictionary4];
    //    [dictionary release];
    return json;
}
+(NSString*) ToAccountToJSonString:(UMSocialAccountEntity*)account
{
    NSLog(@"ToAccountToJSonString~ ");
      NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:account.platformName,@"platformName",account.userName,@"userName",account.usid,@"usid",account.iconURL,@"iconURL",account.accessToken,@"accessToken",account.profileURL,@"profileURL",account.expirationDate.description,@"expirationDate",nil];



    NSString* json = [self ToDictToJSonString:dictionary];
    NSLog(@"dic: %@   ~%@",dictionary,json);
    return json;
}

+ (NSString*) ToDictToJSonString:(NSDictionary*)dict
{
    if(dict == nil) {
        return @"{}";
    }
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&jsonError];
    if (jsonError != nil) {
        NSLog(@"JSON stringify error: %@", jsonError.localizedDescription);
        return @"{}";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end