//
//  DZInputTextView.h
//  podsDome
//
//  Created by iMac on 2017/11/22.
//  Copyright © 2017年 ChenDongZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockTextValueDidChange)(NSString *textValue);

@interface DZInputTextView : UIView

@property(nonatomic, strong) IBInspectable NSString *placeholder;

@property(nonatomic, strong) IBInspectable UIColor  *placeholderColor;

@property (nonatomic, assign) IBInspectable float borderCornerRadius;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, retain) NSString *textValue;

///文本编辑过
@property (nonatomic, copy) BlockTextValueDidChange blockTextValueDidChange;

/**
 输入文字最大长度
 */
@property (nonatomic, assign) IBInspectable NSInteger textMaxLength;

@end
