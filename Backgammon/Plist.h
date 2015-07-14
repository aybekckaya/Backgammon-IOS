//
//  Plist.h
//  PlistOperations
//
//  Created by aybek can kaya on 4/30/15.
//  Copyright (c) 2015 aybek can kaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Plist : NSObject
{
    NSString *namePlist;
}


/**
 /
    Creates Plist in documents folder if it has not created yet. 
    @param : plistName (name of plist without extension "plist")
 */
-(id)initWithPlistName:(NSString *)plistName;

/**
  @return plistName without path components.
 */
-(NSString *)plistNameOfInstance;

/**
    writes the contents of val with specified key
 */
-(void)write:(id) val Key:(NSString *)key;

/**
    remove the object which has specified key
 */
-(void)removeObjectWithKey:(NSString *)key;

/**
    clears the contents of Plist
 */
-(void)removeAllObjects;

/**
   reads the  contents of plist with given key
 */
-(id)read:(NSString *)key;


/**
    reads all contents in Plist
 */
-(id)readAll;


-(NSArray *)allKeys;

-(BOOL)keyExists:(NSString *)key;


/**
   static method : return plist objects in documents folder
 */
+(NSArray *)allLists;

+(void)deletePlist:(NSString *)plistName;

+(void)deleteAllPlists;


@end
