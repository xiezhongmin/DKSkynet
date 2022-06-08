//
//  UIView+Utils.h
//  yogo
//
//  Created by duke on 2020/5/22.
//  Copyright © 2020 LuBan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (DKUtils)

// nib create

+ (instancetype)dk_createNibView;

// hierarchy

- (UIViewController *)dk_firstViewController; // 所属的ViewController

- (UIView *)dk_firstResponder; // 第一响应者

// frame accessors

@property (nonatomic, assign)  CGFloat       left;        ///< Shortcut for frame.origin.x.
@property (nonatomic, assign)  CGFloat       top;         ///< Shortcut for frame.origin.y
@property (nonatomic, assign)  CGFloat       right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, assign)  CGFloat       bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, assign)  CGFloat       width;       ///< Shortcut for frame.size.width.
@property (nonatomic, assign)  CGFloat       height;      ///< Shortcut for frame.size.height.
@property (nonatomic, assign)  CGFloat       centerX;     ///< Shortcut for center.x
@property (nonatomic, assign)  CGFloat       centerY;     ///< Shortcut for center.y
@property (nonatomic, assign)  CGPoint       origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign)  CGSize        size;        ///< Shortcut for frame.size.

@end

