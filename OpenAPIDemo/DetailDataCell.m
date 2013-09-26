//
//  DetailDataCell.m
//  OpenAPIDemo
//
//  Created by my on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DetailDataCell.h"

@implementation DetailDataCell
@synthesize data1Lable,data2Lable,dateLable;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)dealloc
{
    [data1Lable release];
    [data2Lable release];
    [dateLable release];
    [_myLab release];
    [super dealloc];
}

@end
