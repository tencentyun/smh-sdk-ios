//
//  QCloudSMHPriorityQueue.m
//  QCloudCOSSMH
//
//  Created by mochadu on 2025/12/01
//

#import "QCloudSMHPriorityQueue.h"

@interface QCloudSMHPriorityQueueItem ()

@end

@implementation QCloudSMHPriorityQueueItem

- (instancetype)initWithTaskId:(NSString *)taskId priority:(NSInteger)priority {
    self = [super init];
    if (self) {
        _taskId = [taskId copy];
        _priority = priority;
    }
    return self;
}

@end

@interface QCloudSMHPriorityQueue ()

@property (nonatomic, strong) NSMutableArray<QCloudSMHPriorityQueueItem *> *items;

@end

@implementation QCloudSMHPriorityQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        _items = [NSMutableArray array];
    }
    return self;
}

- (void)addTaskId:(NSString *)taskId withPriority:(NSInteger)priority {
    if (!taskId || taskId.length == 0) {
        return;
    }
    
    // 检查重复
    for (QCloudSMHPriorityQueueItem *item in self.items) {
        if ([item.taskId isEqualToString:taskId]) {
            return;  // 已存在，不重复添加
        }
    }
    
    QCloudSMHPriorityQueueItem *newItem = [[QCloudSMHPriorityQueueItem alloc] initWithTaskId:taskId
                                                                                     priority:priority];
    
    // 找到插入位置（按优先级降序排列）
    NSInteger insertIndex = self.items.count;  // 默认追加到末尾
    for (NSInteger i = 0; i < self.items.count; i++) {
        QCloudSMHPriorityQueueItem *item = self.items[i];
        if (newItem.priority > item.priority) {
            insertIndex = i;
            break;
        }
    }
    
    [self.items insertObject:newItem atIndex:insertIndex];
}

- (NSString * _Nullable)peek {
    if (self.items.count > 0) {
        return [self.items.firstObject.taskId copy];
    }
    return nil;
}

- (NSString * _Nullable)poll {
    if (self.items.count > 0) {
        QCloudSMHPriorityQueueItem *item = self.items.firstObject;
        NSString *taskId = [item.taskId copy];
        [self.items removeObjectAtIndex:0];
        return taskId;
    }
    return nil;
}

- (BOOL)removeTaskId:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return NO;
    }
    
    for (NSInteger i = 0; i < self.items.count; i++) {
        QCloudSMHPriorityQueueItem *item = self.items[i];
        if ([item.taskId isEqualToString:taskId]) {
            [self.items removeObjectAtIndex:i];
            return YES;
        }
    }
    return NO;
}

- (BOOL)containsTaskId:(NSString *)taskId {
    if (!taskId || taskId.length == 0) {
        return NO;
    }
    
    for (QCloudSMHPriorityQueueItem *item in self.items) {
        if ([item.taskId isEqualToString:taskId]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)count {
    return self.items.count;
}

- (BOOL)isEmpty {
    return self.items.count == 0;
}

- (void)clear {
    [self.items removeAllObjects];
}

- (NSArray<NSString *> *)allTaskIds {
    NSMutableArray<NSString *> *taskIds = [NSMutableArray array];
    for (QCloudSMHPriorityQueueItem *item in self.items) {
        [taskIds addObject:item.taskId];
    }
    return [taskIds copy];
}

@end
