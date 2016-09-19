/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "AppDelegateParse.h"
#import <Parse/Parse.h>
#import "UserProfileManager.h"

@implementation AppDelegateParse

+ (instancetype)sharedInstance {
    static AppDelegateParse *_sharedEaseMob = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedEaseMob = [[AppDelegateParse alloc] init];
    });
    
    return _sharedEaseMob;
}

- (void)parseApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"YXA6WMIgQHCpEeauDEPauorR_w"
                  clientKey:@"YXA6_sgqo4S2kjjWSjzwFYlo1XHgwWM"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    // setup ACL
    PFACL *defaultACL = [PFACL ACL];

    [defaultACL setPublicReadAccess:YES];
    [defaultACL setPublicWriteAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}

- (void)initParse
{
    [[UserProfileManager sharedInstance] initParse];
}

- (void)clearParse
{
    [[UserProfileManager sharedInstance] clearParse];
}

@end
