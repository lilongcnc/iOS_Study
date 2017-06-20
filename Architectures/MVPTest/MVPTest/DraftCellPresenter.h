//
//  DraftViewCellPresenter.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/19.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftM.h"
#import "UserAPIManager.h"

@interface DraftCellPresenter : NSObject

+ (instancetype)presenterWithDraft:(DraftM *)draft;

- (DraftM *)draft;

- (NSString *)draftEditDate;
- (NSString *)darftTitleText;
- (NSString *)draftSummaryText;


//请求后台删除数据
- (void)deleteDraftWithCompletionHandler:(NetworkCompletionHandler)completionHandler;

@end
