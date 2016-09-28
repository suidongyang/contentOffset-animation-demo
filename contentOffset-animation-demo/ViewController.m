//
//  ViewController.m
//  contentOffset-animation-demo
//
//  Created by SU on 16/7/31.
//  Copyright © 2016年 SU. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define AUTO_6_X  0.85333 * (kScreenWidth > 320.0 ? (kScreenWidth / 320.0) : 1.0)

#import "ViewController.h"
#import "UIHelper.h"

@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController {
    
    UIScrollView *_scrollView;
    UIImageView *_headView;
    UIView *_coverView; // 图片的蒙版
    UIView *_contentView;
    UILabel *_authorView;
    
    UIScrollView *_popScrollView;
    UIImageView *_popImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI {
    
    // 滚动视图
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _scrollView.contentSize = CGSizeMake(0, kScreenHeight+kScreenWidth);
    _scrollView.backgroundColor = [UIColor colorWithRed:0.989 green:0.970 blue:0.991 alpha:1.000];
    _scrollView.delegate = self;
    
    // 顶部图片
    _headView = [[UIImageView alloc] init];
    _headView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    _headView.image = [UIImage imageNamed:@"0500285fi.jpg"];
    _headView.contentMode = UIViewContentModeScaleAspectFill;
    // 图片蒙版
    _coverView = [[UIView alloc] initWithFrame: _headView.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0;
    [_headView addSubview: _coverView];
    // 手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(showPopImageView)];
    _headView.userInteractionEnabled = YES;
    [_headView addGestureRecognizer: tap];
    
    // 文字内容
    _contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, CGRectGetMaxY(_headView.frame), kScreenWidth, _scrollView.contentSize.height - _headView.height);
    _contentView.backgroundColor = [UIColor whiteColor];
    
    _contentView.layer.shadowOffset = CGSizeMake(0, -2);
    _contentView.layer.shadowRadius = 2;
    _contentView.layer.shadowOpacity = 0.2;
    
    // 底部标签
    _authorView = [[UILabel alloc] init];
    _authorView.font = [UIFont systemFontOfSize: 17*AUTO_6_X weight: UIFontWeightMedium];
    _authorView.textColor = [UIColor colorWithRed:0.868 green:0.676 blue:0.853 alpha:1.000];
    _authorView.text = @"Designed by SU";
    [_authorView sizeToFit];
    _authorView.centerX = 0.5 * _scrollView.width;
    _authorView.y = _scrollView.contentSize.height - 40*AUTO_6_X;
    
    [_scrollView addSubview: _headView];
    [_scrollView addSubview: _authorView];
    [_scrollView addSubview: _contentView];
    [self.view addSubview: _scrollView];
    
    [self setupContent];
}

- (void)showPopImageView {
    
    if (!_popImageView) {
        _popScrollView = [[UIScrollView alloc] init];
        _popScrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _popScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
        _popScrollView.maximumZoomScale = 4.0;
        _popScrollView.minimumZoomScale = 1.0;
        _popScrollView.delegate = self;
        
        _popImageView = [[UIImageView alloc] init];
        _popImageView.image = _headView.image;
        CGFloat scale = _headView.image.size.height / _headView.image.size.width;
        _popImageView.frame = CGRectMake(0, 0, kScreenWidth, scale * kScreenWidth);
        _popImageView.centerY = 0.5 * _popScrollView.height;
        _popImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_popScrollView addSubview: _popImageView];
        
        UIWindow *kWindow = [UIApplication sharedApplication].keyWindow;
        [kWindow addSubview: _popScrollView];
        
        // 手势
        UITapGestureRecognizer *tap_dismiss = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(dismissPopImageView)];
        [_popScrollView addGestureRecognizer: tap_dismiss];
        
        UITapGestureRecognizer *tap_scale = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(scalePopImage:)];
        tap_scale.numberOfTapsRequired = 2;
        [_popScrollView addGestureRecognizer: tap_scale];
        
        [tap_dismiss requireGestureRecognizerToFail: tap_scale];
    }
    _popScrollView.hidden = NO;
    
    [UIView animateWithDuration: 0.25 animations:^{
        _popScrollView.alpha = 1;
    }];
}

