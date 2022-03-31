//
//  UIDevice+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Common)

/**
 返回当前设备的CPU频率
 */
+ (NSUInteger)po_cpuFrequency;

/**
 返回当前设备总线频率
 */
+ (NSUInteger)po_busFrequency;

/**
 当前设备内存大小
 */
+ (NSUInteger)po_ramSize;

/**
 返回当前设备的CPU数量
 */
+ (NSUInteger)po_cpuNumber;

/**
 返回当前设备总内存
 */
+ (NSUInteger)po_totalMemory;

/**
 返回当前设备非内核内存
 */
+ (NSUInteger)po_userMemory;

/**
 获取手机可用内存
 */
+ (NSUInteger)po_freeMemory;

/**
 获取手机硬盘空闲空间
 */
+ (long long)po_freeDiskSpace;

/**
 获取手机硬盘总空间
 */
+ (long long)po_totalDiskSpace;

/**
 获取设备mac地址
 */
+ (NSString *)po_macAddress;

/**
 获取iOS系统的版本号
 */
+ (NSString *)po_systemVersion;

/**
 获取当前项目版本信息
 */
+ (NSString *)po_bundleShortVersionString;

/**
 获取当前项目build版本
 */
+ (NSString *)po_bundleVersion;

/**
 获取当前项目BundleId
 */
+ (NSString *)po_bundleIdentifier;

/**
 获取当前项目名称
 */
+ (NSString *)po_bundleDisplayName;

@end

NS_ASSUME_NONNULL_END
