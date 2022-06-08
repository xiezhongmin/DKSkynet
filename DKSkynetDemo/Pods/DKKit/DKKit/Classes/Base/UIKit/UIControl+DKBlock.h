//
//  UIControl+DKBlock.h
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import <UIKit/UIKit.h>

@interface UIControl (DKBlock)

- (void)dk_addTouchDown:(void (^)(id sender))eventHandler;
- (void)dk_addTouchDownRepeat:(void (^)(id sender))eventHandler;
- (void)dk_addTouchDragInside:(void (^)(id sender))eventHandler;
- (void)dk_addTouchDragOutside:(void (^)(id sender))eventHandler;
- (void)dk_addTouchDragEnter:(void (^)(id sender))eventHandler;
- (void)dk_addTouchDragExit:(void (^)(id sender))eventHandler;
- (void)dk_addTouchUpInside:(void (^)(id sender))eventHandler;
- (void)dk_addTouchUpOutside:(void (^)(id sender))eventHandler;
- (void)dk_addTouchCancel:(void (^)(id sender))eventHandler;
- (void)dk_addValueChanged:(void (^)(id sender))eventHandler;
- (void)dk_addEditingDidBegin:(void (^)(id sender))eventHandler;
- (void)dk_addEditingChanged:(void (^)(id sender))eventHandler;
- (void)dk_addEditingDidEnd:(void (^)(id sender))eventHandler;
- (void)dk_addEditingDidEndOnExit:(void (^)(id sender))eventHandler;

- (void)dk_removeAllTargets;
- (void)dk_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents;
- (void)dk_setBlockForControlEvents:(UIControlEvents)controlEvents
                              block:(void (^)(id sender))block;

@end

