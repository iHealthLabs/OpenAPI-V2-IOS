//
//  AdEngines.h
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAuth.h"
#import "AdRequest.h"


@protocol didLoginProtocol;

@interface AdEngines : UIView<AdGetAccessTokenProtocol>{
    NSString        *appKey;
    NSString        *appSecret;
    NSString        *userID;
    NSString        *accessToken;
    NSTimeInterval  expireTime;
    
    NSString        *refreshToken;
    NSString        *aPIName;
    
    NSString        *redirectURI;
    
    // Determine whether user must log out before another logging in.
    BOOL            isUserExclusive;
    
    AdAuth *authorize;
    
    
    UIViewController *rootViewController;
    
    id<didLoginProtocol> delegate;
    
 
    
    AdRequest *dataRequest;
    
    
}

@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, assign) NSTimeInterval expireTime;
@property (nonatomic, retain) NSString *redirectURI;

@property (nonatomic, retain) NSString *refreshToken;
@property (nonatomic, retain) NSString *aPIName;

@property (nonatomic, assign) BOOL isUserExclusive;
@property (nonatomic, retain) AdAuth *authorize;

@property (nonatomic, assign) UIViewController *rootViewController;

@property (nonatomic, assign) id<didLoginProtocol> delegate;


@property (nonatomic, retain) AdRequest *dataRequest;



- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret;

// Log in using OAuth Web authorization.
// If succeed, engineDidLogIn will be called.
- (void)logIn;
-(void)logout;
-(void)didGetAccessToken:(id) result;

-(void)getDataWithParams:(NSDictionary *)params type:(NSString *)type;


// Log in using OAuth Client authorization.
// If succeed, engineDidLogIn will be called.
//- (void)logInUsingUserID:(NSString *)theUserID password:(NSString *)thePassword;
//
//// Log out.
//// If succeed, engineDidLogOut will be called.
//- (void)logOut;
//
//// Check if user has logged in, or the authorization is expired.
- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;

-(void) refreshTokenWithCode:(NSString *)code;


- (NSString *)urlSchemeString;

- (void)saveAuthorizeDataToKeychain;
- (void)readAuthorizeDataFromKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end
@protocol didLoginProtocol <NSObject>

-(void)applicationDidLogin;

-(void)applicationDidCanceled;

-(void)applicationLoginFailed;

@end
