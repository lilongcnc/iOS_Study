//
//  BlogPublicInfoViewController.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "BlogPublicInfoViewController.h"
#import "PublicViewCell.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "PublicCellPresenter.h"
#import "UserAPIManager.h"
#import "PublicCellPresenter.h"


@interface BlogPublicInfoViewController ()<UITableViewDelegate,UITableViewDataSource,PublicInfoPresenterDelegate>

@property (nonatomic,strong) UITableView *myTableView;

@property (nonatomic,strong) PublicInfoPresenter *myPresenter;


@end



@implementation BlogPublicInfoViewController


+ (instancetype)publicInfoViewControllerWithPresenter:(PublicInfoPresenter *)presenter
{
    return [[BlogPublicInfoViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(PublicInfoPresenter *)presenter
{
    
    if (self = [super init]) {
        
        self.myPresenter = presenter;
        self.myPresenter.delegate = self;
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        [self.myTableView registerNib:[UINib nibWithNibName:@"PublicViewCell" bundle:nil] forCellReuseIdentifier:CellID];
        
        __weak typeof(self) weakSelf = self;
        self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.myPresenter loadNewBNetData];
        }];
        
        self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf.myPresenter loadMoreNetData];
        }];
        
        
    }
    return self;
    
}


#pragma mark ================================== UITableViewDelegate && UITableViewDataSource ==================================
static NSString *const CellID = @"PublicViewCell";
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myPresenter.allDatas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PublicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    PublicCellPresenter *cellPresenter = self.myPresenter.allDatas[indexPath.row];;
    
    cell.presenter = cellPresenter;
    
    //喜欢按钮点击事件
    __weak typeof(cell) weakCell = cell;
    [cell setDidLikeHandler:^(){
        __strong typeof(weakCell) strongCell = weakCell;
        //执行点赞操作
        [strongCell.presenter  likeBlogWithCompletionHandler:^(NSError *error, id result) {
            !error?:[SVProgressHUD showErrorWithStatus:error.domain];
        }];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"LeftTableView 点击了 %zd-------%zd",indexPath.section,indexPath.row);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BOOL response = [self.delegate respondsToSelector:@selector(blogViewControllerdidSelectBlog:)];
    !response ? : [self.delegate blogViewControllerdidSelectBlog:self.myPresenter.allDatas[indexPath.row].blogM];
}


//-----------------------------------------------------------------------------------------------------------
#pragma mark PublicInfoPresenterDelegate
//-----------------------------------------------------------------------------------------------------------
//下拉刷新
- (void)publicInfoPresenter:(PublicInfoPresenter *)presenter didRefreshDataWithError:(NSError *)error result:(id)result
{
    [self.myTableView.mj_header endRefreshing];
    NSLog(@"publicVC 刷新: %@",result);

    if (!error) {
        [self.myTableView reloadData];
        [self.myTableView.mj_footer resetNoMoreData];
        
    } else if (self.myPresenter.allDatas.count == 0) {
        //        show error view
    }
}

//上拉加载更多
- (void)publicInfoPresenter:(PublicInfoPresenter *)presenter didLoadMoreDataWithError:(NSError *)error result:(id)result
{
    [self.myTableView.mj_footer endRefreshing];
    
    NSLog(@"publicVC 加载更多: %@",result);
    if (!error) {
        [self.myTableView reloadData];
    } else if (error.code == NetworkErrorNoMoreData) {
        
        [SVProgressHUD showErrorWithStatus:@"没有更多了"];
        [self.myTableView.mj_footer endRefreshingWithNoMoreData];
    }
    

}



#pragma mark ================================== 对外接口 ==================================


@end

