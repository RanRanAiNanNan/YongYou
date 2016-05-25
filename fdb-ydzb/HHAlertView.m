//
//  MrLoadingView.m
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "HHAlertView.h"


#define OKBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:158/255.0 green:214/255.0 blue:243/255.0 alpha:1]
#define CANCELBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:255/255.0 green:20/255.0 blue:20/255.0 alpha:1]


@interface HHAlertView()

@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray  *otherButtons;

@property (nonatomic, strong) UIView   *superView;          //parant view
@property (nonatomic, strong) UIView   *maskView;           //background view
@property (nonatomic, strong) UIView   *mainAlertView;      //main alert view

@property (nonatomic, strong) UILabel  *tipLabel;

@end


@implementation HHAlertView

#pragma mark Lifecycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.xOffset = 0.0;
        self.yOffset = 0.0;
        self.radius  = KDefaultRadius;
//        self.mode = HHAlertViewModeDefault;
        self.alpha   = 0.0;
        self.removeFromSuperViewOnHide = YES;
        
        [self registerKVC];
        
    }
    
    return self;
}


- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
                      addView:(UIView *)superView
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSArray *)otherButtonsTitles
{
    
    self = [self initWithFrame:superView.bounds];
    if (self) {
        self.superView = superView;
        self.titleText = title;
        self.detailText = detailtext;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonsTitles;
        [self layout];
        
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                   detailText:(NSString *)detailtext
                      addView:(UIView *)superView
                     tipText:(NSString *)tipText
{
    self = [self initWithFrame:superView.bounds];
    if (self) {
        self.superView = superView;
        self.titleText = title;
        self.detailText = detailtext;
        self.tipText = tipText;
        [self layout2];
        
    }
    return self;
}


#pragma mark UI

- (void)addView
{
    [self addSubview:self.maskView];
    [self addSubview:self.mainAlertView];
    [self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.detailLabel];
}

- (void)addView2
{
    [self addSubview:self.maskView];
    [self addSubview:self.mainAlertView];
    [self.mainAlertView addSubview:self.titleLabel];
    [self.mainAlertView addSubview:self.detailLabel];
    [self.mainAlertView addSubview:self.tipLabel];
}

- (void)updateModeStyle
{
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    for (UIButton *button in self.otherButtons) {
        [button setBackgroundColor:ERROR_COLOR];
    }
}

- (void)setupLabel
{
    //titleLabel frame
    self.titleLabel.frame = CGRectMake(0, 0, HHALERTVIEW_WIDTH, 44);
    [self.titleLabel setText:self.titleText];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithRed:190/255.0 green:158/255.0 blue:118/255.0 alpha:1];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:30/255.0 green:36/255.0 blue:50/255.0 alpha:1];
    
    //detailLabel frame
    [self.detailLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainAlertView.frame)-HHALERTVIEW_PADDING*4, 50)];
    CGPoint detailCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, CGRectGetHeight(self.detailLabel.frame)/2 + CGRectGetMaxY(self.titleLabel.frame));
    [self.detailLabel setCenter:detailCenter];
    [self.detailLabel setText:self.detailText];
    [self.detailLabel setTextColor:[UIColor colorWithRed:63/255.0 green:82/255.0 blue:102/255.0 alpha:1]];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    [self.detailLabel setFont:[UIFont systemFontOfSize:14]];
    [self.detailLabel setNumberOfLines:0];
}

- (void)setupLabel2
{
    //titleLabel frame
    self.titleLabel.frame = CGRectMake(0, 0, HHALERTVIEW_WIDTH, 44);
    [self.titleLabel setText:self.titleText];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor colorWithRed:190/255.0 green:158/255.0 blue:118/255.0 alpha:1];
    self.titleLabel.backgroundColor = [UIColor colorWithRed:30/255.0 green:36/255.0 blue:50/255.0 alpha:1];
    
    //detailLabel frame
    [self.detailLabel setFrame:CGRectMake(0, 0, CGRectGetWidth(self.mainAlertView.frame)-HHALERTVIEW_PADDING*3, 80)];
    CGPoint detailCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 5+CGRectGetHeight(self.detailLabel.frame)/2 + CGRectGetMaxY(self.titleLabel.frame));
    [self.detailLabel setCenter:detailCenter];
    [self.detailLabel setText:self.detailText];
    [self.detailLabel setTextColor:[UIColor colorWithRed:63/255.0 green:82/255.0 blue:102/255.0 alpha:1]];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    [self.detailLabel setFont:[UIFont systemFontOfSize:14]];
    [self.detailLabel setNumberOfLines:0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.detailText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.detailText length])];
    self.detailLabel.attributedText = attributedString;
    [self.detailLabel sizeToFit];
    
    //年化利率
    self.tipLabel.frame = CGRectMake(15, HHALERTVIEW_HEIGHT - 45, HHALERTVIEW_WIDTH - 30, 30);
    [self.tipLabel setText:self.tipText];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.textColor = [UIColor colorWithRed:190/255.0 green:158/255.0 blue:118/255.0 alpha:1];
    self.tipLabel.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    self.tipLabel.font = [UIFont systemFontOfSize:14];
}

