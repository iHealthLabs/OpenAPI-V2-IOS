//
//  AdRequest.h
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AdRequest : UIView{
    
    NSURLConnection *connection;
    
    NSMutableData *infoData;
    

}
@property (retain, nonatomic)NSString * dataType;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *infoData;



-(void)connect:(NSDictionary *)dic;

@end
