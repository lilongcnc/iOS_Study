//
//  BlogPublicInfoViewController.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PublicInfoPresenter.h"
@class BlogM;

@protocol  BlogPublicViewControllerCallBackDelegate <NSObject>

- (void)blogViewControllerdidSelectBlog:(BlogM *)blog;

@end

@interface BlogPublicInfoViewController : NSObject

//初始化
+ (instancetype)publicInfoViewControllerWithPresenter:(PublicInfoPresenter *)presenter;


//对外开放的属性对象
-(UITableView *)myTableView;
-(PublicInfoPresenter *)myPresenter;



//代理
 @property (nonatomic,assign) id<BlogPublicViewControllerCallBackDelegate> delegate;




@end
