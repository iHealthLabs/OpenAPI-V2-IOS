//
//  ViewController.h
//  OpenAPIDemo
//
//  Created by my on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdEngines.h"

@interface ViewController : UIViewController<didLoginProtocol,UIAlertViewDelegate>{
    AdEngines *engine;
}
    
@property (retain, nonatomic) IBOutlet UILabel *testLab;
@property (retain, nonatomic) AdEngines *engine;
-(IBAction)login:(id)sender;
- (void)presentDetailDataViewController:(BOOL)animated;

@end
