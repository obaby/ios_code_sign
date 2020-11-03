//  iOS 存档恢复工具
//  hzm.m
//  hzm
//  http://www.h4ck.org.cn
//  Created by obaby on 15/9/22.
//  Copyright (c) 2015年 obaby@mars. All rights reserved.
//

#import "hzm.h"
#import "ZipArchive.h"

@implementation hzm

-(id)init
{
	if ((self = [super init]))
	{
	}
    
	return self;
}
//uncompress ipa file
void UnCompressiPa (NSString * cFileName ,NSString *output);

void UnCompressiPa (NSString * cFileName ,NSString *output)
{
    ZipArchive * za = [[ZipArchive alloc]init];
    
    if ([za UnzipOpenFile:cFileName]) {
        if ([za UnzipFileTo:output overWrite:YES] != NO) {
            //std::cout << ipafileName.UTF8String <<" have been unziped success\n";
            NSLog(@"%@ have benn unzipped success !\n",cFileName);
        }
        [za UnzipCloseFile];
    }
    //[za release];
}

//检测文件目录是否存在
BOOL isFileExists(NSString * filename)
{
    NSFileManager * filemanager;
    filemanager = [[NSFileManager alloc]init];
    if (![filemanager fileExistsAtPath:filename]) {
        return NO;
    }
    return YES;
}

static void __attribute__((constructor)) initialize(void)
{
    
    NSLog(@"======================= lib注入成功 ========================");
    
    
    //无线金币
    NSString *outputdir = [NSHomeDirectory() stringByAppendingString:@"/tmp"] ;
    if (!isFileExists(outputdir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:outputdir withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"[*]无限金币：Output dir:%@ created!",outputdir);
    }
    
    NSString *isFirstRunSigFile =[NSHomeDirectory() stringByAppendingString:@"/Documents/isFirst"] ;
    if (isFileExists(isFirstRunSigFile)) {
        NSLog(@"[*]无限金币：not first time run nothing do!");
    }else{
        NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"coin" ofType:@"zip"];
        UnCompressiPa(dataFile, outputdir);
        NSLog(@"[*]无限金币：First time run,file uncompressed and installed");
        NSString *sigeFiledata = @"NO";
        [sigeFiledata writeToFile:isFirstRunSigFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"[*]无限金币：Sig file created!");
        
        NSLog(@"copy all files to documents");
        
        NSString *dcPath = [outputdir stringByAppendingString:@"/Container/Documents/"];
        
        NSString *dcDest = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
        
        
        
        NSDirectoryEnumerator *dcEnum  = [[NSFileManager defaultManager] enumeratorAtPath:dcPath];
        
        NSString *tmpPath ;
        
        sleep(2);
        
        //NSLog(@"%@",dcEnum);
        //[NSTemporaryDirectory() stringByAppendingString:tmpPath]
        NSError *err;
        
        while ((tmpPath = [dcEnum nextObject]) != nil) {
            NSLog(@"%@",[dcPath stringByAppendingString:tmpPath]);
            [[NSFileManager defaultManager] removeItemAtPath:[dcDest stringByAppendingString:tmpPath] error:nil];
            BOOL bStatus = [[NSFileManager defaultManager] copyItemAtPath:[dcPath stringByAppendingString:tmpPath] toPath:[dcDest stringByAppendingString:tmpPath]error:&err];
            if (bStatus == NO) {
                NSLog(@"%@ copy failed!",[dcDest stringByAppendingString:tmpPath]);
            }
        }
        
        
        
        NSString *lbPath = [outputdir stringByAppendingString:@"/Container/Library/"];
        NSString *lbDest = [NSHomeDirectory() stringByAppendingString:@"/Library/"];
        
        NSDirectoryEnumerator *lbEnum = [[ NSFileManager defaultManager] enumeratorAtPath:lbPath];
        
        while ((tmpPath = [lbEnum nextObject] )!= nil) {
            NSLog(@"%@",[lbPath stringByAppendingString:tmpPath]);
            [[NSFileManager defaultManager] removeItemAtPath:[lbDest stringByAppendingString:tmpPath] error:nil];
            BOOL bStatus =[[NSFileManager defaultManager] copyItemAtPath:[lbPath stringByAppendingString:tmpPath] toPath:[lbDest stringByAppendingString:tmpPath]error:&err];
            if (bStatus == NO) {
                NSLog(@"%@ copy failed!",[lbDest stringByAppendingString:tmpPath]);
            }
            
        }
        
        
        NSString *tmPath = [outputdir stringByAppendingString:@"/Container/tmp"];
        NSString *tmDest = [NSHomeDirectory() stringByAppendingString:@"/tmp"];
        NSDirectoryEnumerator *tmEnum = [[NSFileManager defaultManager] enumeratorAtPath:tmpPath];
        while ((tmpPath = [tmEnum nextObject] )!= nil) {
            NSLog(@"%@",[tmPath stringByAppendingString:tmpPath]);
            [[NSFileManager defaultManager] removeItemAtPath:[tmDest stringByAppendingString:tmpPath] error:nil];
            BOOL bStatus = [[NSFileManager defaultManager] copyItemAtPath:[tmPath stringByAppendingString:tmpPath] toPath:[tmDest stringByAppendingString:tmpPath] error:&err];
            if (bStatus == NO) {
                NSLog(@"%@ copy failed!",[tmDest stringByAppendingString:tmpPath]);
            }
        }
        
    }
    //sleep(5);
    NSLog(@"======================= All done ========================");
    
    
}


@end
