//
//  PublicInfoPresenter.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PublicInfoPresenter;
@class PublicCellPresenter;

typedef void (^FetchNetDataCompleteHandlerBlock)(NSError *error,id result);

@protocol PublicInfoPresenterDelegate <NSObject>

//下拉刷新
- (void)publicInfoPresenter:(PublicInfoPresenter *)presenter didRefreshDataWithError:(NSError *)error result:(id)result;

//上拉加载更多
- (void)publicInfoPresenter:(PublicInfoPresenter *)presenter didLoadMoreDataWithError:(NSError *)error result:(id)result;

@end


@interface PublicInfoPresenter : NSObject


//代理
@property (nonatomic,assign) id<PublicInfoPresenterDelegate> delegate;

//初始化方法
+ (instancetype)presenterWithUserId:(NSUInteger)userId;



/**
 只是第一次加载数据的时候使用
 */
- (void)fetchPublicInfoNetData:(FetchNetDataCompleteHandlerBlock)completeBlock;

- (void)loadNewBNetData;

- (void)loadMoreNetData;


- (NSArray<PublicCellPresenter *> *)allDatas;


@end


