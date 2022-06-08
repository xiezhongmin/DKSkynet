//
//  UIControl+DKBlock.m
//  DKDebugerExample
//
//  Created by admin on 2021/10/27.
//

#import "UIControl+DKBlock.h"
@import ObjectiveC.runtime;

static const int block_key;

@interface _DKUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation _DKUIControlBlockTarget

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        _block = [block copy];
        _events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

@end


#define DK_UICONTROLBLOCK_METHOD(methodName, eventName) \
- (void)dk_##methodName:(void (^)(id sender))eventHandler { \
    [self _dk_addBlockForControlEvents:UIControlEvent##eventName block:eventHandler]; \
}

@implementation UIControl (DKBlock)

DK_UICONTROLBLOCK_METHOD(addTouchDown, TouchDown)
DK_UICONTROLBLOCK_METHOD(addTouchDownRepeat, TouchDownRepeat)
DK_UICONTROLBLOCK_METHOD(addTouchDragInside, TouchDragInside)
DK_UICONTROLBLOCK_METHOD(addTouchDragOutside, TouchDragOutside)
DK_UICONTROLBLOCK_METHOD(addTouchDragEnter, TouchDragEnter)
DK_UICONTROLBLOCK_METHOD(addTouchDragExit, TouchDragExit)
DK_UICONTROLBLOCK_METHOD(addTouchUpInside, TouchUpInside)
DK_UICONTROLBLOCK_METHOD(addTouchUpOutside, TouchUpOutside)
DK_UICONTROLBLOCK_METHOD(addTouchCancel, TouchCancel)
DK_UICONTROLBLOCK_METHOD(addValueChanged, ValueChanged)
DK_UICONTROLBLOCK_METHOD(addEditingDidBegin, EditingDidBegin)
DK_UICONTROLBLOCK_METHOD(addEditingChanged, EditingChanged)
DK_UICONTROLBLOCK_METHOD(addEditingDidEnd, EditingDidEnd)
DK_UICONTROLBLOCK_METHOD(addEditingDidEndOnExit, EditingDidEndOnExit)


- (void)dk_setBlockForControlEvents:(UIControlEvents)controlEvents
                              block:(void (^)(id sender))block
{
    [self dk_removeAllBlocksForControlEvents:UIControlEventAllEvents];
    [self _dk_addBlockForControlEvents:controlEvents block:block];
}

- (void)dk_removeAllTargets
{
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [[self _dk_allUIControlBlockTargets] removeAllObjects];
}

- (void)dk_removeAllBlocksForControlEvents:(UIControlEvents)controlEvents
{
    if (!controlEvents) return;
    
    NSMutableArray *targets = [self _dk_allUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    for (_DKUIControlBlockTarget *target in targets) {
        if (target.events & controlEvents) {
            UIControlEvents newEvent = target.events & (~controlEvents);
            if (newEvent) {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                target.events = newEvent;
                [self addTarget:target action:@selector(invoke:) forControlEvents:target.events];
            } else {
                [self removeTarget:target action:@selector(invoke:) forControlEvents:target.events];
                [removes addObject:target];
            }
        }
    }
    [targets removeObjectsInArray:removes];
}

- (void)_dk_addBlockForControlEvents:(UIControlEvents)controlEvents
                               block:(void (^)(id sender))block
{
    if (!controlEvents) return;
    _DKUIControlBlockTarget *target = [[_DKUIControlBlockTarget alloc]
                                       initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self _dk_allUIControlBlockTargets];
    [targets addObject:target];
}

- (NSMutableArray *)_dk_allUIControlBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets) {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}

@end
