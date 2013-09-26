//
//  AdRequest.m
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdRequest.h"
#import "JSON.h"
#import "AllDefine.h"





@implementation AdRequest

@synthesize connection;
@synthesize infoData,dataType;


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

//-(id)initWithParams:(NSDictionary *)params;
//{
//    self.theparams=params;
//    return self;
//}

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

-(void)connect:(NSDictionary *)dic;
{
    NSDictionary *params=[dic valueForKey:@"params"];
    NSString *userID=[dic valueForKey:@"userID"];
    self.dataType=[dic valueForKey:@"type"];
    NSString *theBaseURL=nil;
    NSString *infoURLString=nil;
    if ([self.dataType isEqualToString:WeightResult]){
        theBaseURL=[NSString stringWithFormat:@"%@%@/weight.json/",kBaseInfoURL,userID];
    }else if ([self.dataType isEqualToString:BPResult]){
       theBaseURL=[NSString stringWithFormat:@"%@%@/bp.json/",kBaseInfoURL,userID]; 
    }else if ([self.dataType isEqualToString:OXResult]){
        theBaseURL=[NSString stringWithFormat:@"%@%@/spo2.json/",kBaseInfoURL,userID];
    }else if ([self.dataType isEqualToString:BGResult]){
        theBaseURL=[NSString stringWithFormat:@"%@%@/glucose.json/",kBaseInfoURL,userID];
    }else if ([self.dataType isEqualToString:SleepResult]){
        theBaseURL=[NSString stringWithFormat:@"%@%@/sleep.json/",kBaseInfoURL,userID];
    }else if ([self.dataType isEqualToString:ActivityResult]){
        theBaseURL=[NSString stringWithFormat:@"%@%@/activity.json/",kBaseInfoURL,userID];
    }

    infoURLString=[self getUrlString:theBaseURL params:params];
    NSLog(@"infoURLString==%@",infoURLString);
    NSURL *url=[NSURL URLWithString:infoURLString];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
    connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    [request release];
    
    
}

#pragma mark connection delegate
-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (infoData==nil) {
        infoData=[[NSMutableData alloc]init];
    }
    
}
-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [infoData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	[self handleResponseData:infoData];
    
	[infoData release];
	infoData = nil;
    
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
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:result,@"result",self.dataType,@"dataType", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didReceiveRequestData" object:self userInfo:dic];
        
        //[delegate requestDidReceiveData:result type:self.dataType];
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

    NSLog(@"Prase JSON failed");
}


@end
