//
//  DraftInfoPresenter.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAPIManager.h"
@class DraftCellPresenter;

@interface DraftInfoPresenter : NSObject

+(instancetype)presenterWithUserId:(NSInteger)userID;


- (NSArray<DraftCellPresenter *> *)allDatas;

- (void)refreshDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
- (void)loadMoreDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;
- (void)deleteDraftAtIndex:(NSUInteger)index completionHandler:(NetworkCompletionHandler)completionHander;


@end
