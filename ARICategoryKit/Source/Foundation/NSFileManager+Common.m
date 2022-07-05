//
//  NSFileManager+Common.m
//
//  Created by Marc Steven on 2020/12/29.
//

#import "NSFileManager+Common.h"

@implementation NSFileManager (Common)

+ (NSURL *)po_URLForDirectory:(NSSearchPathDirectory)directory {
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)po_pathForDirectory:(NSSearchPathDirectory)directory {
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES)[0];
}

+ (NSURL *)po_documentsURL {
    return [self po_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)po_documentsPath {
    return [self po_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)po_libraryURL {
    return [self po_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)po_libraryPath {
    return [self po_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)po_cachesURL {
    return [self po_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)po_cachesPath {
    return [self po_pathForDirectory:NSCachesDirectory];
}

+ (NSString *)po_getBundlePathForFile:(NSString *)fileName {
    NSString *fileExtension = [fileName pathExtension];
    return [[NSBundle mainBundle] pathForResource:[fileName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", fileExtension] withString:@""] ofType:fileExtension];
}

+ (NSString *)po_getDocumentsDirectoryForFile:(NSString *)fileName {
    NSString *documentsDirectory = [self po_documentsPath];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", fileName]];
}

+ (NSString *)po_getLibraryDirectoryForFile:(NSString *)fileName {
    NSString *libraryDirectory = [self po_libraryPath];
    return [libraryDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", fileName]];
}

+ (NSString *)po_getCacheDirectoryForFile:(NSString *)fileName {
    NSString *cacheDirectory = [self po_cachesPath];
    return [cacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/", fileName]];
}

+ (NSString *)po_pathWithDirectory:(DirectoryType)directory fileName:(NSString *)fileName {
    
    NSString *path;
    
    switch (directory) {
        case DirectoryTypeMainBundle:
            path = [self po_getBundlePathForFile:fileName];
            break;
        case DirectoryTypeLibrary:
            path = [self po_getLibraryDirectoryForFile:fileName];
            break;
        case DirectoryTypeDocuments:
            path = [self po_getDocumentsDirectoryForFile:fileName];
            break;
        case DirectoryTypeCache:
            path = [self po_getCacheDirectoryForFile:fileName];
            break;
    }
    
    return path;
}

+ (NSString *)po_readTextFile:(NSString *)file ofType:(NSString *)type {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:type] encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)po_savePlistArrayToDirectory:(DirectoryType)directory withFileName:(NSString *)fileName array:(NSArray *)array {
    return [NSKeyedArchiver archiveRootObject:array toFile:[self po_pathWithDirectory:directory fileName:fileName]];
}

+ (NSArray *)po_loadPlistArrayFromDirectory:(DirectoryType)directory withFileName:(NSString *)fileName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self po_pathWithDirectory:directory fileName:fileName]];
    
    
}

+ (NSNumber *)po_fileSize:(NSString *)fileName fromDirectory:(DirectoryType)directory {
    if (fileName.length > 0) {
        NSString *path = [self po_pathWithDirectory:directory fileName:fileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            if (fileAttributes) {
                return [fileAttributes objectForKey:NSFileSize];
            }
        }
    }
    
    return nil;
}

+ (long long)po_fileSizeAtFileName:(NSString *)fileName fromDirectory:(DirectoryType)directory {
        
    if (fileName.length > 0) {
        NSString *filePath = [self po_pathWithDirectory:directory fileName:fileName];
        
        return [NSFileManager po_fileSizeAtFileDirectory:filePath];
    }
    
    return 0;
}

+ (long long)po_fileSizeAtFileDirectory:(NSString *)directoryPath {
    
    if (!directoryPath.length) {
        return 0;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:directoryPath]) {
        NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:directoryPath] objectEnumerator];
        
        NSString *fileName;
        long long totalFileSize = 0;
        
        while ((fileName = [filesEnumerator nextObject]) != nil) {
            NSString *path = [directoryPath stringByAppendingPathComponent:fileName];
            totalFileSize += [NSFileManager po_fileSizeAtPath:path];
        }
        
        return totalFileSize;
    }
    else {
        return 0;
    }
    
}

+ (long long)po_fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+ (BOOL)po_deleteFile:(NSString *)fileName fromDirectory:(DirectoryType)directory {
    if (fileName.length > 0) {
        NSString *path = [self po_pathWithDirectory:directory fileName:fileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    return NO;
}

+ (BOOL)po_deleteWithFilePath:(NSString *)filePath {
    if (filePath.length) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    }
    
    return NO;
}

+ (BOOL)po_moveLocalFile:(NSString *)fileName fromDirectory:(DirectoryType)origin toDirectory:(DirectoryType)destination {
    return [self po_moveLocalFile:fileName fromDirectory:origin toDirectory:destination withFolderName:nil];
}

+ (BOOL)po_moveLocalFile:(NSString *)fileName fromDirectory:(DirectoryType)origin toDirectory:(DirectoryType)destination withFolderName:(NSString *)folderName {
    NSString *originPath = [self po_pathWithDirectory:origin fileName:fileName];
    
    NSString *destinationPath;
    if (folderName) {
        destinationPath = [NSString stringWithFormat:@"%@/%@", folderName, fileName];
    } else {
        destinationPath = fileName;
    }
    
    destinationPath = [self po_pathWithDirectory:destination fileName:destinationPath];
    
    
    if (folderName) {
        NSString *folderPath = [NSString stringWithFormat:@"%@/%@", destinationPath, folderName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
    }
    
    BOOL copied = NO, deleted = NO;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:originPath]) {
        if ([[NSFileManager defaultManager] copyItemAtPath:originPath toPath:destinationPath error:nil]) {
            copied = YES;
        }
    }
    
    if (destination != DirectoryTypeMainBundle) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:originPath])
            if ([[NSFileManager defaultManager] removeItemAtPath:originPath error:nil]) {
                deleted = YES;
            }
    }
    
    if (copied && deleted) {
        return YES;
    }
    return NO;
}

+ (BOOL)po_copyFileAtPath:(NSString *)origin toNewPath:(NSString *)destination {
    if ([[NSFileManager defaultManager] fileExistsAtPath:origin]) {
        return [[NSFileManager defaultManager] copyItemAtPath:origin toPath:destination error:nil];
    }
    return NO;
}

+ (BOOL)po_renameFileFromDirectory:(DirectoryType)directory
                      withFileName:(NSString *)fileName
                        andNewName:(NSString *)newName {
    
    NSString *path = [self po_pathWithDirectory:directory fileName:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *newNamePath = [path stringByReplacingOccurrencesOfString:fileName withString:newName];
        if ([[NSFileManager defaultManager] copyItemAtPath:path toPath:newNamePath error:nil]) {
            if ([[NSFileManager defaultManager] removeItemAtPath:path error:nil]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
