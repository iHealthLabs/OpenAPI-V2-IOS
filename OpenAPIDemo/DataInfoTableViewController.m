//
//  BPTableViewController.m
//  OpenAPIDemo
//
//  Created by my on 12-5-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataInfoTableViewController.h"
#import "JSON.h"
#import "AllDefine.h"

@interface DataInfoTableViewController ()

@end

@implementation DataInfoTableViewController
@synthesize sourceDataArray,sourceTye;

@synthesize prevPageUrl;
@synthesize nextPageUrl;
@synthesize connection;
@synthesize bpdata;

@synthesize preAlert;
@synthesize nextAlert;

@synthesize detaildatacell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)sortSourceData{
    if ([self.sourceTye isEqualToString:SleepResult]) {
        //对数据源排序
        NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"StartTime" ascending:YES];
        NSArray *arrSort=[NSArray arrayWithObjects:sort, nil];
        [self.sourceDataArray sortUsingDescriptors:arrSort];
        
    }else{
        //对数据源排序
        NSSortDescriptor *sort=[[NSSortDescriptor alloc]initWithKey:@"MDate" ascending:YES];
        NSArray *arrSort=[NSArray arrayWithObjects:sort, nil];
        [self.sourceDataArray sortUsingDescriptors:arrSort];
    }
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self sortSourceData];
     
 }
- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.navigationItem.title=@"Your Data";
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
                                            [NSArray arrayWithObjects:
                                             [UIImage imageNamed:@"up.png"],
                                             [UIImage imageNamed:@"down.png"],
                                             nil]];
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
    
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
    [segmentBarItem release];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"
//                                                                           style:UIBarButtonItemStyleDone
//                                                                          target:self action:@selector(dismissBPTableView)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [nextAlert release];
    [preAlert release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   
    return [sourceDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailDataCell *cell=(DetailDataCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DetailDataCell" owner:self options:nil];
        cell=detaildatacell;
        self.detaildatacell=nil;
    }
    NSDictionary *detail = [sourceDataArray objectAtIndex:indexPath.row];
    
    NSDateFormatter *dateFormatter=nil;
    if(dateFormatter==nil){
        dateFormatter=[[NSDateFormatter alloc]init];
        NSTimeZone *timeZone=[NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        NSLocale *locale = [NSLocale currentLocale];
        [dateFormatter setLocale:locale];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
    }
    NSString *dateString=[NSString stringWithFormat:@"%@",[detail objectForKey:@"MDate"]];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:[dateString intValue]];
    NSString *strDate=[dateFormatter stringFromDate:date];
    
    cell.myLab.font=[UIFont systemFontOfSize:17];
    if ([self.sourceTye isEqualToString:WeightResult]) {
        cell.myLab.text=[NSString stringWithFormat:@"%@\nWeight:%.1f kg       BMI:%.1f",strDate,[[detail objectForKey:@"WeightValue"]floatValue],[[detail objectForKey:@"BMI"]floatValue]];
    }else if ([self.sourceTye isEqualToString:BPResult]){
      
        NSString *hp=[NSString stringWithFormat:@"%.0f",[[detail objectForKey:@"HP"]floatValue]];
        NSString *lp=[NSString stringWithFormat:@"%.0f",[[detail objectForKey:@"LP"]floatValue]];
        NSString *hr=[NSString stringWithFormat:@"%@",[detail objectForKey:@"HR"]];
        [dateFormatter release];
        cell.myLab.text=[NSString stringWithFormat:@"%@\nHP:%@ mmHg       LP:%@ mmHg/n  HR:%@ Beats/Min",strDate,hp,lp,hr];

    }else if ([self.sourceTye isEqualToString:OXResult]){
        NSString *spo2=[NSString stringWithFormat:@"%@",[detail objectForKey:@"BO"]];
        NSString *PR=[NSString stringWithFormat:@"%@",[detail objectForKey:@"HR"]];
        cell.dateLable.text=[NSString stringWithFormat:@"%@",strDate];
        cell.data1Lable.text=[NSString stringWithFormat:@"SPO2:%@",spo2];
        cell.data2Lable.text =[NSString stringWithFormat:@"PR:%@",PR];
        [dateFormatter release];
        cell.myLab.text=[NSString stringWithFormat:@"%@\nSPO2:%@      PR:%@",strDate,spo2,PR];
        
        
    }else if ([self.sourceTye isEqualToString:BGResult]){
        cell.myLab.font=[UIFont systemFontOfSize:15];
        NSString *bgResult=[NSString stringWithFormat:@"%.1f",[[detail objectForKey:@"BG"]floatValue]];
        NSString *dinnerSituation=[NSString stringWithFormat:@"%@",[detail objectForKey:@"DinnerSituation"]];
         NSString *drugSituation=[NSString stringWithFormat:@"%@",[detail objectForKey:@"DrugSituation"]];
         cell.myLab.text=[NSString stringWithFormat:@"%@   BGResult:%@ mg/dl\nDinnerSituation:%@\nDrugSituation:%@",strDate,bgResult,dinnerSituation,drugSituation];
        [dateFormatter release];
    }else if ([self.sourceTye isEqualToString:ActivityResult]){
        NSString *cal=[NSString stringWithFormat:@"%@",[detail objectForKey:@"Calories"]];
        NSString *DistanceTraveled=[NSString stringWithFormat:@"%.2f",[[detail objectForKey:@"DistanceTraveled"]floatValue]];
        NSString *Steps=[NSString stringWithFormat:@"%@",[detail objectForKey:@"Steps"]];
        cell.myLab.text=[NSString stringWithFormat:@"%@\nSteps: %@       Cal: %@ kcal\nDistanceTraveled: %@ km",strDate,Steps,cal,DistanceTraveled];
        [dateFormatter release];
    }else if ([self.sourceTye isEqualToString:SleepResult]){
        cell.myLab.font=[UIFont systemFontOfSize:15];
        NSString *dateStringS=[NSString stringWithFormat:@"%@",[detail objectForKey:@"StartTime"]];
        NSDate *dateS=[NSDate dateWithTimeIntervalSince1970:[dateStringS intValue]];
        NSString *strDateS=[dateFormatter stringFromDate:dateS];
        
        NSString *dateStringE=[NSString stringWithFormat:@"%@",[detail objectForKey:@"EndTime"]];
        NSDate *dateE=[NSDate dateWithTimeIntervalSince1970:[dateStringE intValue]];
        NSString *strDateE=[dateFormatter stringFromDate:dateE];
        
        
        NSString *Awake=[NSString stringWithFormat:@"%@",[detail objectForKey:@"Awaken"]];
        NSString *Fellasleep=[NSString stringWithFormat:@"%@",[detail objectForKey:@"FellSleep"]];
        NSString *Hoursslept=[NSString stringWithFormat:@"%@",[detail objectForKey:@"HoursSlept"]];
        NSString *SleepEfficiency=[NSString stringWithFormat:@"%@",[detail objectForKey:@"SleepEfficiency"]];
        cell.myLab.text=[NSString stringWithFormat:@"%@--%@\nAwakeTimes: %@             FellAsleep: %@ mins \nHourSlept: %@ mins SleepEfficiency: %@%%",strDateS,strDateE, Awake,Fellasleep,Hoursslept,SleepEfficiency];
        [dateFormatter release];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}
                                           
                                           
- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex==1) {
        [self nextPage];
    }
    else if (segmentedControl.selectedSegmentIndex==0) {
        [self prePage];
    }
}


