//
//  FJSStarRatingView.h
//  练习
//
//  Created by 付金诗 on 16/6/14.
//  Copyright © 2016年 www.fujinshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FJSStarRatingView : UIView
@property (nonatomic,copy)void (^starScore)(CGFloat score);
@property (nonatomic, readonly) NSInteger numberOfStar;/**< 星星数量*/
@property (nonatomic,assign)CGFloat score;/**< 评分 */
@property (nonatomic,assign)CGFloat score_max;/**< 最大评分,默认为10.0f*/
@end
