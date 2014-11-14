//
//  ServerRosterFetch.m
//  xmppchat
//
//  Created by kuanchih on 2014/10/22.
//  Copyright (c) 2014年 Jhicoll. All rights reserved.
//

#import "ServerRosterFetch.h"
#import "ServerConnect.h"
#import <CoreData/CoreData.h>

@interface ServerRosterFetch ()<NSFetchedResultsControllerDelegate>

//@property (nonatomic, strong) ServerConnect *serverConnect;

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation ServerRosterFetch

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.serverConnect = [ServerConnect sharedConnect];
    }
    return self;
}

- (NSArray *)sections {
    return [self.fetchedResultsController sections];
}

- (NSArray *)users {
    return [self.fetchedResultsController fetchedObjects];
}

- (void)setupFetchRosterController {
    if (self.fetchedResultsController == nil)
    {
        NSManagedObjectContext *moc = [[ServerConnect sharedConnect]  managedObjectContext_roster];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
//        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
//        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd2, nil];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:moc
                                                                              sectionNameKeyPath:@"sectionNum"
                                                                                       cacheName:nil];
        [self.fetchedResultsController setDelegate:self];
        
        
        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error])
        {
            NSLog(@"Error performing fetch: %@", error);
        }
        
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"finish load data sec %d user %d",(int)[[controller sections] count], (int)[[controller fetchedObjects] count]);
    [self.delegate serverDidFinishFetchRosters:[controller fetchedObjects] sections:[controller sections]];
}

@end
