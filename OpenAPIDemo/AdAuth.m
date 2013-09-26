//
//  AdAuth.m
//  OpenAPIDemo
//
//  Created by my on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdAuth.h"
#import "AdAuthWebView.h"
#import "JSON.h"
#import "SBJSON.h"
#import "AllDefine.h"


@implementation AdAuth
@synthesize appID,appKey,redirectURI;
@synthesize accessTokenData;
@synthesize connection;
@synthesize delegate;

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

-(id)initWithAppID:(NSString *)theAppID andAppKey:(NSString *)theAppKey
{
    if (self=[super init]) {
        self.appID=theAppID;
        self.appKey=theAppKey;
    }
    return self;
}

-(void)startAuth
{
    //NSLog(@"%@",redirectURI);
    NSDictionary *authParams=[NSDictionary dictionaryWithObjectsAndKeys:appID,@"client_id",@"code", @"response_type",redirectURI,@"redirect_uri",@"OpenApiWeight+OpenApiBP+OpenApiSpO2+OpenApiBG+OpenApiActivity+OpenApiSleep",@"APIName",@"OpenApiWeight+OpenApiBP+OpenApiSpO2+OpenApiBG+OpenApiActivity+OpenApiSleep",@"RequiredAPIName", nil];
    
    NSString *urlString=[self getUrlString:kAuthURL params:authParams];
    NSLog(@"%@",urlString);
    AdAuthWebView *authWebView=[[AdAuthWebView alloc]init];
    [authWebView setDelegate:self];
    [authWebView loadRequestWithURL:[NSURL URLWithString:urlString]];
    [authWebView show:YES];
    [authWebView release];
}

-(void)startRefreshWithCode:(NSString *)code
{

    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:appID,@"client_id", appKey,@"client_secret",@"refresh_token",@"response_type",redirectURI,@"redirect_uri",code,@"refresh_token", nil];
    NSString *tokenUrlString=[self getUrlString:kAuthURL params:params];
    NSURL *url=[NSURL URLWithString:tokenUrlString];
    NSLog(@"%@",tokenUrlString);
    NSLog(@"%@",code);
    
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    connection=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [request release];
}

-(NSString *)getUrlString:(NSString *)baseAuthUrl params:(NSDictionary *) params
{
    NSURL *parsedURL=[NSURL URLWithString:baseAuthUrl];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString *query=[self stringFromDictionary:params];
    
    return [NSString stringWithFormat:@"%@%@%@", baseAuthUrl, queryPrefix, query];
    
}

-(NSString *)stringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [dict objectForKey:key]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
    
}
- (void)authorizeWebView:(AdAuthWebView *)webView didReceiveAuthorizeCode:(NSString *)code
{
    [webView hide:YES];
    NSLog(@"%@",code);
    // if not canceled
        [self requestAccessTokenWithAuthorizeCode:code];
    
}
// get AccessToken
#pragma mark -getAccessToken
- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code
{

    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:appID,@"client_id", appKey,@"client_secret",@"authorization_code",@"grant_type",redirectURI,@"redirect_uri",code,@"code", nil];
    NSString *tokenUrlString=[self getUrlString:kAuthURL params:params];
    NSURL *url=[NSURL URLWithString:tokenUrlString];
    NSLog(@"%@",tokenUrlString);
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    connection=[[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
    [request release];
}

-(void)dealloc
{
    [appKey release];
    [appID release];
    [redirectURI release];
    [super dealloc];
    
}


#pragma mark connection delegate
-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (accessTokenData==nil) {
        accessTokenData=[[NSMutableData alloc]init];
    }

}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [accessTokenData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	[self handleResponseData:accessTokenData];
    
	[accessTokenData release];
	accessTokenData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;

}

- (void)handleResponseData:(NSData *)data 
{
	
	NSError* error = nil;
	id result = [self parseJSONData:data error:&error];
	
	if (error)
	{
		[self failedWithError:error];
	} 
	else 
	{
        NSLog(@"%@",[(NSDictionary *)result objectForKey:@"AccessToken"]);
        NSLog(@"%i",[[(NSDictionary *)result objectForKey:@"Expires"]intValue]);//172800
        NSLog(@"%@",[(NSDictionary *)result objectForKey:@"APIName"]);//OpenApiBP OpenApiWeight
        
        [delegate didGetAccessToken:result];
	}
}

- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
	
	NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON *jsonParser = [[SBJSON alloc]init];
	
	NSError *parseError = nil;
	id result = [jsonParser objectWithString:dataString error:&parseError];
	
	if (parseError)
    {

	}
    
	[dataString release];
	[jsonParser release];
	
    
	if ([result isKindOfClass:[NSDictionary class]])
	{
        return result;
	}
	
	return result;
}


- (void)failedWithError:(NSError *)error 
{
//	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) 
//	{
//		[delegate request:self didFailWithError:error];
//	}
    NSLog(@"Prase JSON failed");
}

@end
