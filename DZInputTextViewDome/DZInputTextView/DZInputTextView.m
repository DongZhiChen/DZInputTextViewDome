//
//  DZInputTextView.m
//  podsDome
//
//  Created by iMac on 2017/11/22.
//  Copyright © 2017年 ChenDongZhi. All rights reserved.
//

#import "DZInputTextView.h"
#import <Masonry.h>

@interface DZInputTextView () <UITextViewDelegate>
@property (nonatomic) UITextView *TV_Content;
@property (nonatomic) UILabel *LB_TextLengthTitle;
@property (nonatomic) UILabel *LB_Placeholder;
@end

///输入的文字很框间距
static CGFloat speace = 7.0;

@implementation DZInputTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    _textMaxLength = 0;
    self.textValue = @"";
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.TV_Content];
    [_TV_Content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@(speace));
        make.right.bottom.equalTo(@(-speace));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEndEdit) name:UITextViewTextDidEndEditingNotification object:self.TV_Content];
}

///记录输入文字数量
- (void)recordInputCount {
    ///苹果系统键盘兼容
    self.LB_TextLengthTitle.text = [NSString stringWithFormat:@"%ld/%ld个字",self.textValue.length,self.textMaxLength];
}

- (void)textEndEdit {
    [self resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    ///判断键盘输入是否有mark (苹果键盘输入有mark)
    UITextRange *range = [self.TV_Content markedTextRange];
    UITextPosition *position = [self.TV_Content positionFromPosition:range.start offset:0];
    
    if (!position) {
        _textValue = self.TV_Content.text;
        [self recordInputCount];
        !self.blockTextValueDidChange ?: self.blockTextValueDidChange(self.textValue);
    }
    if (self.TV_Content.text.length == 0) {
        self.LB_Placeholder.hidden = NO;
    }else{
        self.LB_Placeholder.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (self.textMaxLength <= 0) {
        return YES;
    }
    
    if (range.length == 0) {
        ///苹果键盘输入时，length = 0
        UITextRange *range = [self.TV_Content markedTextRange];
        UITextPosition *position = [self.TV_Content positionFromPosition:range.start offset:0];
        ///确认输入
        if (!position) {
            ///输入文字超过限制的字数
            if ((_textValue.length+text.length) > self.textMaxLength) {
                return NO;
            }
        }
        
    }else {
        ///不是删除文字，添加文字时
        if (![text isEqualToString:@""]) {
            ///输入文字超过限制的字数
            if ((_textValue.length+text.length) > self.textMaxLength) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - setter getter
-(UILabel *)LB_Placeholder{
    if(_LB_Placeholder == nil){
        _LB_Placeholder = [[UILabel alloc] initWithFrame:CGRectMake(5, 2,200, 30)];
        _LB_Placeholder.numberOfLines = 0;
        _LB_Placeholder.font = self.TV_Content.font;
        _LB_Placeholder.textColor = [UIColor colorWithRed:128.0/255 green:128.0/255 blue:128.0/255 alpha:1];
    }
    return _LB_Placeholder;
}

- (UITextView *)TV_Content {
    if (_TV_Content == nil) {
        _TV_Content = [[UITextView alloc] init];
        _TV_Content.backgroundColor = [UIColor clearColor];
        _TV_Content.showsHorizontalScrollIndicator = NO;
        _TV_Content.showsVerticalScrollIndicator = NO;
        _TV_Content.textAlignment = NSTextAlignmentNatural;
        _TV_Content.font = [UIFont systemFontOfSize:15];
        _TV_Content.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        _TV_Content.delegate = self;
        [_TV_Content addSubview:self.LB_Placeholder];
    }
    return _TV_Content;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.LB_Placeholder.text = placeholder;
}

- (void)setTextValue:(NSString *)textValue {
    ///nil 转空字符串
    textValue = textValue ? textValue:@"";
    
    if (self.textMaxLength > 0) {
        if (textValue.length > self.textMaxLength) {
            textValue = [textValue substringToIndex:self.textMaxLength];
        }
        self.LB_TextLengthTitle.text = [NSString stringWithFormat:@"%ld/%ld个字",textValue.length,self.textMaxLength];
    }
    
    _textValue = textValue;
    self.TV_Content.text = textValue;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6;//行间距
    NSDictionary *attributes = @{ NSFontAttributeName:self.TV_Content.font, NSParagraphStyleAttributeName:paragraphStyle};
    self.TV_Content.attributedText = [[NSAttributedString alloc]initWithString:_textValue attributes:attributes];
    
    if (self.TV_Content.text.length == 0) {
        self.LB_Placeholder.hidden = NO;
    }else{
        self.LB_Placeholder.hidden = YES;
    }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.LB_Placeholder.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.LB_Placeholder.font = font;
    self.TV_Content.font = font;
}

- (UILabel *)LB_TextLengthTitle {
    if (!_LB_TextLengthTitle) {
        _LB_TextLengthTitle = [[UILabel alloc] init];
        _LB_TextLengthTitle.font = [UIFont systemFontOfSize:13];
        _LB_TextLengthTitle.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    }
    return _LB_TextLengthTitle;
}

- (void)setTextMaxLength:(NSInteger)textMaxLength {
    _textMaxLength = textMaxLength;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self addSubview:self.LB_TextLengthTitle];
    [self.LB_TextLengthTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.TV_Content.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.TV_Content.mas_bottom);
    }];
    
    if (_textMaxLength > 0) {
        if (self.textValue.length > _textMaxLength) {
            self.textValue = [self.textValue substringToIndex:_textMaxLength];
        }
        self.LB_TextLengthTitle.text = [NSString stringWithFormat:@"%ld/%ld个字",self.textValue.length,_textMaxLength];
    }
    
    ///输入内容偏移留底部输入数量标题
    self.TV_Content.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
}

#pragma mark -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
