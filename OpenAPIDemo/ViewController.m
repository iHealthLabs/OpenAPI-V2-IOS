//
//  ViewController.m
//  OpenAPIDemo
//
//  Created by my on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AdEngines.h"
#import "DataRequestViewController.h"
#import "AllDefine.h"


//replace your appkey and appID 输入你的appID和密码
//http://192.168.3.69:8090/api/OAuthv2/userauthorization.ashx?client_id=81b5e1fab2804f92af2843e51d00d7b7&client_secret=678&grant_type=authorization_code&redirect_uri=http://678/oauthtest.aspx&code=mhMAED3sSBEsTTsXBS0LoJszuzBxQ46W-srZZucwntBw1dJS5IYY-vz9ZpHC-qZbNBQf*l7M1vcYH3TTYlTECnfRqC1OEOemtVZn*fS8xUE


//#define appID @"81b5e1fab2804f92af2843e51d00d7b7"
//#define appKey @"678"
//#define mysc @"B557ABBD157B4D4A99E794B35903382D"
//#define mysv @"2eed569296b942b4836e8ad1babb9c43"
//#define myweightsv @"2eed569296b942b4836e8ad1babb9c43"
//#define mybpsv @"2eed569296b942b4836e8ad1babb9c43"
//#define myredirect_uri @"http://678/" 

//#define appID @"356349d2956d43cfa825c1fe9e7f7135"
//#define appKey @"sss"
//#define mysc @"92105AEE747E41B8A89E554B35713945"
//#define myweightsv @"4bccd716c07544d486ce8eed542f74a8"
//#define mybpsv @"37483cf9c763407195ff73137468f600"
//#define myredirect_uri @"http://localhost:4811/oauthtest.aspx"

//
//#define appID @"b500e88fdaec43448862795c9a92f5d5"
//#define appKey @"abfdc2ac100e4e1593c5a2d00e6ebc9e"
//#define mysc @"62ca6f64fddd40ae820cf6c53e331526"
//#define myweightsv @"8396225165be4bd6816df55281bc9953"
//#define mybpsv @"1601786bccc346dfb9645d40a9b5bb72"
//#define myredirect_uri @"http://localhost:2839/WebForm1.aspx"
#define appID @"bd44ef426a434cf386891e3c2397fa51"
#define appKey @"d7a62ff0c66e4376aef6e87b69eef3e1"



@interface ViewController ()

@end

@implementation ViewController

@synthesize engine;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
//    [dateFormatter setTimeZone:timeZone];
//
//    NSDate *date=[NSDate dateWithTimeIntervalSince1970:10];
//    NSString *strDate=[dateFormatter stringFromDate:date];
//    NSString *str=[dateFormatter stringFromDate:strDate];
  //   NSArray *array = [NSTimeZone knownTimeZoneNames];
    self.navigationItem.title=@"Please Login";
    
	// Do any additional setup after loading the view, typically from a nib.
        engine=[[AdEngines alloc]initWithAppKey:appID appSecret:appKey];
        [engine setDelegate:self];
    if ([engine isLoggedIn]&&![engine isAuthorizeExpired]) {
        [self presentDetailDataViewController:NO];
    }
}

- (void)viewDidUnload
{
    [self setTestLab:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
     return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction)login:(id)sender
{
    if (engine==nil) {
        engine=[[AdEngines alloc]initWithAppKey:appID appSecret:appKey];
    }
    [engine setRedirectURI:myredirect_uri];
    [engine setDelegate:self];
    [engine logIn];
    
}

#pragma mark  didLoginDelegate
-(void)applicationDidLogin
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login"
                                             message:@"Succeed"
                                            delegate:self
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles: nil];
    [alert show];
    [alert release];
     [self presentDetailDataViewController:YES];
}

-(void)applicationLoginFailed
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login"
                                                 message:@"Failed"
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [alert show];
    [alert release];
}
-(void)applicationDidCanceled
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Login"
                                                 message:@"Canceled"
                                                delegate:self
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles: nil];
    [alert show];
    [alert release];
}

//#pragma mark alertView Delegate
//-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0) {
//        [self presentDetailDataViewController:YES];
//    }
//
//}

- (void)presentDetailDataViewController:(BOOL)animated
{

    DataRequestViewController *viewcontroller=[[DataRequestViewController alloc]init];
    viewcontroller.engine=engine;
    viewcontroller.theappID=appID;
    viewcontroller.theappKey=appKey;
    UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:viewcontroller];
    [self.navigationController presentModalViewController:nc animated:animated];
    [viewcontroller release];
    [nc release];
}

- (void)dealloc {
    [_testLab release];
    [super dealloc];
}
@end
