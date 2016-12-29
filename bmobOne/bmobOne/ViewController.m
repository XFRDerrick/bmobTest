//
//  ViewController.m
//  bmobOne
//
//  Created by universe on 2016/12/29.
//  Copyright © 2016年 universe. All rights reserved.
//

#import "ViewController.h"

#import "UNHomeTableViewController.h"

@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *userName;
    @property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}
- (IBAction)loginAction:(UIButton *)sender {
    
    
    if (sender.tag == 0) {
        //登录
        
        [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.password.text block:^(BmobUser *user, NSError *error) {
            if (user) {
                NSLog(@"登录成功");
                UIWindow *window  = [UIApplication sharedApplication].keyWindow;
                
                UNHomeTableViewController *homeVC = [[UNHomeTableViewController alloc] initWithStyle:UITableViewStylePlain];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
                
                window.rootViewController = nav;
                [window makeKeyWindow];
                
            } else {
                NSLog(@"登录失败：%@",error);
            }
        }];
        
    }
    if (sender.tag == 1) {
        //注册
        
        BmobUser *bUser = [[BmobUser alloc] init];
        [bUser setUsername:self.userName.text];
        [bUser setPassword:self.password.text];
//        [bUser setObject:@18 forKey:@"age"];
        [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
            if (isSuccessful){
                NSLog(@"注册成功");
            } else {
                NSLog(@"注册失败：%@",error);
            }
        }];
    }
    
    
}
    
- (void)viewWillAppear:(BOOL)animated{

}
    

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //添加
    [self addinfo];
    //查询
//    [self lookupinfo];
    //修改
//    [self updatainfo];
    
    
}
    
- (void)updatainfo{

    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"f19da89a8e" block:^(BmobObject *object,NSError *error){
        //没有返回错误
        if (!error) {
            //对象存在
            if (object) {
                BmobObject *obj1 = [BmobObject objectWithoutDataWithClassName:object.className objectId:object.objectId];
                //设置cheatMode为YES
                [obj1 setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
                
                
                //异步更新数据
                [obj1 updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
}
    
- (void)lookupinfo{

    
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"GameScore"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:@"f19da89a8e" block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                NSString *playerName = [object objectForKey:@"playerName"];
                BOOL cheatMode = [[object objectForKey:@"cheatMode"] boolValue];
                NSLog(@"%@----%i",playerName,cheatMode);
            }
        }
    }];

}
    
- (void)addinfo{

    //往GameScore表添加一条playerName为小明，分数为78的数据
    BmobObject *gameScore = [BmobObject objectWithClassName:@"GameScore"];
    [gameScore setObject:@"小明" forKey:@"playerName"];
    [gameScore setObject:@78 forKey:@"score"];
    [gameScore setObject:[NSNumber numberWithBool:YES] forKey:@"cheatMode"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //进行操作
    }];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
