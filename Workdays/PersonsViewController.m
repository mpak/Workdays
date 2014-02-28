//
//  PersonsViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PersonsViewController.h"
#import "Person.h"
#import "NSIndexPath+Unsigned.h"
#import "PersonsStorage.h"


@implementation PersonsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // disable swipe left as back action
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"AddPersonCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshPersonsList];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)applicationWillEnterForeground
{
    [self refreshPersonsList];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)refreshPersonsList
{
    if ([PersonsStorage shouldRefreshDisplayedData]) {
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [PersonsStorage size] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.u_row < [PersonsStorage size]) {
        Person *person = [PersonsStorage personAtIndex:indexPath.u_row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"
                                               forIndexPath:indexPath];
        cell.textLabel.text = person.name;

        NSString *state = @"";
        NSUInteger index = 0;
        switch([person dayTypeForDate:[NSDate date] index:&index]) {
            case WorkDay: state = @"Рабочий"; break;
            case FreeDay: state = @"Выходной"; break;
            case UnknownDay:break;
        }
        if (index) {
            state = [state stringByAppendingFormat:@" %u", index];
        }
        cell.detailTextLabel.text = state;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddPersonCell"
                                               forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}


- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [PersonsStorage removePersonAtIndex:indexPath.u_row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [self performSegueWithIdentifier:@"AddPerson"
                                  sender:self];
    }
}


- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
       toIndexPath:(NSIndexPath *)toIndexPath
{
    [PersonsStorage swap:fromIndexPath.u_row
                     and:toIndexPath.u_row];
}


- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.u_row < [PersonsStorage size];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEditing]) {
        if (indexPath.u_row == [PersonsStorage size]) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (IBAction)savePerson:(UIStoryboardSegue *)segue
{
    [PersonsStorage saveCurrentPerson:^(NSUInteger index, BOOL isNew)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                    inSection:0];
        if (isNew) {
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if ([segue.identifier isEqualToString:@"AddPerson"]) {
        [PersonsStorage selectNewPerson];
    } else if ([segue.identifier isEqualToString:@"ViewPerson"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [PersonsStorage selectPersonAtIndex:indexPath.u_row];
    }
}


@end
