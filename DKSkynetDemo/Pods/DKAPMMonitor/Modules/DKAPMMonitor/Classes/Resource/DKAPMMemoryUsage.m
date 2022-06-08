//
//  DKAPMMemoryUsage.m
//  DKAPMMonitor
//
//  Created by admin on 2022/6/1.
//

#import "DKAPMMemoryUsage.h"
#import <mach/mach.h>
#import <mach/mach_types.h>
#import <pthread.h>
#import <os/proc.h>

#ifndef DK_NBYTE_PER_MB
#define DK_NBYTE_PER_MB (1024 * 1024.f)
#endif

@implementation DKAPMMemoryUsage

+ (double)currentUsage
{
    int64_t memoryFootprint = self.memoryFootprint;
    if (memoryFootprint) {
        return memoryFootprint / DK_NBYTE_PER_MB;
    }
    return self.memoryAppUsed / DK_NBYTE_PER_MB;
}

+ (int64_t)memoryAppUsed {
    struct task_basic_info info;
    mach_msg_type_number_t size = (sizeof(task_basic_info_data_t) / sizeof(natural_t));
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    if (kerr == KERN_SUCCESS) {
        return info.resident_size;
    } else {
        return 0;
    }
}

+ (int64_t)memoryFootprint {
    task_vm_info_data_t vmInfo;
    vmInfo.phys_footprint = 0;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t)&vmInfo, &count);
    if (result != KERN_SUCCESS)
        return 0;

    return vmInfo.phys_footprint;
}

@end
