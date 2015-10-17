//
//  DataManager.m
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/16/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import "DataManager.h"

typedef void (^completionHandler)(NSData *data);

@interface DataManager () < NSURLSessionDataDelegate >
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@end

@implementation DataManager

+ (DataManager *)sharedInstance {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.session = [NSURLSession sessionWithConfiguration:configuration
                                                     delegate:self
                                                delegateQueue:nil];
        
        self.dictionary = [NSMutableDictionary dictionary];
    }
    
    return self;
}


- (NSString *)getImageURLStringForCell:(NSInteger)index {
    NSDictionary *dict = [self.dataArray objectAtIndex:index];
    
    if(dict[@"artworkUrl100"]) return dict[@"artworkUrl100"];
    else if (dict[@"artworkUrl60"]) return dict[@"artworkUrl60"];
    else return dict[@"artworkUrl30"];
    
}

- (void)loadURLRequestWithURLString:(NSString *)urlString completionHandler:(void (^)(NSData *data))completionHandler {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    
    [self.dictionary setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSMutableData data], @"data",
                                [completionHandler copy], @"completionHandler",
                                nil]
                        forKey:task];
    [task resume];
}

#pragma NSURLSession
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self.dictionary[dataTask][@"data"] appendData:data];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (self.dictionary[task]) {
        completionHandler completionHandler = self.dictionary[task][@"completionHandler"];
        
        if (completionHandler) {
            completionHandler(self.dictionary[task][@"data"]);
        }
    }
}


@end
