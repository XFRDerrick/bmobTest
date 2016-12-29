//
//  EditUserInfoViewController.m
//  bmobOne
//
//  Created by universe on 2016/12/29.
//  Copyright © 2016年 universe. All rights reserved.
//

#import "EditUserInfoViewController.h"

@interface EditUserInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nicktextField;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.user objectForKey:@"nick"]) {
        self.nicktextField.text = [self.user objectForKey:@"nick"];
    }
}

- (IBAction)saveBtnAction:(UIButton *)sender {
     BmobUser *bUser = [BmobUser currentUser];
    
    if (self.nicktextField.text.length > 0 && ![self.nicktextField.text isEqualToString:[bUser objectForKey:@"nick"]]) {
        
        //添加或者更新
        [bUser setObject:self.nicktextField.text forKey:@"nick"];
        [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"保存成功");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                NSLog(@"error %@",[error description]);
            }
            
        }];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
