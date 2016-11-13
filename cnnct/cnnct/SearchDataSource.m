//
//  DEMODataSource.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 5/28/14.
//  Copyright (c) 2014 Mainloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SearchDataSource.h"
#import "SearchAutoCompleteObject.h"

@interface SearchDataSource ()

@property (strong, nonatomic) NSArray *searchObjects;

@end


@implementation SearchDataSource


#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSArray *completions;
        if(self.testWithAutoCompleteObjectsInsteadOfStrings){
            completions = [self allSearchObjects];
        } else {
            completions = [self allStrings];
        }
        
        handler(completions);
    });
}

/*
 - (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
 {
 
 if(self.simulateLatency){
 CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
 NSLog(@"sleeping fetch of completions for %f", seconds);
 sleep(seconds);
 }
 
 NSArray *completions;
 if(self.testWithAutoCompleteObjectsInsteadOfStrings){
 completions = [self allCountryObjects];
 } else {
 completions = [self allCountries];
 }
 
 return completions;
 }
 */

- (NSArray *)allSearchObjects
{
    if(!self.searchObjects){
        NSArray *searchTerms = [self allStrings];
        NSMutableArray *mutableSearchTerms = [NSMutableArray new];
        for(NSString *term in mutableSearchTerms){
            SearchAutoCompleteObject *result = [[SearchAutoCompleteObject alloc] initWithCountry:term];
            [mutableSearchTerms addObject:result];
        }
        
        [self setSearchObjects:[NSArray arrayWithArray:mutableSearchTerms]];
    }
    
    return self.searchObjects;
}


- (NSArray *)allStrings
{
    NSArray *strings =
    @[
      @"Anthony",
      @"Michael",
      @"Githiora"
      ];
    
    return strings;
}





@end
