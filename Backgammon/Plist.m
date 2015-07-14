//
//  Plist.m
//  PlistOperations
//
//  Created by aybek can kaya on 4/30/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import "Plist.h"

@implementation Plist

-(id)initWithPlistName:(NSString *)plistName
{
    if(self = [super init])
    {
        
        NSString *documentsDirectory = [self documentsPath];
        namePlist= [NSString stringWithFormat:@"%@.plist" , plistName];
        
        NSString *path = [documentsDirectory stringByAppendingPathComponent:namePlist];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath: path]) {
            
          //  path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:namePlist] ];
        }
        
        NSMutableDictionary *data;
        
        if ([fileManager fileExistsAtPath: path]) {
            
            data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        }
        else {
            // If the file doesn’t exist, create an empty dictionary
            data = [[NSMutableDictionary alloc] init];
        }
        
        //To insert the data into the plist
       // [data setObject:@"iPhone 6 Plus" forKey:@"value123"];
        [data writeToFile:path atomically:YES];
        
    }
    
    return self;
}

-(NSString *)plistNameOfInstance
{
    return namePlist;
}

-(NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}


-(void)write:(id)val Key:(NSString *)key
{
    NSString *documentsPath = [self documentsPath];
    NSString *path = [documentsPath stringByAppendingPathComponent:namePlist];
    
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    
    [dctMute setValue:val forKey:key];
    [dctMute writeToFile:path atomically:YES];
    
}


-(NSString *)plistPath
{
    NSString *documentsPath = [self documentsPath];
    NSString *path = [documentsPath stringByAppendingPathComponent:namePlist];
    
    return path;
}

-(id)readAll
{
    
    NSString *path =[self plistPath];
    
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    return dctMute;
}


-(id)read:(NSString *)key
{
    NSMutableDictionary *allValues = (NSMutableDictionary *)[self readAll];
    id val = [allValues objectForKey:key];
    return val;
}


-(void)removeObjectWithKey:(NSString *)key
{
    NSMutableDictionary *dctMute = [self readAll];
    [dctMute removeObjectForKey:key];
   
    NSString *path = [self plistPath];
    [dctMute writeToFile:path atomically:YES];
}

-(void)removeAllObjects
{
    NSMutableDictionary *dctMute = [[NSMutableDictionary alloc]init];
    NSString *path = [self plistPath];
    [dctMute writeToFile:path atomically:YES];
}


-(NSArray *)allKeys
{
    NSMutableDictionary *dctMute = [self readAll];
    NSArray *keysAll = [dctMute allKeys];
    return keysAll;
}

-(BOOL)keyExists:(NSString *)key
{
    NSArray *allKeys = [self allKeys];
    if([allKeys containsObject:key])
    {
        return YES;
    }
    return NO;
}


// Statics
+(NSArray *)allLists
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    
    NSMutableArray *listAll = [[NSMutableArray alloc]init];
    
    for(NSString *strPath in directoryContents)
    {
        if(strPath.length > 6)
        {
             NSString *type = [strPath substringWithRange:NSMakeRange(strPath.length-6, 6)];
            if([[type lowercaseString] isEqualToString:@".plist"])
            {
                NSString *name= [strPath substringWithRange:NSMakeRange(0, strPath.length-6)];
                  Plist *list = [[Plist alloc]initWithPlistName:name];
                [listAll addObject:list];
            }
        }
       
    }
    
    
    return [[NSArray alloc]initWithArray:listAll];
}

+(void)deletePlist:(NSString *)plistName
{
    NSArray *allLists = [Plist allLists];
    for(Plist *list in allLists)
    {
        NSString *name = [list plistNameOfInstance];
        
        
        plistName = [NSString stringWithFormat:@"%@.plist" , plistName];
        if([name isEqualToString:plistName])
        {
            NSString *documentsPath = [list documentsPath];
            NSString *path = [documentsPath stringByAppendingPathComponent:name];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
}


+(void)deleteAllPlists
{
    NSArray *allLists = [Plist allLists];
    for(Plist *list in allLists)
    {
        NSString *name = [list plistNameOfInstance];
        [Plist deletePlist:name];
    }
}



@end
