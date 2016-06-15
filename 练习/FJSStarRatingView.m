//
//  FJSStarRatingView.m
//  练习
//
//  Created by 付金诗 on 16/6/14.
//  Copyright © 2016年 www.fujinshi.com. All rights reserved.
//

#import "FJSStarRatingView.h"
#define START_IMAGE_DE @"StarEmpty"
#define START_IMAGE_SELE  @"StarFull"
#define START_COUNT 5 //星星数量

@interface FJSStarRatingView ()
@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;
@property (nonatomic,strong)NSMutableArray *deseleImageArray;
@property (nonatomic,strong)NSMutableArray *seleImageArray;
@end
@implementation FJSStarRatingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.score_max = 10.0;
        self.seleImageArray = [NSMutableArray array];
        self.deseleImageArray = [NSMutableArray array];
        _numberOfStar = START_COUNT;
        [self setupCustomousView];
    }
    return self;
}

- (void)setupCustomousView
{
    self.starBackgroundView = [UIView new];
    [self setupStarImageViewWithSuperView:self.starBackgroundView ImageName:START_IMAGE_DE];
    [self addSubview:self.starBackgroundView];
    
    [self.starBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    //设置底部无选中星星的位置,并且将父视图位置与齐相同.星星高度和宽度相同等同于父视图高度
    [self.deseleImageArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [self.deseleImageArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
    }];
    
    for (UIImageView * imageView in self.deseleImageArray) {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(imageView.mas_height);
        }];
    }
    
    self.starForegroundView = [UIView new];
    [self setupStarImageViewWithSuperView:self.starForegroundView ImageName:START_IMAGE_SELE];
    [self addSubview:self.starForegroundView];
    
    [self.starForegroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self setLayoutWithBottomView:self.starForegroundView];
}

#pragma mark -- 循环遍历设置每张图片的位置,之所以不使用mas_distributeViewsAlongAxis是因为想要设置每张图片的宽度和高度相同,并且利用了超出父视图就不会显示的原理
- (void)setLayoutWithBottomView:(UIView *)view
{
    NSMutableArray * array = self.seleImageArray;
    //终点在这里,这个思想,不要将这几个星星的右侧与底部视图右侧关联在一起,只要是利用了如果视图超出父视图,则不显示的原理来高效的进行评分设置.
    UIImageView *lastView;
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = array[i];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(view);
            if (lastView == nil) {
                make.left.equalTo(view);
                make.width.equalTo(imageView.mas_height);
            }else{
                make.left.equalTo(lastView.mas_right);
                make.width.equalTo(imageView.mas_height);
            }
        }];
        lastView = imageView;
    }
}



/**
 *  通过图片构建星星视图
 *
 *  @param imageName 图片名称
 *
 *  @return 星星视图
 */
- (void)setupStarImageViewWithSuperView:(UIView *)view ImageName:(NSString *)imageName
{
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [view addSubview:imageView];
        if ([imageName isEqualToString:START_IMAGE_SELE]) {
            [self.seleImageArray addObject:imageView];
        }else{
            [self.deseleImageArray addObject:imageView];
        }
    }
}

#pragma mark -- 设置评分
- (void)setScore:(CGFloat)score
{
    //如果赋值超出最大评分或者小于0 则对应处理
    if (score > self.score_max) {
        score = self.score_max;
    }else if(score < 0)
    {
        score = 0.f;
    }
    _score = score;
    //返回评分,外面使用
    if (self.starScore) {
        self.starScore(score);
    }
    NSLog(@"评分: %f",score);
    [self.starForegroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(self);
        if (score == 0) {
            make.width.equalTo(@0);
        }else{
            //将评分计算成比例 控制父视图的宽度,进而超出父视图部分就会无法显示,露出下面的未选中星星
            make.width.equalTo(self).multipliedBy(score / self.score_max);
        }
    }];
}

#pragma mark -
#pragma mark - Touche Event
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        //如果你移动的地方包含在内容中.则进行负值
        CGFloat scale = point.x / self.bounds.size.width;
        self.score = scale * self.score_max;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^
     {
         CGFloat scale = point.x / rect.size.width;
//         //对于这个处理我在赋值的时候已经进行了处理,所以可以省略
//         if (point.x < 0) {
//             scale = 0;
//         }
//         if (point.x > rect.size.width) {
//             scale = 1;
//         }
         weakSelf.score = scale * self.score_max;
     }];
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
