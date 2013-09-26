//
//  AdAuth.h
//  OpenAPIDemo
//
//  Created by my on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdAuthWebView.h"

@protocol AdGetAccessTokenProtocol;
@interface AdAuth : UIView<AdAuthoWebViewDelegate>{
    NSString *appID;
    NSString *appKey;
    NSString *redirectURI;
    
    NSMutableData *accessTokenData;
    NSURLConnection *connection;
    
    id<AdGetAccessTokenProtocol> delegate;
}

@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *redirectURI;
@property (retain, nonatomic) NSURLConnection *connection;

@property (retain, nonatomic) NSMutableData *accessTokenData;

@property (nonatomic, assign) id<AdGetAccessTokenProtocol> delegate;

-(id)initWithAppID:(NSString *)appID andAppKey:(NSString *)appKey;
-(void)startAuth;

-(void)startRefreshWithCode:(NSString *)code;

-(NSString *)getUrlString:(NSString *)baseAuthUrl params:(NSDictionary *) params;
-(NSString *)stringFromDictionary:(NSDictionary *)dict;

- (void)handleResponseData:(NSData *)data;

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code;
- (id)parseJSONData:(NSData *)data error:(NSError **)error;
- (void)failedWithError:(NSError *)error;

@end
@protocol AdGetAccessTokenProtocol <NSObject>

-(void)didGetAccessToken:(id) result;

@end
