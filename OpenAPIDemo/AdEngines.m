//
//  AdEngines.m
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdEngines.h"

#import "AdAuth.h"
#import "SFHFKeychainUtils.h"
#import "AllDefine.h"



@interface AdEngines (Private)



@end

@implementation AdEngines
@synthesize appKey;
@synthesize appSecret;
@synthesize userID;
@synthesize accessToken;
@synthesize expireTime;
@synthesize redirectURI;
@synthesize isUserExclusive;
@synthesize authorize;
@synthesize rootViewController;

@synthesize refreshToken;
@synthesize aPIName;

@synthesize delegate;


@synthesize dataRequest;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithAppKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret
{
    [super init];
    if (self = [super init])
    {
        self.appKey = theAppKey;
        self.appSecret = theAppSecret;
        
        isUserExclusive = NO;
        
        [self readAuthorizeDataFromKeychain];
    }
    
    return self;
}
- (void)dealloc
{
    [appKey release], appKey = nil;
    [appSecret release], appSecret = nil;
    
    [userID release], userID = nil;
    [accessToken release], accessToken = nil;
    
    [redirectURI release], redirectURI = nil;
    
    //    [authorize setDelegate:nil];
    //    [authorize release], authorize = nil;
    
    rootViewController = nil;
    
    [super dealloc];
}

#pragma mark Request
-(void)getDataWithParams:(NSDictionary *)params type:(NSString *)type
{
    dataRequest=[[AdRequest alloc]initWithParams:params];
    dataRequest.dataType=type;
     [dataRequest connect];
}
#pragma mark login

-(void)logIn
{
    authorize=[[AdAuth alloc]initWithAppID:appKey andAppKey:appSecret];
    [authorize setRedirectURI:self.redirectURI];
    NSLog(@"%@",self.redirectURI);
    [authorize setDelegate:self];
    [authorize startAuth];
}
-(void)logout
{
    [self deleteAuthorizeDataInKeychain];
}

//获取Accesstoken
-(void)didGetAccessToken:(id) result
{
    NSLog(@"reerere:%@",result);
//    $0 = 0x06dbf590 {
//        APIName = "OpenApiBP OpenApiWeight";
//        AccessToken = "S5zeQQcL3fullV1LY5*x6gyahI9WssGmxxkrU8l41f*xqG2aOIV9-wjgYztZYBGFCe*Bv-RQ*3vCZK12TngIltJuSRX15mf5UnsR35muxFQHOQdi1l8ZXUsxfAOE1ZGiTw8URFu6JY8vQ4eR--QgBg";
//        Expires = 172800;
//        RefreshToken = "S5zeQQcL3fullV1LY5*x6gyahI9WssGmxxkrU8l41f*xqG2aOIV9-wjgYztZYBGFCe*Bv-RQ*3vCZK12TngIliPAiaxUCRRDEP9nJHZ6jCtJ*aXoY5u5oIRKMrJMRNX26Atd4Nzpur-rmgmc9VA3Hw";
//        UserID = 62fdf3fd6ff74d8587c4b686b46c9336;
//        "client_para" = "";
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.accessToken=[result objectForKey:@"AccessToken"];
        NSLog(@"%@",self.accessToken);
        self.expireTime=[[NSDate date] timeIntervalSince1970] +[[result objectForKey:@"Expires"]intValue];
        self.refreshToken=[result objectForKey:@"RefreshToken"];
        NSLog(@"%@",self.refreshToken);
        self.aPIName=[result objectForKey:@"APIName"];
        self.userID=[result objectForKey:@"UserID"];
        if (accessToken&&expireTime&&refreshToken) {
            [self saveAuthorizeDataToKeychain];
        [delegate applicationDidLogin];
        }
        else{
            [delegate applicationLoginFailed];
        }
    }
    else{
        [delegate applicationLoginFailed];
    }

}

- (BOOL)isLoggedIn
{
    NSLog(@"%i",self.accessToken&&(self.expireTime>0));
    NSLog(@"%@",self.accessToken);
    return self.accessToken&&(self.expireTime>0);

}

- (BOOL)isAuthorizeExpired
{
    if ([[NSDate date] timeIntervalSince1970] > expireTime)
    {
        // force to log out
        [self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}


#pragma mark AdAuthPrivate method
- (NSString *)urlSchemeString
{
    return [NSString stringWithFormat:@"%@%@",kAdURLSchemePrefix,appKey];
}

- (void)saveAuthorizeDataToKeychain
{
    NSString *serviceName=[[self urlSchemeString] stringByAppendingFormat:kAdKeychainServiceNameSuffix];
    [SFHFKeychainUtils storeUsername:kAdKeychainAccessToken andPassword:accessToken forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kAdKeychainExpireTime andPassword:[NSString stringWithFormat:@"%lf", expireTime] forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kAdKeychainRefreshtoken andPassword:refreshToken forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kAdKeychainAPIName andPassword:aPIName forServiceName:serviceName updateExisting:YES error:nil];
    [SFHFKeychainUtils storeUsername:kAdKeychainUserID andPassword:self.userID forServiceName:serviceName updateExisting:YES error:nil];
}
- (void)readAuthorizeDataFromKeychain
{
    NSString *serviceName=[[self urlSchemeString] stringByAppendingString:kAdKeychainServiceNameSuffix];
    self.accessToken=[SFHFKeychainUtils getPasswordForUsername:kAdKeychainAccessToken andServiceName:serviceName error:nil];
    self.expireTime=[[SFHFKeychainUtils getPasswordForUsername:kAdKeychainExpireTime andServiceName:serviceName error:nil]doubleValue];
    self.refreshToken=[SFHFKeychainUtils getPasswordForUsername:kAdKeychainRefreshtoken andServiceName:serviceName error:nil];
    self.aPIName=[SFHFKeychainUtils getPasswordForUsername:kAdKeychainAPIName andServiceName:serviceName error:nil];
    self.userID=[SFHFKeychainUtils getPasswordForUsername:kAdKeychainUserID andServiceName:serviceName error:nil];
    
}
- (void)deleteAuthorizeDataInKeychain
{
    self.accessToken=nil;
    self.expireTime=0;
    NSString *serviceName=[[self urlSchemeString] stringByAppendingString:kAdKeychainServiceNameSuffix];
    [SFHFKeychainUtils deleteItemForUsername:kAdKeychainAccessToken andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kAdKeychainExpireTime andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kAdKeychainRefreshtoken andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kAdKeychainAPIName andServiceName:serviceName error:nil];
    [SFHFKeychainUtils deleteItemForUsername:kAdKeychainUserID andServiceName:serviceName error:nil];
}

-(void) refreshTokenWithCode:(NSString *)code
{
    NSLog(@"%@",code);
    if (authorize==nil) {
        authorize=[[AdAuth alloc]initWithAppID:appKey andAppKey:appSecret];
        [authorize setRedirectURI:self.redirectURI];
        NSLog(@"%@",self.redirectURI);
        [authorize setDelegate:self];
    }
    [authorize startRefreshWithCode:code];
}


@end