- (void)dismissPopImageView {
    
    [UIView animateWithDuration: 0.25 animations:^{
        [_popScrollView setZoomScale: 1.0];
        _popScrollView.alpha = 0;
    } completion:^(BOOL finished) {
        _popScrollView.hidden = YES;
    }];
}

- (void)setupContent {
    
    NSString *Marie_A = @"穿过大半个中国去睡你 其实，睡你和被你睡是差不多的，无非是 两具肉体碰撞的力，无非是这力催开的花朵 无非是这花朵虚拟出的春天让我们误以为生命被重新打开 大半个中国，什么都在发生：火山在喷，河流在枯 一些不被关心的政治犯和流民 一些在枪口的麋鹿和丹顶鹤 我是穿过枪林弹雨去睡你 我是把无数的黑夜摁进一个黎明去睡你 我是无数个我奔跑成一个我去睡你 当然我也会被一些蝴蝶带入歧途 把一些赞美当成春天 把一个和横店类似的村庄当成故乡 而它们 都是我去睡你必不可少的理由 --";
    
    NSArray *array = [Marie_A componentsSeparatedByString: @" "];
    
    for (NSString *str in array) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize: 17*AUTO_6_X weight: UIFontWeightThin];
        label.textColor = [UIColor colorWithRed:0.371 green:0.632 blue:0.885 alpha:1.000];
        label.numberOfLines = 0;
        label.width = _contentView.width - 30*AUTO_6_X;
        label.text = str;
        [label sizeToFit];
        label.x = 15*AUTO_6_X;
        
        [_contentView addSubview: label];
    }
    
    UILabel *titleLabel = _contentView.subviews[0];
    titleLabel.font = [UIFont systemFontOfSize: 23*AUTO_6_X];
    [titleLabel sizeToFit];
    titleLabel.width = kScreenWidth;
    titleLabel.y = 10*AUTO_6_X;
    
    _contentView.subviews[1].y = CGRectGetMaxY(titleLabel.frame) + 5*AUTO_6_X;
    
    for (int i = 2; i < _contentView.subviews.count; ++i) {
        
        _contentView.subviews[i].y = CGRectGetMaxY(_contentView.subviews[i-1].frame) + 13*AUTO_6_X;
    }
}

// 双击放大
- (void)scalePopImage: (UITapGestureRecognizer *)tapTap {
    
    CGFloat scale = 4.0;
    
    CGPoint tapPoint = [tapTap locationInView: self.view];
    
    if (_popScrollView.zoomScale <= 1.0) {
        
        [UIView animateWithDuration: 0.25 animations:^{
            
            [_popScrollView setZoomScale: scale];
            // 根据点击位置 tapPoint 调整 contentOffset，点哪里放大哪里
            [self popScrillViewResetContentOffset: tapPoint];
        }];
        
    }else {
        
        [UIView animateWithDuration: 0.25 animations:^{
            [_popScrollView setZoomScale: 1.0];
        }];
    }
}

