//
//  NSFileManager+Common.h
//
//  Created by Marc Steven on 2020/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  目录类型
 */
typedef NS_ENUM(NSInteger, DirectoryType) {
    
    DirectoryTypeMainBundle = 0,
    DirectoryTypeLibrary,
    DirectoryTypeDocuments,
    DirectoryTypeCache
};

@interface NSFileManager (Common)

/**
 获取 URL of Documents 目录.
 */
+ (NSURL *)po_documentsURL;

/**
 获取 path of Documents 目录.
 */
+ (NSString *)po_documentsPath;

/**
 获取 URL of Library 目录.
 */
+ (NSURL *)po_libraryURL;

/**
 获取 path of Library 目录.
 */
+ (NSString *)po_libraryPath;

/**
 获取 URL of Caches 目录.
 */
+ (NSURL *)po_cachesURL;

/**
 获取 path of Caches 目录.
 */
+ (NSString *)po_cachesPath;

#pragma mark -

/**
 *  读取一个文件一个返回的内容作为NSString
 *
 *  @param file 文件名
 *  @param type 文件类型
 */
+ (NSString *)po_readTextFile:(NSString *)file
                       ofType:(NSString *)type;

/**
 *  保存一个给定数组 到 Plist给定的文件名
 *
 *  @param directory 目录类型
 *  @param fileName  Plist文件名
 *  @param array     Array数据
 */
+ (BOOL)po_savePlistArrayToDirectory:(DirectoryType)directory
                        withFileName:(NSString *)fileName
                               array:(NSArray *)array;

/**
 *  用给定的文件名加载Plist数组
 *
 *  @param directory 文件类型
 *  @param fileName  Plist文件名
 */
+ (NSArray *)po_loadPlistArrayFromDirectory:(DirectoryType)directory
                               withFileName:(NSString *)fileName;

#pragma mark -

/**
 *  包目录下的路径
 *
 *  @param fileName 文件名
 */
+ (NSString *)po_getBundlePathForFile:(NSString *)fileName;

/**
 *  Documents目录下的路径
 *
 *  @param fileName 文件名
 */
+ (NSString *)po_getDocumentsDirectoryForFile:(NSString *)fileName;

/**
 *  Library目录下的路径
 *
 *  @param fileName 文件名
 */
+ (NSString *)po_getLibraryDirectoryForFile:(NSString *)fileName;

/**
 *  Cache目录下的路径
 *
 *  @param fileName 文件名
 */
+ (NSString *)po_getCacheDirectoryForFile:(NSString *)fileName;

/**
 *  返回文件的大小
 *
 *  @param fileName  文件名
 *  @param directory 目录类型
 */
+ (NSNumber *)po_fileSize:(nullable NSString *)fileName
            fromDirectory:(DirectoryType)directory;

/**
 *  返回某文件夹内所有文件的大小 总和
 *
 *  @param fileName  文件夹名
 *  @param directory 目录类型
 */
+ (long long)po_fileSizeAtFileName:(nullable NSString *)fileName fromDirectory:(DirectoryType)directory;

/**
 *  返回某文件夹内所有文件的大小 总和
 *
 *  @param directoryPath  文件夹路径
 */
+ (long long)po_fileSizeAtFileDirectory:(nullable NSString *)directoryPath;

/**
 *  返回文件的大小
 *
 *  @param filePath  文件路径
 */
+ (long long)po_fileSizeAtPath:(nullable NSString *)filePath;

/**
 *  通过文件名删除文件
 *
 *  @param fileName  文件名
 *  @param directory 目录类型
 */
+ (BOOL)po_deleteFile:(nullable NSString *)fileName
        fromDirectory:(DirectoryType)directory;

/**
 *  通过文件路径删除文件
 *
 *  @param filePath  文件路径
 */
+ (BOOL)po_deleteWithFilePath:(nullable NSString *)filePath;

/**
 *  移动文件到其他目录
 *
 *  @param fileName    文件名
 *  @param origin      原目录
 *  @param destination 新目录
 */
+ (BOOL)po_moveLocalFile:(nullable NSString *)fileName
           fromDirectory:(DirectoryType)origin
             toDirectory:(DirectoryType)destination;

/**
 *  移动文件到其他目录的一个文件夹下
 *
 *  @param fileName        文件名
 *  @param origin             原目录
 *  @param destination  新目录
 *  @param folderName    新目录下的文件夹名
 */
+ (BOOL)po_moveLocalFile:(nullable NSString *)fileName
           fromDirectory:(DirectoryType)origin
             toDirectory:(DirectoryType)destination
          withFolderName:(nullable NSString *)folderName;

/**
 *  复制一个路径下的全部文件到另一个路径
 *
 *  @param origin      原路径
 *  @param destination 新路径
 */
+ (BOOL)po_copyFileAtPath:(nullable NSString *)origin
                toNewPath:(nullable NSString *)destination;

/**
 *  为文件改名
 *
 *  @param directory 目录类型
 *  @param fileName  老文件名
 *  @param newName   新文件名
 */
+ (BOOL)po_renameFileFromDirectory:(DirectoryType)directory
                      withFileName:(nullable NSString *)fileName
                        andNewName:(nullable NSString *)newName;

@end

NS_ASSUME_NONNULL_END
