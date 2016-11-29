//
//  FETableViewController.m
//  FEFramework
//
//  Created by Tom on 15/1/20.
//  Copyright (c) 2015年 liyy. All rights reserved.
//

#import "FETableViewController.h"
#import "FESandbox.h"
#import "UIView+add.h"
#import "FEPrecompile.h"

@interface FETableViewController ()

@end

@implementation FETableViewController

+(instancetype)VC
{
    return [[[self class] alloc] init];
}

-(BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;
}

-(void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //>=7.0
    CGFloat y = 0;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.topOffset = 20;
        
        if (self.navigationController
            && !self.hideNavBar)
        {
            y += self.navigationController.navigationBar.frame.size.height;
            
            if ([self prefersStatusBarHidden] == NO)
            {
                y += 20;
            }
        }
    }
    else
    {
        self.topOffset = 0;
        if (self.hideStatusBar == NO)
        {
            y += 20;
        }
        
        if (self.navigationController
            && !self.hideNavBar)
        {
            y += self.navigationController.navigationBar.frame.size.height;
        }
    }
    
    CGFloat height = SCREEN_HEIGHT - y;
    if (self.tabBarController.tabBar
        && !(self.hidesBottomBarWhenPushed))
    {
        height -= self.tabBarController.tabBar.height;
    }
    
    self.view.frame = CGRectMake(0, y, SCREEN_WIDTH, height);
    
#ifdef DEBUG
    NSLog(@"VC:%@, frame:%@",  NSStringFromClass([self class]),  NSStringFromCGRect(self.view.frame));
#endif

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.hideNavBar animated:YES];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
#ifdef DEBUG
     NSLog(@"VC:%@ -- %@",  NSStringFromClass([self class]), @"didReceiveMemoryWarning");
#endif
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
    }
    
    return cell;
}


#pragma mark 持久化

-(NSString*)archivePath
{
    NSString* tmpPath = [[FESandbox tmpPath]stringByAppendingPathComponent:@"viewcache"];
    [FESandbox createDirectoryAtPath:tmpPath];
    
    NSString* keyPath = NSStringFromClass([self class]);
     tmpPath = [tmpPath stringByAppendingPathComponent:keyPath];
    
    return tmpPath;
}



-(void)archive:(id)data withKey:(NSString*)strKey
{
    NSString* strPath = [NSString stringWithFormat:@"%@_%@", [self archivePath], strKey];
    
    [NSKeyedArchiver archiveRootObject:data toFile:strPath];
}
-(id)unarchiveWithKey:(NSString*)strKey
{
    NSString* strPath = [NSString stringWithFormat:@"%@_%@", [self archivePath], strKey];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:strPath];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
