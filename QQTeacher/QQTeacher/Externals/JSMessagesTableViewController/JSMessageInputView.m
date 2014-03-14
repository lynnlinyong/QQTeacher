//
//  JSMessageInputView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessageInputView.h"
#import "JSBubbleView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"

#define SEND_BUTTON_WIDTH 78.0f
#define SEND_TEXT_WIDTH   100.f
@interface JSMessageInputView ()

- (void)setup;
- (void)setupTextView;

@end

@implementation JSMessageInputView
@synthesize complainBtn;
@synthesize phoneBtn;
@synthesize voiceBtn;
@synthesize keyBoardBtn;
@synthesize sendButton;
@synthesize recordBtn;
@synthesize inputFieldBack;

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame
           delegate:(id<UITextViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        self.textView.delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    self.inputFieldBack = nil;
    self.textView       = nil;
    self.sendButton     = nil;
    [super dealloc];
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark - Setup
- (void)setup
{
    self.image = [UIImage inputBar];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    [self setupTextView];
}

- (void)setupTextView
{
    CGFloat width = self.frame.size.width-SEND_BUTTON_WIDTH-SEND_TEXT_WIDTH;
    CGFloat height = [JSMessageInputView textViewLineHeight];
    
    self.textView = [[JSDismissiveTextView  alloc] initWithFrame:CGRectMake(width+13.0f, 8, SEND_TEXT_WIDTH, height-2)];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
    self.textView.contentInset = UIEdgeInsetsMake(-4.0f, 4.0f, 0.0f, 0.0f);
    self.textView.scrollEnabled = YES;
    self.textView.scrollsToTop = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.font = [JSBubbleView font];
    self.textView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.textView.layer.shadowOffset = CGSizeMake(1, 1);
    self.textView.textColor = [UIColor blackColor];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.textView.keyboardType = UIKeyboardTypeDefault;
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.textView.layer.borderWidth = 1.f;
    self.textView.layer.cornerRadius = 0.0f;
    [self.textView.layer setMasksToBounds:YES];

    
//    self.textView = [[UITextView  alloc] initWithFrame:CGRectMake(width+13.0f, 8, SEND_TEXT_WIDTH, height-2)];
//    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.textView.backgroundColor = [UIColor whiteColor];
//    self.textView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0f, 0.0f, 10.0f, 8.0f);
//    self.textView.contentInset  = UIEdgeInsetsMake(-4.0f, 4.0f, 0.0f, 0.0f);
//    self.textView.scrollEnabled = YES;
//    self.textView.scrollsToTop  = NO;
//    self.textView.userInteractionEnabled = YES;
//    self.textView.font = [JSBubbleView font];
//    self.textView.layer.shadowColor = [[UIColor grayColor] CGColor];
//    self.textView.layer.shadowOffset = CGSizeMake(1, 1);
//    self.textView.textColor = [UIColor blackColor];
//    self.textView.backgroundColor = [UIColor whiteColor];
//    self.textView.keyboardAppearance = UIKeyboardAppearanceDefault;
//    self.textView.keyboardType = UIKeyboardTypeDefault;
//    self.textView.returnKeyType = UIReturnKeyDefault;
//    self.textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
//    
//    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
//    
//    self.textView.layer.borderWidth = 1.f;
//    
//    self.textView.layer.cornerRadius = 1.0f;
//    
//    [self.textView.layer setMasksToBounds:YES];

    [self addSubview:self.textView];
	
    inputFieldBack = [[UIImageView alloc] initWithFrame:CGRectMake(self.textView.frame.origin.x - 1.0f,
                                                                                0.0f,
                                                                                self.textView.frame.size.width + 2.0f,
                                                                                self.frame.size.height)];
//  inputFieldBack.image = [UIImage inputField];
    inputFieldBack.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    inputFieldBack.layer.shadowColor = [[UIColor grayColor] CGColor];
    inputFieldBack.layer.shadowOffset = CGSizeMake(1, 1);
    inputFieldBack.backgroundColor = [UIColor clearColor];
    [self addSubview:inputFieldBack];
}

#pragma mark - Setters
- (void)setSendButton:(UIButton *)btn
{
    if (sendButton)
        [sendButton removeFromSuperview];
    
    sendButton = btn;
    [self addSubview:self.sendButton];
}

- (void) setComplainBtn:(UIButton *)btn
{
    if (complainBtn)
        [complainBtn removeFromSuperview];
    
    complainBtn = btn;
    [self addSubview:self.complainBtn];
}

- (void) setPhoneBtn:(UIButton *)btn
{
    if (phoneBtn)
        [phoneBtn removeFromSuperview];
    
    phoneBtn = btn;
    [self addSubview:self.phoneBtn];
}

- (void) setVoiceBtn:(UIButton *)btn
{
    if (voiceBtn)
        [voiceBtn removeFromSuperview];

    voiceBtn = btn;
    [self addSubview:self.voiceBtn];
}

- (void) setKeyBoardBtn:(UIButton *)btn
{
    if (keyBoardBtn)
        [keyBoardBtn removeFromSuperview];
    
    keyBoardBtn = btn;
    [self addSubview:self.keyBoardBtn];
}

- (void) setRecordBtn:(UILongPressButton *)btn
{
    if (recordBtn)
        [recordBtn removeFromSuperview];
    
    recordBtn = btn;
    [self addSubview:self.recordBtn];
}

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.textView.frame;
    
    int numLines = MAX([JSBubbleView numberOfLinesForMessage:self.textView.text],
                       [self.textView.text numberOfLines]);
    
    self.textView.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 8.0f : -4.0f),
                                                  4.0f,
                                                  (numLines >= 6 ? 8.0f : 0.0f),
                                                  0.0f);
    
    self.textView.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 30.0f; // for fontSize 15.0f
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([JSMessageInputView maxLines] + 1.0f) * [JSMessageInputView textViewLineHeight];
}

@end