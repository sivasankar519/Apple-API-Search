//
//  DataManager.h
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/16/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
@property (nonatomic, strong) NSArray *dataArray;

+ (DataManager *)sharedInstance;

- (void)loadURLRequestWithURLString:(NSString *)urlString completionHandler:(void (^)(NSData *data))completionHandler;


- (NSString *)getImageURLStringForCell:(NSInteger)index;


@end
