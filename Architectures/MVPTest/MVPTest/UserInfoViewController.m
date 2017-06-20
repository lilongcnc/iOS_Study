//
//  UserInfoViewController.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/15.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserM.h"

@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendCountLabel;

@property (nonatomic,assign) NSInteger userId;
@property (strong, nonatomic) UserM *userM;

@property (copy, nonatomic) ViewControllerGenerator VCGenerator;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



+(instancetype)instanceWithUserID:(NSInteger)userId
{
    UserInfoViewController *vc = [UserInfoViewController new];
    vc.userId = userId;
    return vc;
}



//接口
+(CGFloat)viewHeight
{
    return 160;
}

-(void)fetchUserInfoData
{
    [[UserAPIManager new] fetchUserInfoWithUserId:self.userId completionHandler:^(NSError *error, id result) {
        if (error) {
            //            ... show error view in userInfoView
        } else {
            
            UserM *user = self.userM = result;
            
            self.nameLabel.text = user.name;
            self.summaryLabel.text = [NSString stringWithFormat:@"个人简介: %@", user.summary];
            self.blogCountLabel.text = [NSString stringWithFormat:@"作品: %ld", user.blogCount];
            self.friendCountLabel.text = [NSString stringWithFormat:@"好友: %ld", user.friendCount];
            [self.iconButton setImage:[UIImage imageNamed:user.icon] forState:UIControlStateNormal];
        }
 
    }];
}


#pragma mark - Action

- (IBAction)onClickIconButton:(UIButton *)sender {
    
    if (self.VCGenerator) {
        
        UIViewController *targetVC = self.VCGenerator(self.userM);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}



@end
