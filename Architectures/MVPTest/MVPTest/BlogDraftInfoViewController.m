//
//  BlogDraftInfoViewController.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/13.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "BlogDraftInfoViewController.h"
#import "DraftViewCell.h"
#import "MJRefresh.h"
#import "DraftInfoPresenter.h"
#import "SVProgressHUD.h"
#import "STAlertView.h"

@interface BlogDraftInfoViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *myTableView;
@property (strong, nonatomic) DraftInfoPresenter *presenter;


@property (copy, nonatomic) void(^didSelectedRowHandler)(DraftM *); //这个写法


@end

@implementation BlogDraftInfoViewController




+ (instancetype)blogDraftInfoViewController:(DraftInfoPresenter *)presenter
{
    BlogDraftInfoViewController *blog = [[BlogDraftInfoViewController alloc] initWithPresenter:presenter];
    
    return blog;
}


- (instancetype)initWithPresenter:(DraftInfoPresenter *)presenter
{
    if (self = [super init]) {
        
        self.presenter = presenter;
        
        self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
        
        [self.myTableView registerNib:[UINib nibWithNibName:@"DraftViewCell" bundle:nil] forCellReuseIdentifier:flag];
        
        //数据数据刷新
        __weak  typeof(self) weakSelf = self;
        self.myTableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.presenter refreshDataWithCompletionHandler:^(NSError *error, id result) {
                [strongSelf.myTableView.mj_header endRefreshing];

                if (!error) {
                    [strongSelf.myTableView reloadData];
                    [strongSelf.myTableView.mj_footer resetNoMoreData]; //恢复还可以上拉刷新的状态
                }
            
            }];
        }];
        
        
        self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.presenter loadMoreDataWithCompletionHandler:^(NSError *error, id result) {
                [strongSelf.myTableView.mj_footer endRefreshing];

                NSLog(@"draftVC 加载更多: %@",result);
                if (!error) {
                    [strongSelf.myTableView reloadData];
                }
                else if (error.code == NetworkErrorNoMoreData)
                {
                    [SVProgressHUD showErrorWithStatus:error.domain];
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData]; //上拉时候提示数据已经没有了
                }
                
            }];
            
        }];
        
    }
    return self;
}

#pragma mark UITableViewDataSource
static CGFloat const RowHeight = 44.f;
static NSString *const flag = @"DraftViewCell";
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.presenter.allDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DraftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flag];
    cell.presenter = self.presenter.allDatas[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    !self.didSelectedRowHandler ? : self.didSelectedRowHandler(self.presenter.allDatas[indexPath.row].draft);
}


//左滑操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        /*
        [self.myTableView showAlertWithTitle:@"提示" message:@"确定删除这份草稿?" confirmHandler:^(UIAlertAction *confirmAction) {
            
            [self.myTableView showHUD];//因为现在M归P管, 任何涉及到到M层变动的操作都必须经过P层
            [self.presenter deleteDraftAtIndex:indexPath.row completionHandler:^(NSError *error, id result) {
                [self.myTableView hideHUD];
                
                error ? [self.tableView showToastWithText:error.domain] : [self.tableView reloadData];
            }];
        }];
         */
        
        __weak  typeof(self) weakSelf = self;
        [STAlertView showWithTitle:@"提示" message:@"确定要删除这份草稿?" cancelButtonTitle:@"取消" otherButtonTitle:@"确定" clickButtonBlock:^(STAlertView * _Nonnull alertView, NSUInteger buttonIndex) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (buttonIndex) {
                [SVProgressHUD show];//因为现在M归P管, 任何涉及到到M层变动的操作都必须经过P层
                [self.presenter deleteDraftAtIndex:indexPath.row completionHandler:^(NSError *error, id result) {
                    [SVProgressHUD dismiss];
                    
                    error ? [SVProgressHUD showErrorWithStatus:error.domain] : [strongSelf.myTableView reloadData];
                }];

            }
        }];
        
    }
}


#pragma mark ================================== 对外接口 ==================================
- (void)fetchDataWithCompletionHandler:(NetworkCompletionHandler)completionHander
{
    [self.presenter refreshDataWithCompletionHandler:^(NSError *error, id result) {
        
        if (!error) {
            [self.myTableView reloadData];
        } else {
            //        show error view
        }
        !completionHander ?: completionHander(error, result);
    }];


}

@end
