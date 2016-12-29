//
//  UNUserInfoController.m
//  bmobOne
//
//  Created by universe on 2016/12/29.
//  Copyright © 2016年 universe. All rights reserved.
//

#import "UNUserInfoController.h"
#import "UserinfoHeaderCell.h"
#import "EditUserInfoViewController.h"

@interface UNUserInfoController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) BmobUser *user;
@property (nonatomic, strong) NSData *imageDate;

@property (nonatomic, strong) UIImage *headerImage;
@end

@implementation UNUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // self.clearsSelectionOnViewWillAppear = NO;

    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserinfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"userInfoCell"];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.title = @"个人信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editInfo)];
    
}
#pragma mark 编辑信息
- (void)editInfo{

    EditUserInfoViewController *edit = [[EditUserInfoViewController alloc] initWithNibName:@"EditUserInfoViewController" bundle:nil];
    edit.user = self.user;
    [self.navigationController pushViewController:edit animated:YES];
}
    
- (void)lookupInfo{
    //查询
    BmobUser *bUser = [BmobUser currentUser];
    if (bUser) {
        //进行操作
        self.user = bUser;
        
    }else{
        //对象为空时，可打开用户注册界面
        
        NSLog(@"未登录请先登录");
    }
    
   
    
}
#pragma mark -
- (void)viewWillAppear:(BOOL)animated{
    [self lookupInfo];
    [self.tableView reloadData];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    //         [self lookupInfo];
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //             [self.tableView reloadData];
    //        });
    //    });
    
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

    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    
    
    if (indexPath.row == 0) {
        UserinfoHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell" forIndexPath:indexPath];
        
        if (self.headerImage) {
            cell.headerImageIV.image = self.headerImage;
        }else{
            [cell.headerImageIV setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"头像"]];  
        }
        
        return cell;
        
    }
    if (indexPath.row == 1) {
        
        cell.textLabel.text = @"昵称";
        if ([self.user objectForKey:@"nick"]) {
            cell.detailTextLabel.text = [self.user objectForKey:@"nick"];
        }else{
            cell.detailTextLabel.text = self.user.username;
        }
    }
    if (indexPath.row == 2) {
       
        cell.detailTextLabel.text = @"点击注销";
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 0) {
        
        UIImagePickerController *imagselec = [[UIImagePickerController alloc] init];
        imagselec.delegate = self;
        [self presentViewController:imagselec animated:YES completion:nil];
    }
    if (indexPath.row == 2) {//注销用户
    
        [BmobUser logout];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *vc = [story instantiateInitialViewController];
        
        window.rootViewController = vc;
        
        [window makeKeyAndVisible];
        
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.headerImage = image;
    //上串图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
            BmobUser *user = [BmobUser currentUser];
            self.imageDate = UIImageJPEGRepresentation(image, .5);
            BmobFile *file = [[BmobFile alloc] initWithFileName:@"header.jpg" withFileData:self.imageDate];
        
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"头像上传成功");
                    //将上传的图片和用户关联
                    [user setObject:file.url forKey:@"headPath"];
                    NSLog(@"头像Path：%@",file.url);
                    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"头像用户信息关联成功");
                        }
                        
                    }];
                }
            }];
            
    });
    
     [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 66;
    }
    return 44;
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
