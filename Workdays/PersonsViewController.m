//
//  PersonsViewController.m
//  Workdays
//
//  Created by Andrey Fedorov on 09.02.14.
//  Copyright (c) 2014 Andrey Fedorov. All rights reserved.
//

#import "PersonsViewController.h"
#import "PersonDetailViewController.h"
#import "Person.h"
#import "NSIndexPath+Unsigned.h"
#import "NSDate+ComparisonAndDays.h"


@implementation PersonsViewController
{
    NSMutableArray *_persons;
}


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths firstObject] stringByAppendingPathComponent:@"workdays.dat"];
}


- (void)savePersons
{
    [NSKeyedArchiver archiveRootObject:_persons
                                toFile:[self dataFilePath]];
}


- (void)loadPersons
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _persons = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    if (!_persons) {
        _persons = [[NSMutableArray alloc] init];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadPersons];

    // disable swipe left as back action
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"AddPersonCell"];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_persons count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.u_row < [_persons count]) {
        Person *person = _persons[indexPath.u_row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"
                                               forIndexPath:indexPath];
        cell.textLabel.text = person.name;

        Workday *min = nil;
        NSDate *today = [[NSDate date] dateWithoutTime];
        for (Workday *wd in person.workdays) {
            if ([wd.startDate lessOrEqual:today]) {
                min = wd;
            } else {
                break;
            }
        }

        NSString *state = @"";
        if (min) {
            NSUInteger work = min.workDaysCount;
            NSUInteger free = min.freeDaysCount;
            int n = 0;
            NSDate *tmp = nil;
            do {
                tmp = [NSDate dateWithTimeInterval:3600 * 24 * n++
                                         sinceDate:min.startDate];

                if (work == 0 && free == 0) {
                    work = min.workDaysCount;
                    free = min.freeDaysCount;
                }

                if (work > 0) {
                    work--;
                    state = @"Рабочий";
                } else if (free > 0) {
                    free--;
                    state = @"Выходной";
                }
            } while ([tmp lessThan:today]);
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
        [_persons removeObjectAtIndex:indexPath.u_row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [self savePersons];
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
    Person *person = _persons[fromIndexPath.u_row];
    _persons[fromIndexPath.u_row] = _persons[toIndexPath.u_row];
    _persons[toIndexPath.u_row] = person;
    [self savePersons];
}


- (BOOL)    tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.u_row < [_persons count];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEditing]) {
        if (indexPath.u_row == [_persons count]) {
            return UITableViewCellEditingStyleInsert;
        }
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (IBAction)savePerson:(UIStoryboardSegue *)segue
{
    PersonDetailViewController *controller = [segue sourceViewController];
    if (controller.person && controller.person.modified) {
        NSUInteger index = [_persons indexOfObject:controller.person];
        if (index == NSNotFound) {
            [_persons addObject:controller.person];
            index = [_persons count] - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                        inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index
                                                        inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }

        [self savePersons];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    if ([segue.identifier isEqualToString:@"AddPerson"]) {

    } else if ([segue.identifier isEqualToString:@"ViewPerson"]) {
        PersonDetailViewController *controller = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.person = _persons[(NSUInteger)indexPath.row];
    }
}


@end
