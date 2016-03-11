//
//  FL_TextField.h
//  FLTextFieldDemo
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
typedef void(^ResultBlock)(NSString *result);

@interface FL_TextField : UITextField

@property (nonatomic,assign)FL_TextFieldType fl_textFieldType;// textField的类型

@property (nonatomic,copy)TipBlock tipBlock;//提示回调,外界可以弹窗提示
@property (nonatomic,copy)ResultBlock resultBlock;//结果回调

@property (nonatomic,assign)long long timeStamp;// 时间戳

+ (instancetype)fl_textFieldWithTextFieldType:(FL_TextFieldType)fl_textFieldType
                                     tipBlock:(TipBlock)tipBlock
                                  resultBlock:(ResultBlock)resultBlock;

- (instancetype)initWithTextFieldType:(FL_TextFieldType)fl_textFieldType
                             tipBlock:(TipBlock)tipBlock
                          resultBlock:(ResultBlock)resultBlock;

@end
