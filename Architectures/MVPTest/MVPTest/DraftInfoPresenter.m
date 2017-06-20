//
//  DraftInfoPresenter.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "DraftInfoPresenter.h"
#import "DraftCellPresenter.h"
#import "UserAPIManager.h"
#import "DraftM.h"


@interface DraftInfoPresenter ()

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,strong) NSMutableArray<DraftCellPresenter *> *myShowDataArray;
@property (nonatomic,strong) UserAPIManager *myAPIManager;
@end

@implementation DraftInfoPresenter


+(instancetype)presenterWithUserId:(NSInteger)userID
{

    DraftInfoPresenter *dInfoPresenter = [[DraftInfoPresenter alloc] initWithUserId:userID];
    return dInfoPresenter;
}

- (instancetype)initWithUserId:(NSInteger)userId
{
    if (self = [super init]) {
        
        self.userId = userId;
        self.myShowDataArray = [NSMutableArray arrayWithCapacity:5];
        self.myAPIManager = [UserAPIManager new];
    }
    return self;
}



#pragma mark -  处理请求数据

-(void)refreshDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{

     [self.myAPIManager refreshUserDraftsWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        
         if (!error) {
             [self.myShowDataArray removeAllObjects];
             [self formatResult:result];
         }
         
         //回调
         !completionHander? :completionHander(error,result);
     }];

}

-(void)loadMoreDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    [self.myAPIManager loadModeUserDraftsWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        
        if (!error) {
            [self formatResult:result];//格式化返回结果
        } else {
            //            如果API层面没有格式化好错误 那么在P层格式化错误
        }
        
        !completionHander ?: completionHander(error, result);
    }];
}


-(NSArray<DraftCellPresenter *> *)allDatas
{
    return self.myShowDataArray;
}



#pragma mark ================ 处理删除事件 ================
-(void)deleteDraftAtIndex:(NSUInteger)index completionHandler:(NetworkCompletionHandler)completionHander
{
    if (index >= self.myShowDataArray.count)
    {
        !completionHander ? : completionHander([NSError errorWithDomain:@"com.zyht.DraftCellDelegate" code:100 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"info",@"数组越界", nil]], nil);
    }
    else
    {
        //后台删除数据
        [self.myShowDataArray[index] deleteDraftWithCompletionHandler:^(NSError *error, id result) {
            
            NSLog(@"删除之前: %zd",self.myShowDataArray.count);
            //本地删除数据
            error ? : [self.myShowDataArray removeObjectAtIndex:index];
            
            NSLog(@"删除之后: %zd",self.myShowDataArray.count);
            //回掉
            !completionHander ? : completionHander(nil,result);
        }];
    }
}


#pragma mark - Utils

- (void)formatResult:(NSArray *)drafts {
    for (DraftM *draft in drafts) {
        [self.myShowDataArray addObject:[DraftCellPresenter presenterWithDraft:draft]];
    }
}

@end
