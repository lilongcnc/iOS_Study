//
//  UserInfoViewController.h
//  MVPTest
//
//  Created by 李龙 on 2017/6/15.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAPIManager.h"


@interface UserInfoViewController : UIViewController

//初始化
+ (instancetype)instanceWithUserID:(NSInteger)userId;

//接口
+ (CGFloat)viewHeight;


- (void)fetchUserInfoData;



-(void)setVCGenerator:(ViewControllerGenerator)VCGenerator;



@end
