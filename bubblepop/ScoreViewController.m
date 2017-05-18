//
//  ScoreViewController.m
//  bubblepop
//
//  Created by Nihal Sunthankar on 17/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
///Users/nihalsunthankar/Dropbox/iOS/Assignment 2/bubblepop/bubblepop/ScoreViewController.m

#import "ScoreViewController.h"
#import "AppDelegate.h"
#import "Score.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scores"];
    NSArray *scoreObjects = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] copy];

    NSMutableArray *tempScores = [[NSMutableArray alloc] init];

    for(NSManagedObject *scoreObject in scoreObjects) {
        Score *score = [[Score alloc] init];
        score.player = [NSString stringWithFormat:@"%@", [scoreObject valueForKey:@"player"]];
        score.value = [[NSString stringWithFormat:@"%@", [scoreObject valueForKey:@"score"]] intValue];

        [tempScores addObject:score];
    }

    NSSortDescriptor *scoreDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
    self.scores = [tempScores sortedArrayUsingDescriptors:@[scoreDescriptor]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    Score *score = self.scores[(NSUInteger) indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", score.player];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", score.value];
    return cell;
}

- (NSManagedObjectContext *)managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSPersistentContainer *container = [delegate persistentContainer];
    return [container viewContext];
}

@end
