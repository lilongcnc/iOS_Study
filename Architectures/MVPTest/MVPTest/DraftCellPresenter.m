//
//  DraftViewCellPresenter.m
//  MVPTest
//
//  Created by 李龙 on 2017/6/19.
//  Copyright © 2017年 李龙. All rights reserved.
//

#import "DraftCellPresenter.h"
#import "DraftCellPresenter.h"



@interface DraftCellPresenter ()

@property (strong, nonatomic) DraftM *draft;

@end

@implementation DraftCellPresenter


+(instancetype)presenterWithDraft:(DraftM *)draft
{
    DraftCellPresenter *presenter = [DraftCellPresenter new];
    presenter.draft = draft;
    return presenter;
    
}


#pragma mark - Command

- (void)deleteDraftWithCompletionHandler:(NetworkCompletionHandler)completionHandler {
    [[UserAPIManager new] deleteDraftWithDraftId:self.draft.draftId completionHandler:completionHandler];
}


#pragma mark - Format

- (NSString *)draftEditDate {
    
    NSUInteger date = self.draft.editDate > 0 ? self.draft.editDate : [[NSDate date] timeIntervalSince1970];
    return [[NSDate dateWithTimeIntervalSince1970:date] description];
}

- (NSString *)darftTitleText {
    return self.draft.draftTitle.length > 0 ? self.draft.draftTitle : @"未命名";
}

- (NSString *)draftSummaryText {
    return self.draft.draftSummary.length > 0 ? [NSString stringWithFormat:@"摘要: %@", self.draft.draftSummary] : @"写点什么吧~";
}



@end
