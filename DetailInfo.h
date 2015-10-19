//
//  DetailInfo.h
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/18/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SearchItem;

@interface DetailInfo : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * collectionName;
@property (nonatomic, retain) NSString * releaseDate;
@property (nonatomic, retain) NSString * kind;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * previewUrl;
@property (nonatomic, retain) NSNumber * trackPrice;
@property (nonatomic, retain) NSNumber * trackTimeMillis;
@property (nonatomic, retain) NSString * trackName;
@property (nonatomic, retain) NSString * trackViewUrl;
@property (nonatomic, retain) SearchItem *searchItem;

@end
