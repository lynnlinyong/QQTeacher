//
//  JSMessagesViewController.m
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

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"

#define INPUT_HEIGHT 40.0f

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>

- (void)setup;

@end



@implementation JSMessagesViewController

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
    CGRect tableFrame;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7)
    {
        if (iPhone5)
        {
            //ios7 iphone5
            CLog(@"It's is iphone5 IOS7");
            tableFrame = [UIView fitCGRect:CGRectMake(0.0f, 44.0f, size.width, 480-INPUT_HEIGHT-44-44)
                                isBackView:YES];
        }
        else
        {
            CLog(@"It's is iphone4 IOS7");
            //ios 7 iphone 4
            tableFrame = [UIView fitCGRect:CGRectMake(0.0f, 64.0f, size.width, 480-INPUT_HEIGHT-44-44-20)
                                isBackView:YES];
        }
    }
    else
    {
        if (!iPhone5)
        {
            // ios 6 iphone4
            CLog(@"It's is iphone4 IOS6");
            tableFrame = [UIView fitCGRect:CGRectMake(0.0f, 0, size.width, 480-INPUT_HEIGHT)
                                isBackView:YES];
        }
        else
        {
            //ios 6 iphone5
            CLog(@"It's is iphone5 IOS6");
            tableFrame = [UIView fitCGRect:CGRectMake(0.0f, 0, size.width, 480-INPUT_HEIGHT)
                                isBackView:YES];
        }
    }
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
	
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;

    UIButton *sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width-65.0f,
                                  8.0f, 49, 28);  //59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    
    UIButton *complainButton = [self complainButton];
    complainButton.tag       = 0;
    complainButton.frame     = CGRectMake(10, 2, 44.5, 40);
    [complainButton addTarget:self
                       action:@selector(doButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setComplainBtn:complainButton];
    
    UIButton *phoneButton    = [self phoneButton];
    phoneButton.tag          = 1;
    phoneButton.frame        = CGRectMake(55, 2, 44.5, 40);
    [phoneButton    addTarget:self
                       action:@selector(doButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setPhoneBtn:phoneButton];
    
    UIButton *voiceButton    = [self voiceButton];
    voiceButton.tag          = 2;
    voiceButton.frame        = CGRectMake(100, 2, 44.5, 40);
    [voiceButton    addTarget:self
                       action:@selector(doButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setVoiceBtn:voiceButton];
    
    UIButton *keyBoardButton = [self keyBoardButton];
    keyBoardButton.hidden    = YES;
    keyBoardButton.tag       = 3;
    keyBoardButton.frame     = CGRectMake(100, 8, 40, 26);
    [keyBoardButton    addTarget:self
                          action:@selector(doButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setKeyBoardBtn:keyBoardButton];
    
    UILongPressButton *recordButton = [self recordButton:CGRectMake(150, 8, 160, 26)];
    recordButton.hidden       = YES;
    recordButton.delegate     = self;
    [self.inputToolBarView setRecordBtn:recordButton];
    
    [self.view addSubview:self.inputToolBarView];
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (UIButton *)complainButton
{
    return [UIButton defaultComplainButton];
}

- (UIButton *)phoneButton
{
    return [UIButton defaultPhoneButton];
}

- (UIButton *)voiceButton
{
    return [UIButton defaultVoiceButton];
}

- (UIButton *)keyBoardButton
{
    return [UIButton defaultKeyBoardButton];
}

- (UILongPressButton *)recordButton:(CGRect) rect
{
    return [UIButton defaultLongPressButton:rect];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate   = nil;
    self.dataSource = nil;
    self.tableView  = nil;
    self.inputToolBarView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
#pragma mark -
- (void) doButtonPressed:(id)sender
{
    UIButton *btn = sender;
    
    switch (btn.tag)
    {
        case 2:    //录音
        {
            self.inputToolBarView.textView.hidden       = YES;
            self.inputToolBarView.sendButton.hidden     = YES;
            self.inputToolBarView.inputFieldBack.hidden = YES;
            self.inputToolBarView.voiceBtn.hidden       = YES;
            
            self.inputToolBarView.recordBtn.hidden      = NO;
            self.inputToolBarView.keyBoardBtn.hidden    = NO;
            break;
        }
        case 3:    //键盘
        {
            self.inputToolBarView.textView.hidden       = NO;
            self.inputToolBarView.sendButton.hidden     = NO;
            self.inputToolBarView.inputFieldBack.hidden = NO;
            self.inputToolBarView.voiceBtn.hidden       = NO;
            
            self.inputToolBarView.recordBtn.hidden      = YES;
            self.inputToolBarView.keyBoardBtn.hidden    = YES;
            break;
        }
        default:
            break;
    }
    
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(buttonPressed:)])
        {
            [self.delegate buttonPressed:sender];
        }
    }
}

- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    JSBubbleMessageCell *cell =  [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
            {
                if ([cell getAvatarStyle] == JSAvatarTxtIncomingImgOutgoing)
                {
                    [cell setAvatarText:[self.dataSource avatarNameForIncomingMessage]];
                }
                break;
            }
            case JSBubbleMessageTypeOutgoing:
            {
                if ([cell getAvatarStyle] == JSAvatarTxtIncomingImgOutgoing)
                {
                    [cell setWebAvatarImage:[self.dataSource avatarImagePathForOutgoingMessage]];
                    [cell setIdImageViewHidden:[self.dataSource isHaveOrg]];
                }
                break;
            }
        }
    }
    //判断消息类型
    if ([self.dataSource msgTypeForRowAtIndexPath:indexPath] == PUSH_TYPE_TEXT)
    {
        [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    }
    else
    {
        [cell setVoiceImage];
    }
    cell.tag = indexPath.row;
    [cell setBackgroundColor:tableView.backgroundColor];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate clickedMessageForRowAtIndexPath:indexPath];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                          timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                             avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]]+10;
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.inputToolBarView.textView resignFirstResponder];
    
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    CLog(@"rows:%d", rows);
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
//    CGFloat maxHeight = [JSMessageInputView maxHeight];
//    CGFloat textViewContentHeight = textView.contentSize.height;
//    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
//    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
//    
//    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
//        changeInHeight = 0;
//    }
//    else {
//        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
//    }
//    
//    if(changeInHeight != 0.0f) {
//        if(!isShrinking)
//            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
//        
//        [UIView animateWithDuration:0.25f
//                         animations:^{
//                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                    0.0f,
//                                                                    self.tableView.contentInset.bottom + changeInHeight,
//                                                                    0.0f);
//                             
//                             self.tableView.contentInset = insets;
//                             self.tableView.scrollIndicatorInsets = insets;
//                             [self scrollToBottomAnimated:NO];
//                             
//                             CGRect inputViewFrame = self.inputToolBarView.frame;
//                             self.inputToolBarView.frame = CGRectMake(0.0f,
//                                                                      inputViewFrame.origin.y - changeInHeight,
//                                                                      inputViewFrame.size.width,
//                                                                      inputViewFrame.size.height + changeInHeight);
//                         }
//                         completion:^(BOOL finished) {
//                             if(isShrinking)
//                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
//                         }];
//        
//        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
//    }
//    
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;

                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           inputViewFrameY,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputToolBarView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

@end