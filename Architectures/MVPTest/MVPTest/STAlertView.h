//
//  STAlertView.h
//  UIVisualEffectDemo
//
//  Created by ST on 17/3/3.
//  Copyright © 2017年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, STAlertAnimationOptions) {
    STAlertAnimationOptionNone            = 1 <<  0,
    STAlertAnimationOptionZoom            = 1 <<  1, // 先放大，再缩小，在还原
    STAlertAnimationOptionTopToCenter     = 1 <<  2, // 从上到中间
};

@protocol STAlertViewDelegate;
@class UILabel, UIButton, UIWindow;

@interface STAlertView : UIView


/**
 创建方式一,代理获取点击事件

 @param title <#title description#>
 @param message <#message description#>
 @param delegate <#delegate description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param otherButtonTitles <#otherButtonTitles description#>
 @return <#return value description#>
 */
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id <STAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

 
/**
 创建方式二,block点击回调

 @param title <#title description#>
 @param message <#message description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param otherButtonTitle <#otherButtonTitle description#>
 @param block <#block description#>
 */
+ (void)showWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitle:(nullable NSString *)otherButtonTitle clickButtonBlock:(void (^)(STAlertView *alertView, NSUInteger buttonIndex))block;


/**
 创建方式三,多个额外按钮,,设置弹出方式,block点击回调

 @param block <#block description#>
 @param animationOption <#animationOption description#>
 @param title <#title description#>
 @param message <#message description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param otherButtonTitles <#otherButtonTitles description#>
 */
+ (void)showAlertViewOnClickButtonBlock:(void (^)(STAlertView *alertView, NSUInteger buttonIndex))block showType:(STAlertAnimationOptions)animationOption title:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle  otherButtonTitle:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;



/**
 创建方式四, block点击回调,可改变alertView圆角

 @param block <#block description#>
 @param animationOption <#animationOption description#>
 @param radius <#radius description#>
 @param title <#title description#>
 @param message <#message description#>
 @param cancelButtonTitle <#cancelButtonTitle description#>
 @param otherButtonTitles <#otherButtonTitles description#>
 */
+ (void)showAlertViewOnClickButtonBlock:(void (^)(STAlertView *alertView, NSUInteger buttonIndex))block showType:(STAlertAnimationOptions)animationOption viewCornerRaius:(CGFloat)radius title:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle  otherButtonTitle:(nullable NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;



// shows popup alert animated.
- (void)show;
@property(nullable,nonatomic,weak)id <STAlertViewDelegate> delegate;
@property(nonatomic)STAlertAnimationOptions animationOption;
// background visual
@property(nonatomic, assign)BOOL visual;

@end




@protocol STAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(STAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
