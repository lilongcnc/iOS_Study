//
//  PublicCellPresenter.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/14.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "PublicCellPresenter.h"
#import "BlogM.h"

@interface PublicCellPresenter ()
@property (nonatomic,strong) BlogM *blogM;

@end

@implementation PublicCellPresenter


+(instancetype)presenterWithBlog:(BlogM *)blogM
{
    PublicCellPresenter *presenter = [PublicCellPresenter new];
    presenter.blogM = blogM;
    return presenter;
}




#pragma mark - Format

- (BOOL)isLiked {
    return self.blogM.isLiked;
}

- (NSString *)blogTitleText {
    return self.blogM.blogTitle.length > 0 ? self.self.blogM.blogTitle : @"未命名";
}

- (NSString *)blogSummaryText {
    return self.blogM.blogSummary.length > 0 ? [NSString stringWithFormat:@"摘要: %@", self.blogM.blogSummary] : @"这个人很懒, 什么也没有写...";
}

- (NSString *)blogLikeCountText {
    return [NSString stringWithFormat:@"赞 %ld", self.blogM.likeCount];
}

- (NSString *)blogShareCountText {
    return [NSString stringWithFormat:@"分享 %ld", self.blogM.shareCount];
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark 处理点赞和分享事件
//-----------------------------------------------------------------------------------------------------------
- (void)likeBlogWithCompletionHandler:(NetworkCompletionHandler)completionHandler
{
    if(self.blogM.isLiked)
    {
        !completionHandler ?: completionHandler([NSError errorWithDomain:@"你已经赞过了哦~" code:123 userInfo:nil], nil);
    }
    else
    {
        BOOL response = [self.deleagte respondsToSelector:@selector(publicCellPresenterDidUpdateLikeState:)];
        //本地显示点赞成功
        self.blogM.isLiked = YES;
        self.blogM.likeCount += 1;
        !response ?:[self.deleagte publicCellPresenterDidUpdateLikeState:self];
        
        //请求网络数据
        [[UserAPIManager new] likeBlogWithBlogId:self.blogM.blogId completionHandler:^(NSError *error, id result) {
            
            //如果网络请求失败,则本地点赞状态还原
            if (error) {
                self.blogM.isLiked = NO;
                self.blogM.likeCount -= 1;
                !response ? : [self.deleagte publicCellPresenterDidUpdateLikeState:self];
            }
            
            //点赞成功,回调
            !completionHandler ? : completionHandler(error,result);
        }];
    }
}

- (void)shareBlogWithCompletionHandler:(NetworkCompletionHandler)completionHandler
{
    
}



@end
