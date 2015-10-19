//
//  DataFetch.h
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/18/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetch : NSObject

@property(nonatomic, strong) NSString* searchKey;
+ (DataFetch *)sharedInstance;
- (NSArray*)fetchSearchList;
- (NSArray*)getResultsWithSearchKey:(NSString*)searchString;
- (void)save;
-(void)saveData:(NSArray*)results;
@end