- (void)setupButton
{
    if (self.cancelButtonTitle == nil && self.otherButtonTitles == nil) {
        NSAssert(NO, @"error");
    }
    
    if (self.cancelButtonTitle != nil) {
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        [self.cancelButton setTag:KbuttonTag];
        [self.cancelButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [[self.cancelButton layer] setCornerRadius:4.0];
        self.cancelButton.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1];
        [self.mainAlertView addSubview:self.cancelButton];
    }
    
    if (self.otherButtonTitles != nil) {
        NSMutableArray *tempButtonArray = [[NSMutableArray alloc] init];
        NSInteger i = 1;
        for (NSString *title in self.otherButtonTitles) {
            
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTag:KbuttonTag + i];
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            [[button layer] setCornerRadius:4.0];
            
            [tempButtonArray addObject:button];
            [self.mainAlertView addSubview:button];
            i++;
        }
        self.otherButtons = [tempButtonArray copy];
    }
}

- (void)setupButton2
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.mainAlertView.frame.size.width - 60, 0, 60, 20)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setBackgroundColor:[UIColor colorWithRed:30/255.0 green:36/255.0 blue:50/255.0 alpha:1]];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTag:KbuttonTag];
    [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainAlertView addSubview:button];
}

#pragma mark Layout

- (void)layout
{
    [self addView];
    [self setupLabel];
    [self setupButton];
    [self updateModeStyle];
    [self.superView addSubview:self];
}

- (void)layout2
{
    [self addView2];
    [self setupLabel2];
    [self setupButton2];
    [self.superView addSubview:self];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.mainAlertView setBackgroundColor:[UIColor whiteColor]];
    [[self.mainAlertView layer] setCornerRadius:self.radius];
    
    //titleLabel frame
    CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, 10);
    [self.titleLabel setCenter:titleCenter];
    
    if (self.cancelButtonTitle != nil && self.otherButtonTitles ==nil){
        CGRect buttonFrame = CGRectMake(0, 0, HHALERTVIEW_WIDTH - HHALERTVIEW_PADDING *2, 40);
        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint buttonCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, HHALERTVIEW_HEIGHT - HHALERTVIEW_PADDING - 20);
        [self.cancelButton setCenter:buttonCenter];
    }
    
    if (self.cancelButtonTitle != nil && [self.otherButtonTitles count]==1) {
        CGRect buttonFrame = CGRectMake(0, 0, (HHALERTVIEW_WIDTH - HHALERTVIEW_PADDING *3)/2.3, 40);
        [self.cancelButton setFrame:buttonFrame];
        
        CGPoint leftButtonCenter = CGPointMake(CGRectGetWidth(self.cancelButton.frame)/2 + HHALERTVIEW_PADDING, 130);
        [self.cancelButton setCenter:leftButtonCenter];
        
        UIButton *rightButton = (UIButton *)self.otherButtons[0];
        [rightButton setFrame:buttonFrame];
        
        CGPoint rightButtonCenter = CGPointMake(HHALERTVIEW_WIDTH - CGRectGetWidth(rightButton.frame)/2 - HHALERTVIEW_PADDING, 130);
        [rightButton setCenter:rightButtonCenter];
        
    }
    if (self.cancelButtonTitle == nil && [self.otherButtonTitles count]==1) {

        UIButton *rightButton = (UIButton *)self.otherButtons[0];
        CGRect buttonFrame = CGRectMake(0, 0, HHALERTVIEW_WIDTH - HHALERTVIEW_PADDING *2, 40);
        [rightButton setFrame:buttonFrame];
        
        CGPoint buttonCenter = CGPointMake(CGRectGetWidth(self.mainAlertView.frame)/2, HHALERTVIEW_HEIGHT - HHALERTVIEW_PADDING - 20);
        [rightButton setCenter:buttonCenter];
        
    }

}

#pragma mark Event Response

- (void)buttonTouch:(UIButton *)button
{
    if (self.completeBlock) {
        self.completeBlock(button.tag - KbuttonTag);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HHAlertView:didClickButtonAnIndex:)]) {
        [self.delegate HHAlertView:self didClickButtonAnIndex:button.tag - KbuttonTag];
    }
    
    [self hide];
}


#pragma mark show & hide 

- (void)show
{
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showWithBlock:(selectButtonIndexComplete)completeBlock
{
    self.completeBlock = completeBlock;
    [self show];
}

- (void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        if (self.removeFromSuperViewOnHide) {
            [self removeFromSuperview];
        }
        [self unregisterKVC];
    }];
    
}

#pragma mark KVC

- (void)registerKVC
{
    for (NSString *keypath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)unregisterKVC
{
    for (NSString *keypath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keypath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"mode",@"customView", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    }
    else{
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keypath
{
    if ([keypath isEqualToString:@"mode"] || [keypath isEqualToString:@"customView"]) {
        [self updateModeStyle];
    }
}

#pragma mark getter and setter

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MAXFLOAT)];
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [_maskView setAlpha:0.4];
    }
    return _maskView;
}

- (UIView *)mainAlertView
{
    if (!_mainAlertView) {
        _mainAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HHALERTVIEW_WIDTH, HHALERTVIEW_HEIGHT)];
        [_mainAlertView setCenter:CGPointMake(self.center.x, self.center.y - 40)];
    }
    return _mainAlertView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
    }
    return _detailLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
    }
    return _tipLabel;
}

@end