// 根据点击位置调整 contentOffset，点哪里放大哪里，有误差
- (void)popScrillViewResetContentOffset: (CGPoint)tapPoint {
    
    CGFloat offsetY_ = _popScrollView.contentOffset.y;
    
    CGFloat x_radio = (tapPoint.x - 0.5 * kScreenWidth) / (0.5 * kScreenWidth);
    CGFloat y_radio = (tapPoint.y - 0.5 * kScreenHeight) / (0.5 * kScreenHeight);
    
    CGFloat x_offset = x_radio * (_popScrollView.contentSize.width - kScreenWidth);
    CGFloat y_offset = y_radio * (_popScrollView.contentSize.height - kScreenHeight);
    
    CGFloat offsetX = _popScrollView.contentOffset.x + x_offset;
    CGFloat offsetY = _popScrollView.contentOffset.y + y_offset;
    
    offsetX = offsetX < 0 ? 0 : offsetX;
    offsetY = offsetY < 0 ? 0 : offsetY;
    
    offsetX = (offsetX + kScreenWidth > _popScrollView.contentSize.width) ? (_popScrollView.contentSize.width - kScreenWidth) : offsetX;
    offsetY = (offsetY + kScreenHeight > _popScrollView.contentSize.height) ? (_popScrollView.contentSize.height - kScreenHeight) : offsetY;
    
    if (_popImageView.height > _popScrollView.height) {
        _popScrollView.contentOffset = CGPointMake(offsetX, offsetY);
    }else {
        // 解决双击放大图片缩放倍数小时图片不居中
        _popScrollView.contentOffset = CGPointMake(offsetX, offsetY_);
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    if (![scrollView isEqual: _popScrollView]) return;
    
    if (_popImageView.height > _popScrollView.height) {
        _popImageView.centerY = 0.5*_popScrollView.contentSize.height;
    }else {
        _popImageView.centerY = _popScrollView.centerY;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (![scrollView isEqual: _scrollView]) return;
    
    if (scrollView.contentOffset.y < 0) {
        
        CGFloat scale = (kScreenWidth + (-scrollView.contentOffset.y)) / kScreenWidth;
        
        _headView.transform = CGAffineTransformMakeScale(scale, scale);
        
        _headView.y = scrollView.contentOffset.y;
        
        _coverView.alpha = 0;
        
    }else if (scrollView.contentOffset.y < _headView.height) {
        
        _headView.y = scrollView.contentOffset.y * 0.25;
        _coverView.alpha = scrollView.contentOffset.y * 0.0015;
        
    }else if (scrollView.contentOffset.y < _headView.height + 77*AUTO_6_X) {
        
        _authorView.y = scrollView.contentSize.height - 47*AUTO_6_X + (scrollView.contentOffset.y - _headView.height);
        
    }else {
        
        _authorView.y = scrollView.contentSize.height + 30*AUTO_6_X;
    }
}

//// 监听 _popScrollView 的 contentSize，解决通过缩放手势放大图片时图片不居中的问题
//- (void)observePopScrollViewWithChange:(NSDictionary<NSString *,id> *)change {
//
//    if (_popImageView.height > _popScrollView.height) {
//        _popImageView.centerY = 0.5*_popScrollView.contentSize.height;
//    }else {
//        _popImageView.centerY = _popScrollView.centerY;
//    }
//}
//
//// 监听 ScrollView 的 contentOffset，实现视差滚动、透明度渐变、底部隐藏标签悬停
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//
//    if ([keyPath isEqual: @"contentSize"]) {
//        [self observePopScrollViewWithChange: change];
//        return;
//    }
//
//    CGFloat new = [change[@"new"] CGPointValue].y;
//    CGFloat old = [change[@"old"] CGPointValue].y;
//
//    if (_scrollView.contentOffset.y < 0) {
//
//        CGFloat scale = (kScreenWidth + (-_scrollView.contentOffset.y)) / kScreenWidth;
//
//        _headView.transform = CGAffineTransformMakeScale(scale, scale);
//
//        _headView.y = _scrollView.contentOffset.y;
//
//        _coverView.alpha = 0;
//
//    }else if (_scrollView.contentOffset.y < _headView.height) {
//
//        _headView.y += (new - old) * 0.3;
//        _coverView.alpha += (new - old) * 0.002;
//
//    }else if (_scrollView.contentOffset.y < _headView.height + 77*AUTO_6_X) {
//
//        _authorView.y = _scrollView.contentSize.height - 47*AUTO_6_X + (_scrollView.contentOffset.y - _headView.height);
//
//    }else {
//
//        _authorView.y = _scrollView.contentSize.height + 30*AUTO_6_X;
//    }
//}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _popImageView;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end