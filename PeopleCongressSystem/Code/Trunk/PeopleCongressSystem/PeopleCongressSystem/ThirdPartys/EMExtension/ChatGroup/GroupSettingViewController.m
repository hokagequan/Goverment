/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "GroupSettingViewController.h"
#import "PeopleCongressSystem-Swift.h"

@interface GroupSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    EMGroup *_group;
    BOOL _isOwner;
    UISwitch *_pushSwitch;
    UISwitch *_blockSwitch;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation GroupSettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithGroup:(EMGroup *)group
{
    self = [self init];
    if (self) {
        _group = group;
        
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        _isOwner = [_group.owner isEqualToString:loginUsername];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"title.groupSetting", @"Group Setting");
    
    if (!_isOwner) {
        UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        [self.navigationItem setRightBarButtonItem:saveItem];
    }
    
    _pushSwitch = [[UISwitch alloc] init];
    [_pushSwitch addTarget:self action:@selector(pushSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [_pushSwitch setOn:_group.isPushNotificationEnabled animated:YES];
    
    _blockSwitch = [[UISwitch alloc] init];
    [_blockSwitch addTarget:self action:@selector(blockSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [_blockSwitch setOn:_group.isBlocked animated:YES];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [PCSCustomUtil customNavigationController:self];
    CGFloat height = [self customPCSNavi:self.title];
    CGRect frame = self.tableView.frame;
    frame.origin.y += height;
    frame.size.height -= height;
    self.tableView.frame = frame;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hideHud];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_isOwner) {
        return 1;
    }
    else{
        if (_blockSwitch.isOn) {
            return 1;
        }
        else{
            return 2;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ((_isOwner && indexPath.row == 0) || (!_isOwner && indexPath.row == 1)) {
        _pushSwitch.frame = CGRectMake(self.tableView.frame.size.width - (_pushSwitch.frame.size.width + 10), (cell.contentView.frame.size.height - _pushSwitch.frame.size.height) / 2, _pushSwitch.frame.size.width, _pushSwitch.frame.size.height);
        
        if (_pushSwitch.isOn) {
            cell.textLabel.text = NSLocalizedString(@"group.setting.receiveAndPrompt", @"receive and prompt group of messages");
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"group.setting.receiveAndUnprompt", @"receive not only hint of messages");
        }
        
        [cell.contentView addSubview:_pushSwitch];
        [cell.contentView bringSubviewToFront:_pushSwitch];
    }
    else if(!_isOwner && indexPath.row == 0){
        _blockSwitch.frame = CGRectMake(self.tableView.frame.size.width - (_blockSwitch.frame.size.width + 10), (cell.contentView.frame.size.height - _blockSwitch.frame.size.height) / 2, _blockSwitch.frame.size.width, _blockSwitch.frame.size.height);
        
        cell.textLabel.text = NSLocalizedString(@"group.setting.blockMessage", @"shielding of the message");
        [cell.contentView addSubview:_blockSwitch];
        [cell.contentView bringSubviewToFront:_blockSwitch];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private

- (void)isIgnoreGroup:(BOOL)isIgnore
{
    [self showHudInView:self.view hint:NSLocalizedString(@"group.setting.save", @"set properties")];
    
    __weak GroupSettingViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient].groupManager ignoreGroupPush:_group.groupId ignore:isIgnore];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            if (!error) {
                [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
            }
            else{
                [weakSelf showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
            }
        });
    });
}

#pragma mark - action

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushSwitchChanged:(id)sender
{
    if (_isOwner) {
        BOOL toOn = _pushSwitch.isOn;
        [self isIgnoreGroup:!toOn];
    }
    [self.tableView reloadData];
}

- (void)blockSwitchChanged:(id)sender
{
    [self.tableView reloadData];
}

- (void)saveAction:(id)sender
{
    if (_blockSwitch.isOn != _group.isBlocked) {
        __weak typeof(self) weakSelf = self;
        [self showHudInView:self.view hint:NSLocalizedString(@"group.setting.save", @"set properties")];
        if (_blockSwitch.isOn) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error;
                [[EMClient sharedClient].groupManager blockGroup:_group.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [weakSelf hideHud];
                        [weakSelf showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
                    } else {
                        [weakSelf hideHud];
                        [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
                    }
                });
            });
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error;
                [[EMClient sharedClient].groupManager unblockGroup:_group.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [weakSelf hideHud];
                        [weakSelf showHint:NSLocalizedString(@"group.setting.fail", @"set failure")];
                    } else {
                        [weakSelf hideHud];
                        [weakSelf showHint:NSLocalizedString(@"group.setting.success", @"set success")];
                    }
                });
            });
        }
    }
    
    if (_pushSwitch.isOn != _group.isPushNotificationEnabled) {
        [self isIgnoreGroup:!_pushSwitch.isOn];
    }
}

@end
