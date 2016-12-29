//
//  UNHomeTableViewController.m
//  bmobOne
//
//  Created by universe on 2016/12/29.
//  Copyright © 2016年 universe. All rights reserved.
//

#import "UNHomeTableViewController.h"
#import <BmobSDK/BmobSDK.h>
#import "UNUserInfoController.h"

#import "UNFrindsCirleController.h"
@interface UNHomeTableViewController ()

@property (nonatomic, strong) NSArray *messages;

@end

@implementation UNHomeTableViewController

- (NSArray *)messages{

    if (!_messages) {
        _messages = [NSArray array];
    }
    return _messages;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"Message"];
        [query includeKey:@"user"];
        //查询结果
        [query orderByDescending:@"createdAt"];
        //排序后查询所有结果
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            self.messages = array;
            NSLog(@"数据获取成功-shuaxin");
            [self.tableView reloadData];
        }];
    });
    
   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupNav];
    
    
}
- (void)setupNav{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStyleDone target:self action:@selector(toMineVC)];
    
    self.navigationItem.leftBarButtonItem = item;
    
    self.navigationItem.title = @"首页";
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithTitle:@"朋友圈" style:UIBarButtonItemStyleDone target:self action:@selector(sendMessage)];
    
    self.navigationItem.rightBarButtonItem = itemRight;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor brownColor];
}

- (void)sendMessage{

    UNFrindsCirleController *fvc = [[UNFrindsCirleController alloc] initWithNibName:@"UNFrindsCirleController" bundle:nil];
    [self.navigationController pushViewController:fvc animated:YES];
}
    
- (void)toMineVC{

    UNUserInfoController *infoVC = [[UNUserInfoController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:infoVC animated:YES];

}
    
- (void)outLogin{
    
    [BmobUser logout];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *vc = [story instantiateInitialViewController];
    
    window.rootViewController = vc;
    
    [window makeKeyAndVisible];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BmobObject *messageObj = self.messages[indexPath.row];
        BmobUser *user = [messageObj objectForKey:@"user"];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[messageObj objectForKey:@"imagePath"]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.detailTextLabel.text = [user objectForKey:@"nick"];
            if (data) {
                   cell.imageView.image = [UIImage imageWithData:data];
            }
            cell.textLabel.text = [messageObj objectForKey:@"text"];
            
        });
    });
    
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 65;
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
