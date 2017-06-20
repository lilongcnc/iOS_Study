//
//  PublicCellPresenter.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/14.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAPIManager.h"
@class BlogM;
@class PublicCellPresenter;

@protocol BlogCellPresenterCallbackDelegate <NSObject>

@optional
- (void)publicCellPresenterDidUpdateLikeState:(PublicCellPresenter *)presenter;
- (void)publicCellPresenterDidUpdateShareState:(PublicCellPresenter *)presenter;

@end

@interface PublicCellPresenter : NSObject

+ (instancetype)presenterWithBlog:(BlogM *)blogM;

- (BlogM *)blogM;


//cell 显示所需要的属性
- (BOOL)isLiked;
- (NSString *)blogTitleText;
- (NSString *)blogSummaryText;
- (NSString *)blogLikeCountText;
- (NSString *)blogShareCountText;


- (void)likeBlogWithCompletionHandler:(NetworkCompletionHandler)completionHandler;
- (void)shareBlogWithCompletionHandler:(NetworkCompletionHandler)completionHandler;


@property (nonatomic,assign) id<BlogCellPresenterCallbackDelegate> deleagte;

@end
