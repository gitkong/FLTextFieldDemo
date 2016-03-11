//
//  FL_TextField.m
//  FLTextFieldDemo
//
//  Created by 孔凡列 on 16/3/11.
//  Copyright © 2016年 czebd. All rights reserved.
//

#import "FL_TextField.h"

typedef enum{
    DateTypeFromTimeStamp,
    DateTypeFromNow
}DateType;

@interface FL_TextField ()<UITextFieldDelegate>

@property (nonatomic,assign)NSInteger textLength;

@end

@implementation FL_TextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 默认
        self.fl_textFieldType = FL_TextFieldTypeDefault;
    }
    return self;
}

- (instancetype)initWithTextFieldType:(FL_TextFieldType)fl_textFieldType
                             tipBlock:(TipBlock)tipBlock
                          resultBlock:(ResultBlock)resultBlock{
    if (self = [super init]) {
        self.fl_textFieldType = fl_textFieldType;
        self.tipBlock = tipBlock;
        self.resultBlock = resultBlock;
    }
    return self;
}

+ (instancetype)fl_textFieldWithTextFieldType:(FL_TextFieldType)fl_textFieldType
                                     tipBlock:(TipBlock)tipBlock
                                  resultBlock:(ResultBlock)resultBlock{
    FL_TextField *fl_textField = [[FL_TextField alloc] init];
    fl_textField.fl_textFieldType = fl_textFieldType;
    fl_textField.tipBlock = tipBlock;
    fl_textField.resultBlock = resultBlock;
    return fl_textField;
}




- (void)birthdayImput:(UITextField *)textFiled{
    // 比较长度，判断是输入还是删除
    if (self.textLength > textFiled.text.length) {//删除
//        NSLog(@"删除");
        if (textFiled.text.length == 5) {
            textFiled.text = [textFiled.text substringToIndex:5];
        }
        else if (textFiled.text.length == 8){
            textFiled.text = [textFiled.text substringToIndex:8];
        }
    }
    else{// 输入
//        NSLog(@"输入");
        NSString *nowDateStr = [self getBirthdayByTimeStamp:720115200
                                                      style:DateTypeFromNow];
        
        if (textFiled.text.length >= 4 && textFiled.text.length < 6) {

            if ([textFiled.text integerValue] > [[nowDateStr substringToIndex:4] integerValue]) {

                textFiled.text = [textFiled.text substringToIndex:4];// 不能再输入了
                if (self.tipBlock) {
                    self.tipBlock(@"不能超过今年");
                }
            }
            else{
                textFiled.text = [textFiled.text stringByAppendingString:timeStrSeparate];
            }
            
        }
        else if (textFiled.text.length >= 7 && textFiled.text.length < 9){

            if ([[textFiled.text substringToIndex:4] integerValue] == [[nowDateStr substringToIndex:4] integerValue]) {
                // 与今年相同
                if ([[textFiled.text substringFromIndex:5] integerValue] > [[nowDateStr substringWithRange:NSMakeRange(5, 2)] integerValue]) {// 超过当前年的当前月
                    
                    // 注意：不能使用延时，否则会快速连续输入的时候会崩溃
                    textFiled.text = [textFiled.text substringToIndex:7];// 不能再输入了
                    
                    if (self.tipBlock) {
                        self.tipBlock(@"不能超过同年的月数");
                    }
                    
                    
                }
                else{// 不超过
                    textFiled.text = [textFiled.text stringByAppendingString:timeStrSeparate];
                }
            }
            else{// 不是今年
                if ([[textFiled.text substringFromIndex:5] integerValue] > 12) {// 超过12月
//                    NSLog(@"不能超过12月");
                    
                    textFiled.text = [textFiled.text substringToIndex:7];// 不能再输入了
                    
                    if (self.tipBlock) {
                        self.tipBlock(@"不能超过12月");
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                    });
                }
                else{
                    textFiled.text = [textFiled.text stringByAppendingString:timeStrSeparate];
                }
            }
            
        }
        else if (textFiled.text.length >= 10){
            if ([[textFiled.text substringFromIndex:5] integerValue] == [[nowDateStr substringWithRange:NSMakeRange(5, 2)] integerValue]) {// 同月
                // 不能超过同月的天数
                if ([[textFiled.text substringWithRange:NSMakeRange(8, 2)] integerValue] > [[nowDateStr substringWithRange:NSMakeRange(8, 2)] integerValue]) {//超过当前年的当前月的天数
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        textFiled.text = [textFiled.text substringToIndex:9];// 不能再输入了，帮你减一位
                    });
                    
                    if (self.tipBlock) {
                        self.tipBlock(@"不能超过同月的天数");
                    }
                    
                }
                else{// 不超过
                    textFiled.text = [textFiled.text substringToIndex:10];
                    // 输入完成，拿到最后的结果
                    if (self.resultBlock) {
                        self.resultBlock(textFiled.text);
                    }
                }
            }
            else{// 不同月
                // 拿到输入的年月日--转成时间戳
                textFiled.text = [textFiled.text substringToIndex:10];
                if ([[textFiled.text substringWithRange:NSMakeRange(8, 2)] integerValue] > [self getEveryMonthDaysTimeStr:textFiled.text]) {// 超过当前月的天数
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        textFiled.text = [textFiled.text substringToIndex:9];// 不能再输入了，帮你减一位
                    });
                    
                    if (self.tipBlock) {
                        self.tipBlock(@"不能超过当前月的天数");
                    }
                }
                else{// 不超过
                    textFiled.text = [textFiled.text substringToIndex:10];
                    // 输入完成，拿到最后的结果
                    if (self.resultBlock) {
                        self.resultBlock(textFiled.text);
                    }
                }
            }
        }
    }
    
    
    // 记录当前的textField的长度
    self.textLength = textFiled.text.length;
    
}

/**
 *  时间戳转成指定格式的时间字符串
 *
 *  @param timeStamp 时间戳
 *  @param dateType  日期格式,如果格式是DateTypeFromNow，那么时间戳传不传都一样
 */
- (NSString *)getBirthdayByTimeStamp:(NSInteger)timeStamp
                               style:(DateType)dateType{
    NSDate *confromTimesp = dateType == DateTypeFromTimeStamp ? [NSDate dateWithTimeIntervalSince1970:timeStamp]: [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeStrStyle];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [formatter setTimeZone:timeZone];
    return [formatter stringFromDate:confromTimesp];
}

/**
 *  返回指定格式的时间字符串中月份的天数
 *
 *  @param timeStr 指定格式的时间字符串
 *
 */
- (NSInteger)getEveryMonthDaysTimeStr:(NSString*)timeStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:timeStrStyle];
    
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    if (components != nil) {
        return [components day];  // 当前的号数
    }
    else{
        return 0;
    }
}

#pragma mark - setter & getter

- (void)setFl_textFieldType:(FL_TextFieldType)fl_textFieldType{
    _fl_textFieldType = fl_textFieldType;
    if (fl_textFieldType == FL_TextFieldTypeBirthday) {
        // 生日类型才监听
        [self addTarget:self action:@selector(birthdayImput:)
       forControlEvents:UIControlEventEditingChanged];
        
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
}

- (void)setTimeStamp:(long long)timeStamp{
    _timeStamp = timeStamp;
    if (self.fl_textFieldType == FL_TextFieldTypeBirthday) {
        self.text = [self getBirthdayByTimeStamp:timeStamp style:DateTypeFromTimeStamp];
        if (self.resultBlock) {
            self.resultBlock(self.text);
        }
    }
}

@end
