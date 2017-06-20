//
//  PublicInfoPresenter.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "PublicInfoPresenter.h"
#import "PublicCellPresenter.h"
#import "UserAPIManager.h"
#import "BlogM.h"


@interface PublicInfoPresenter ()


@property (nonatomic,strong) NSMutableArray<PublicCellPresenter *> *myNetDataArray;
@property (nonatomic,strong) UserAPIManager *myAPIManager;
@property (nonatomic,assign) NSInteger userId;
@end



@implementation PublicInfoPresenter

//-----------------------------------------------------------------------------------------------------------
#pragma mark 初始化
//-----------------------------------------------------------------------------------------------------------
+(instancetype)presenterWithUserId:(NSUInteger)userId
{
    return [[PublicInfoPresenter alloc] initWithUserId:userId];
}

- (instancetype)initWithUserId:(NSUInteger)userId
{
    if (self = [super init]) { //方法名字必须是 init 开头
        
        self.myNetDataArray = [NSMutableArray arrayWithCapacity:10];
        //userID
        self.userId = userId;
        //网络请求类
        self.myAPIManager = [UserAPIManager new];
        
    }
    return self;
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark 对外接口
//-----------------------------------------------------------------------------------------------------------
-(NSArray<PublicCellPresenter *> *)allDatas
{
    return self.myNetDataArray;
}

//第一次获取数据
-(void)fetchPublicInfoNetData:(FetchNetDataCompleteHandlerBlock)completeBlock
{
    //模拟请求网络数据
    [self.myAPIManager refreshUserBlogsWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        
        if (!error) {
            
            [self.myNetDataArray removeAllObjects];
            //处理数据
            [self dealResultByFormat:result];
        }
        
        //执行代理方法
        BOOL response = [self.delegate respondsToSelector:@selector(publicInfoPresenter:didRefreshDataWithError:result:)];
        !response?: [self.delegate publicInfoPresenter:self didRefreshDataWithError:nil result:result];
        
        //返回操作成功的回调
        !completeBlock ? : completeBlock(error,result);
    }];
}

//刷新数据
- (void)loadNewBNetData
{
    [self fetchPublicInfoNetData:nil];
}

//加载更多数据
- (void)loadMoreNetData
{
    [self.myAPIManager loadModeUserBlogsWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        
        error ?: [self dealResultByFormat:result];
        
        if ([self.delegate respondsToSelector:@selector(publicInfoPresenter:didLoadMoreDataWithError:result:)]) {
            [self.delegate publicInfoPresenter:self didLoadMoreDataWithError:error result:result];
        }
    }];
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark Utils
//-----------------------------------------------------------------------------------------------------------
//处理请求数据
- (void)dealResultByFormat:(id)result
{
    for (BlogM *blog in result) {
        [self.myNetDataArray addObject:[PublicCellPresenter presenterWithBlog:blog]];
    }
}


@end
