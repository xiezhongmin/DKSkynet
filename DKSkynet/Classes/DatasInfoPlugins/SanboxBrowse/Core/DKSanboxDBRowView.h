//
//  DKSanboxDBRowView.h
//  DKSkynet
//
//  Created by admin on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DKSanboxDBRowViewType) {
    DKSanboxDBRowViewTypeTitle = 0,
    DKSanboxDBRowViewTypeOne,
    DKSanboxDBRowViewTypeTwo
};

@class DKSanboxDBRowView;

@protocol DKSanboxDBRowViewDelegate <NSObject>

- (void)rowView:(DKSanboxDBRowView *)rowView didLabelTaped:(UILabel *)label;

@end

@interface DKSanboxDBRowView : UIView

@property(nonatomic, copy) NSArray *dataArray;

@property(nonatomic, assign) DKSanboxDBRowViewType type;

@property(nonatomic, weak) id <DKSanboxDBRowViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
