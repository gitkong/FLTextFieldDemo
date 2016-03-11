//
//  ViewController.m
//  FLTextFieldDemo
//
//  Created by 孔凡列 on 16/3/11.
//  Copyright © 2016年 czebd. All rights reserved.
//

#import "FLTextFieldViewController.h"
#import "FL_TextField.h"
#import "MBProgressHUD.h"
@interface FLTextFieldViewController ()

@end

@implementation FLTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 生日
    
    __weak typeof(self) weakSelf = self;
    FL_TextField *fl_textField = [FL_TextField fl_textFieldWithTextFieldType:FL_TextFieldTypeBirthday tipBlock:^(NSString *tipStr) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        hud.labelText = tipStr;
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        // YES代表需要蒙版效果
        hud.dimBackground = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    } resultBlock:^(NSString *result) {
        NSLog(@"result = %@",result);
    }] ;
    
    
    fl_textField.timeStamp = 721115300;
    fl_textField.frame = CGRectMake(100, 100, 200, 30);
    fl_textField.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:fl_textField];
    
    // 普通
    FL_TextField *textField = [[FL_TextField alloc] initWithFrame:CGRectMake(100, 200, 200, 30)];
    textField.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:textField];
}

- (void)HEHEH{
    NSLog(@"%s",__func__);
}



@end
