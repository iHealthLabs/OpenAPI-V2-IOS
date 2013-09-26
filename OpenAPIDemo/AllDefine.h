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

//测试服务器
#define kAuthURL @"http://testtokyo.ihealthlabs.com:8000/OpenApiV2/OAuthv2/userauthorization/"
#define kBaseInfoURL @"http://testtokyo.ihealthlabs.com:8000/openapiv2/user/"

/*
 //正式服务器
 #define kAuthURL @"http://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/"
 #define kBaseInfoURL @"http://api.ihealthlabs.com:8443/openapiv2/user/"
 
*/

//使用者需要更改的。使用时，到网站申请应用，换成应用的SC,SV
#define mysc @"9c6830141b7e43908895de2b1efe4424"
#define myweightsv @"34e038a2f5344abe8c748f2952042f22"
#define mybpsv @"02a746d4fe464c6689eb577b9c835c11"
#define myOXSV @"4c0eecccb0134104af7c5e4c1a2262dd"
#define myBGSV @"bf058dbac2be413f8c9e9bd1292548f9"
#define mySleepSV @"c8e68a19f1b54ce5b899a74e67a65c08"
#define myActivitySV @"9eabc577831443d284d73cec0811c416"
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
