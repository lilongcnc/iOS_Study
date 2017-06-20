//
//  BlogHomeView.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "BlogHomeView.h"
#import "BlogPublicInfoViewController.h"
#import "BlogDraftInfoViewController.h"
#import "SVProgressHUD.h"
#import "UserInfoViewController.h"

#import "BlogDraftInfoViewController.h"

#import "DetailViewController.h"
#import "UIView+Extension.h"

@interface BlogHomeView ()<BlogPublicViewControllerCallBackDelegate>


@property (nonatomic,strong) BlogPublicInfoViewController *publicVC;
@property (nonatomic,strong) BlogDraftInfoViewController *draftVC;
@property (nonatomic,strong) UserInfoViewController *userInfoVC;

@property (strong, nonatomic) UIButton *blogButton;
@property (strong, nonatomic) UIButton *draftButton;
@property (strong, nonatomic) UIScrollView *scrollView;


@property (nonatomic,assign) NSUInteger userId;

@end

@implementation BlogHomeView

//初始化
+ (instancetype)instanceWithUserId:(NSUInteger)userId {
    return [[BlogHomeView alloc] initWiWithUserId:userId];
}

- (instancetype)initWiWithUserId:(NSUInteger)userId {
    if (self = [super init]) {
        self.userId = userId;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];


    [self configaution];
    
    [self addUI];
    
    [self fetchData];
}


- (void)configaution
{
    
    
    self.title = [NSString stringWithFormat:@"用户%ld", self.userId];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //顶部
    self.userInfoVC = [UserInfoViewController instanceWithUserID:self.userId];
    [self.userInfoVC setVCGenerator:^UIViewController *(id params) {
        return [DetailViewController new];
    }];
    [self addChildViewController:self.userInfoVC];//userInfo还是用的MVC 毕竟上面把block和protocol都交代过了
    
    //博客列表
    self.publicVC = [BlogPublicInfoViewController publicInfoViewControllerWithPresenter:[PublicInfoPresenter presenterWithUserId:self.userId]];
    self.publicVC.delegate = self; //BlogPublicInfoViewController中的 tableView 点击事件响应代理的方式
    
    //草稿列表
    self.draftVC = [BlogDraftInfoViewController blogDraftInfoViewController:[DraftInfoPresenter presenterWithUserId:self.userId]];
    //BlogDraftInfoViewController中的 tableView 点击事件响应是Block绑定方式
    __weak typeof(self) weakSelf = self;
    [self.draftVC setDidSelectedRowHandler:^(DraftM *draft) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.navigationController pushViewController:[DetailViewController new] animated:YES];
    }];
    
    
}


- (void)addUI
{
    
    //顶部信息区域
    CGFloat userInfoViewHeight = [UserInfoViewController viewHeight];
    self.userInfoVC.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, userInfoViewHeight);
    [self.view addSubview:self.userInfoVC.view];
    
    //切换按钮
    UIButton *(^makeButton)(NSString *title,CGRect frame) = ^(NSString *title,CGRect frame){
        
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button  setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(switchTableView:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };
    
    CGFloat switchButtonTop = self.userInfoVC.view.bottom;
    CGFloat switchButtonHeight = 40;
    [self.view addSubview:self.blogButton = makeButton(@"博客",CGRectMake(0, switchButtonTop, SCREEN_WIDTH * 0.5, switchButtonHeight))];
    [self.view addSubview:self.draftButton = makeButton(@"草稿", CGRectMake(SCREEN_WIDTH * 0.5, switchButtonTop, SCREEN_WIDTH * 0.5, switchButtonHeight))];
    self.blogButton.selected = YES;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect){0,self.blogButton.bottom,SCREEN_WIDTH,SCREEN_HEIGHT-self.blogButton.bottom}];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView = scrollView];
    
    
    self.publicVC.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, scrollView.height);
    [self.scrollView addSubview:self.publicVC.myTableView];
    
    self.draftVC.myTableView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.height);
    [self.scrollView addSubview:self.draftVC.myTableView];
    
}


- (void)switchTableView:(UIButton *)button
{
    if (button == self.blogButton) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        self.draftButton.selected = NO;
    }
    else
    {
        self.blogButton.selected = NO;
        [self.scrollView setContentOffset:(CGPoint){SCREEN_WIDTH,0} animated:YES];
    }
    
    
    button.selected = YES;

}




- (void)fetchData
{
    
    //首次加载数据
    [SVProgressHUD showWithStatus:@"加载"];
    
    //用户顶部信息加载首页数据
    [self.userInfoVC fetchUserInfoData];
    
    //对外发布信息加载首页数据
    [self.publicVC.myPresenter fetchPublicInfoNetData:^(NSError *error, id result) {
        [SVProgressHUD dismissWithDelay:0.5f];
    }];
    
    //草稿页加载首页数据
    [self.draftVC  fetchDataWithCompletionHandler:nil];
    
    
}





#pragma mark - BlogViewControllerCallBack

- (void)blogViewControllerdidSelectBlog:(BlogM *)blog {
    //这里实际应该把BlogM传入到目标控制器中
    [self.navigationController pushViewController:[DetailViewController new] animated:YES];
}
@end
