//
//  BPTableViewController.h
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailDataCell.h"

@interface DataInfoTableViewController : UITableViewController<UIAlertViewDelegate>{
    NSMutableArray *sourceDataArray;
    
    NSString *prevPageUrl;
    NSString *nextPageUrl;
    NSURLConnection *connection;
    NSMutableData *bpdata;
    
    UIAlertView *preAlert;
    UIAlertView *nextAlert;
    
    IBOutlet DetailDataCell *detaildatacell;
}
@property (retain, nonatomic)NSString *sourceTye;
@property (retain, nonatomic) NSMutableArray *sourceDataArray;

@property (retain, nonatomic) NSString *prevPageUrl;
@property (retain, nonatomic) NSString *nextPageUrl;
@property (retain, nonatomic) NSURLConnection *connection;
@property (retain, nonatomic) NSMutableData *bpdata;

@property (retain, nonatomic) UIAlertView *preAlert;
@property (retain, nonatomic) UIAlertView *nextAlert;

@property (retain, nonatomic) DetailDataCell *detaildatacell;


- (IBAction)segmentAction:(id)sender;
-(void) nextPage;
-(void) prePage;

@end
