//
//  BlogViewCell.h
//  MVC
//
//  Created by 黑花白花 on 2017/3/11.
//  Copyright © 2017年 黑花白花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicCellPresenter.h"

@interface PublicViewCell : UITableViewCell

//数据驱动显示
@property (strong, nonatomic) PublicCellPresenter *presenter;

//喜欢按钮被点击
- (void)setDidLikeHandler:(void (^)())didLikeHandler;

@end
