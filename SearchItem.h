//
//  SearchItem.h
//  AppleSearchAPI
//
//  Created by SIVASANKAR DEVABATHINI on 10/18/15.
//  Copyright (c) 2015 SIVASANKAR DEVABATHINI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DetailInfo;

@interface SearchItem : NSManagedObject

@property (nonatomic, retain) NSString * searchItem;
@property (nonatomic, retain) NSSet *detailInfo;
@end

@interface SearchItem (CoreDataGeneratedAccessors)

- (void)addDetailInfoObject:(DetailInfo *)value;
- (void)removeDetailInfoObject:(DetailInfo *)value;
- (void)addDetailInfo:(NSSet *)values;
- (void)removeDetailInfo:(NSSet *)values;

@end
