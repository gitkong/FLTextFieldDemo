//
//  FL_TextField.h
//  TextFiledBirthdayDemo
//
//  Created by 孔凡列 on 16/3/11.
//  Copyright © 2016年 czebd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define timeStrSeparate @"-"

#define timeStrStyle @"YYYY-MM-dd"// 2016-03-11

#define timeZoneName @"Asia/Beijing"

typedef enum{
    FL_TextFieldTypeBirthday,// 生日日期专用
    FL_TextFieldTypeDefault // 默认
}FL_TextFieldType;

typedef void(^TipBlock)(NSString *tipStr);

@interface FL_TextField : UITextField

@property (nonatomic,assign)FL_TextFieldType fl_textFieldType;// textField的类型

@property (nonatomic,copy)TipBlock tipBlock;//提示回调

+ (instancetype)fl_textFieldWithTextFieldType:(FL_TextFieldType)fl_textFieldType tipBlock:(TipBlock)tipBlock;

- (instancetype)initWithTextFieldType:(FL_TextFieldType)fl_textFieldType tipBlock:(TipBlock)tipBlock;

@end
