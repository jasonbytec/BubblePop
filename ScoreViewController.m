//
//  ScoreViewController.m
//  bubblepop
//
//  Created by Nihal Sunthankar on 17/5/17.
//  Copyright © 2017 Jason King. All rights reserved.
///Users/nihalsunthankar/Dropbox/iOS/Assignment 2/bubblepop/bubblepop/ScoreViewController.m

#import "ScoreViewController.h"
#import "AppDelegate.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Scores"];
    self.scores = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] copy];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    NSManagedObject *score = self.scores[(NSUInteger) indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [score valueForKey:@"player"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [score valueForKey:@"score"]];
    return cell;
}

- (NSManagedObjectContext *)managedObjectContext {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSPersistentContainer *container = [delegate persistentContainer];
    return [container viewContext];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
