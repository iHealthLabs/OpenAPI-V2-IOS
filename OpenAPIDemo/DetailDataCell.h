//
//  DetailDataCell.h
//  OpenAPIDemo
//
//  Created by my on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailDataCell : UITableViewCell{
    IBOutlet UILabel *data1Lable;
    IBOutlet UILabel *data2Lable;
    IBOutlet UILabel *dateLable;
}
@property (retain, nonatomic) IBOutlet UILabel *myLab;

@property (retain, nonatomic)  UILabel *data1Lable;
@property (retain, nonatomic)  UILabel *data2Lable;
@property (retain, nonatomic)  UILabel *dateLable;

@end
