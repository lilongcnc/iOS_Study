//
//  BlogDraftInfoViewController.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DraftInfoPresenter.h"
@class DraftM;

@interface BlogDraftInfoViewController : NSObject

//初始化
+ (instancetype)blogDraftInfoViewController:(DraftInfoPresenter *)presenter;

-(UITableView *)myTableView;


//首次加载数据
- (void)fetchDataWithCompletionHandler:(NetworkCompletionHandler)completionHander;

//点击事件
- (void)setDidSelectedRowHandler:(void (^)(DraftM *))didSelectedRowHandler;

@end
