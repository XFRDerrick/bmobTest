//
//  UNFrindsCirleController.m
//  bmobOne
//
//  Created by universe on 2016/12/29.
//  Copyright © 2016年 universe. All rights reserved.
//

#import "UNFrindsCirleController.h"

@interface UNFrindsCirleController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *sendImage;

@property (nonatomic, strong) NSData *imageData;

@end

@implementation UNFrindsCirleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发送";
    
}
- (IBAction)selectImages:(UIButton *)sender {
    
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageData = UIImageJPEGRepresentation(image, .5);
    self.sendImage.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)sendAction:(UIButton *)sender {
    
    BmobObject *obj = [BmobObject objectWithClassName:@"Message"];
    //记录消息的发送者
    [obj setObject:[BmobUser currentUser] forKey:@"user"];
    [obj setObject:self.wordTextField.text forKey:@"text"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //异步保存
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //判断是否有图
                NSLog(@"文字发送完成");
                if (self.imageData) {
                    BmobFile *file = [[BmobFile alloc] initWithFileName:@"a.jpg" withFileData:self.imageData];
                    
                    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                        [obj setObject:file.url forKey:@"imagePath"];
                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"图片发送完成");
                            }
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                }{
                    //没有图片直接发送
                    NSLog(@"无图文字发送完成");
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                
                NSLog(@"文字发送失败");
            }
            
        }];
    });
    
   
    
    
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
