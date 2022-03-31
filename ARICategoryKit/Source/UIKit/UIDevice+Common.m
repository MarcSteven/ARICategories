//
//  UIDevice+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "UIDevice+Common.h"

// system info need
#include <sys/sysctl.h>
#import <sys/mount.h>
#import <mach/mach_host.h>

// mac address need
#import <net/if.h>
#import <sys/socket.h>
#import <net/if_dl.h>

@implementation UIDevice (Common)

#pragma mark - private

+ (NSUInteger)getSystemInfo:(uint)typeSpecifier {
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark -

+ (NSUInteger)po_cpuFrequency {
    return [self getSystemInfo:HW_CPU_FREQ];
}

+ (NSUInteger)po_busFrequency {
    return [self getSystemInfo:HW_BUS_FREQ];
}

+ (NSUInteger)po_ramSize {
    return [self getSystemInfo:HW_MEMSIZE];
}

+ (NSUInteger)po_cpuNumber {
    return [self getSystemInfo:HW_NCPU];
}

+ (NSUInteger)po_totalMemory {
    return [self getSystemInfo:HW_PHYSMEM];
}

+ (NSUInteger)po_userMemory {
    return [self getSystemInfo:HW_USERMEM];
}

+ (NSUInteger)po_freeMemory {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

+ (long long)po_freeDiskSpace {
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

+ (long long)po_totalDiskSpace {
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

+ (NSString *)po_macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }
    
    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (NSString *)po_systemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)po_bundleShortVersionString {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)po_bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)po_bundleIdentifier {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString *)po_bundleDisplayName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

@end
