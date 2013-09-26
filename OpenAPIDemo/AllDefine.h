//
//  AllDefine.h
//  OpenAPIDemo
//
//  Created by my on 24/7/13.
//
//

#import <Foundation/Foundation.h>
#define kAdURLSchemePrefix              @"Ad_"

#define kAdKeychainServiceNameSuffix    @"_AndonServiceName"
#define kAdKeychainAccessToken          @"AndonAccessToken"
#define kAdKeychainExpireTime           @"AndonExpireTime"
#define kAdKeychainRefreshtoken         @"AndonRefreshtoken"
#define kAdKeychainAPIName              @"AndonAPIName"
#define kAdKeychainUserID               @"AndonUserID"



 //正式服务器
 #define kAuthURL @"https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/"
 #define kBaseInfoURL @"https://api.ihealthlabs.com:8443/openapiv2/user/"
 


//使用者需要更改的。使用时，到网站申请应用，换成应用的SC,SV
#define mysc @"9c6830141b7e43908******"
#define myweightsv @"34e038a2f5344ab******"
#define mybpsv @"02a746d4fe464c6689eb******"
#define myOXSV @"4c0eecccb0134104af******"
#define myBGSV @"bf058dbac2be413f8c9******"
#define mySleepSV @"c8e68a19f1b54ce5b******"
#define myActivitySV @"9eabc577831443d284******"
#define myredirect_uri @"http://www.ihealthlabs.com"
//使用者需要更改的


#define BPResult @"BPResult"
#define WeightResult @"WeightResult"
#define OXResult @"OXResult"
#define BGResult @"BGResult"
#define SleepResult @"SleepResult"
#define ActivityResult @"ActivityResult"




@interface AllDefine : NSObject

@end