#pragma mark - next page
-(void)nextPage
{
    if([self.nextPageUrl isEqualToString:@""]){
        self.nextAlert=[[UIAlertView alloc]initWithTitle:@"Next Page"
                                                 message:@"Already Next Page"
                                                delegate:self 
                                       cancelButtonTitle:@"OK" 
                                       otherButtonTitles:nil];
        [nextAlert show];
        [nextAlert release];
    }
    else if (self.nextPageUrl!=nil) {
        self.nextPageUrl=[self.nextPageUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:self.nextPageUrl];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
        connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        [request release];
    }
}

-(void)prePage
{
    if ((!self.prevPageUrl)||[self.prevPageUrl isEqualToString:@""]) {
        self.preAlert=[[UIAlertView alloc]initWithTitle:@"Previous Page"
                                                message:@"Already Previous Page"
                                               delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil];
        [preAlert show];
        [preAlert release];
    }
    else if (self.prevPageUrl!=nil) {
        self.prevPageUrl=[self.prevPageUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:self.prevPageUrl];
        NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
        connection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        [request release];
    }
}

-(void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response
{
    if (bpdata==nil) {
        bpdata=[[NSMutableData alloc]init];
    }
    
}
-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
    [bpdata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection 
{
	[self handleResponseData:bpdata];
    
	[bpdata release];
	bpdata = nil;
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
        NSLog(@"%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict=(NSDictionary *)result;
            if ([[dict objectForKey:@"ErrorDescription"]isEqual:@"is_not_authorized"]) {
                NSLog(@"您还为授权");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Request Error" 
                                                             message:@"Not Authorized" 
                                                            delegate:self
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles: nil];
                [alert show];
                [alert release];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                [sourceDataArray removeAllObjects];
                if ([self.sourceTye isEqualToString:BPResult]){
                   [sourceDataArray addObjectsFromArray:[dict objectForKey:@"BPDataList"]]; 
                }else if ([self.sourceTye isEqualToString:WeightResult]){
                   [sourceDataArray addObjectsFromArray:[dict objectForKey:@"WeightDataList"]];  
                }else if ([self.sourceTye isEqualToString:OXResult]){
                    [sourceDataArray addObjectsFromArray:[dict objectForKey:@"BODataList"]];
                }else if ([self.sourceTye isEqualToString:BGResult]){
                    [sourceDataArray addObjectsFromArray:[dict objectForKey:@"BGDataList"]];
                }else if ([self.sourceTye isEqualToString:ActivityResult]){
                    [sourceDataArray addObjectsFromArray:[dict objectForKey:@"ARDataList"]];
                }else if ([self.sourceTye isEqualToString:SleepResult]){
                    [sourceDataArray addObjectsFromArray:[dict objectForKey:@"SRDataList"]];
                }
                self.prevPageUrl=[dict objectForKey:@"PrevPageUrl"];
                self.nextPageUrl=[dict objectForKey:@"NextPageUrl"];
                NSLog(@"%@",nextPageUrl);
                [self sortSourceData];
                [self.tableView reloadData];
            }
        }
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
