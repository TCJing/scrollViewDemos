//
//  OneViewController.m
//  scrollViewDemos
//
//  Created by 敬庭超 on 2017/3/12.
//  Copyright © 2017年 敬庭超. All rights reserved.
//

#import "OneViewController.h"
static CGFloat const headViewHeight = (270.0);
static CGFloat const picImageViewMaxWH = (100.0);
static CGFloat const picImageViewMaxCenterY = (150.0);
static CGFloat const picImageViewMinWH = (30.0);
static CGFloat const picImageViewMinCenterY = (42.0);

@interface OneViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property(nonatomic,weak) UIView *headView;
@property(nonatomic,weak) UIImageView  *picImgView;
@end

@implementation OneViewController
-(UIImageView *)picImgView{
    if (!_picImgView) {
        UIImageView *picImgView = [[UIImageView alloc] init];
        picImgView.contentMode = UIViewContentModeScaleAspectFill;
        picImgView.image = [UIImage imageNamed:@"IMG_0084"];
        [self.navBarView addSubview:picImgView];
        _picImgView = picImgView;
        //frame
        
        _picImgView.bounds = CGRectMake(0, 0 , picImageViewMaxWH, picImageViewMaxWH);
        _picImgView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, picImageViewMaxCenterY);
        _picImgView.layer.cornerRadius = picImageViewMaxWH * 0.5;
        _picImgView.layer.masksToBounds = YES;
        _picImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _picImgView.layer.borderWidth = 1;
    }
    return _picImgView;
}
-(UIView *)headView{
    if (!_headView) {
        UIView *headView = [[UIView alloc] init];
        [self.scrollView addSubview:headView];
        headView.backgroundColor = [UIColor redColor];
        _headView = headView;
        _headView.frame = CGRectMake(0, -headViewHeight, self.view.bounds.size.width, headViewHeight);
    }
    return _headView;
}
- (IBAction)back {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height + 1);
    self.scrollView.contentInset = UIEdgeInsetsMake(headViewHeight, 0, 0, 0);
    self.scrollView.contentOffset = CGPointMake(0, -headViewHeight);
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetY = scrollView.contentOffset.y;

    if (contentOffsetY <= -headViewHeight) {
        CGRect headViewFrame = self.headView.frame;
        headViewFrame.origin.y = contentOffsetY;
        headViewFrame.size.height = -1 * contentOffsetY;
        self.headView.frame = headViewFrame;
    }
    
    CGFloat updateY = contentOffsetY + headViewHeight;
    
    //  随着scrollview 的滚动， 改变bounds
    CGRect bound = self.picImgView.bounds;
    // 随着滚动缩减的头像的尺寸
    CGFloat reduceW = updateY  *(picImageViewMaxWH - picImageViewMinWH)/(headViewHeight - 64);
    // 宽度缩小的幅度要和headview偏移的幅度成比例，但是最小的宽度不能小于MinIconWH
    CGFloat yuanw =  MAX(picImageViewMinWH, picImageViewMaxWH - reduceW);
    self.picImgView.layer.cornerRadius = yuanw/2.0;
    bound.size.height = yuanw;
    bound.size.width  = yuanw;
    self.picImgView.bounds = bound;
    
    // 改变center  max - min 是滚动 center y值 最大的偏差
    CGPoint center = self.picImgView.center;
    CGFloat yuany =  MAX(picImageViewMinCenterY, picImageViewMaxCenterY - updateY * (picImageViewMaxCenterY - picImageViewMinCenterY)/(headViewHeight - 64) ) ;
    center.y = yuany;
    self.picImgView.center = center;
}

@end
