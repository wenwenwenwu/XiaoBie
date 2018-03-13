//
//  NTESTeamListViewController.m
//  NIM
//
//  Created by Xuhui on 15/3/3.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESTeamListViewController.h"
#import "NIMSessionListViewController.h"
#import "NIMSessionViewController.h"

@interface NTESTeamListViewController () <UITableViewDelegate, UITableViewDataSource,NIMTeamManagerDelegate> {
}
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *myTeams;

@end

@implementation NTESTeamListViewController


- (void)dealloc{
    [[NIMSDK sharedSDK].teamManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTeams = [self fetchTeams];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    [[NIMSDK sharedSDK].teamManager addDelegate:self];
    //自定义
    [self setupNavigationBar];
}

- (NSMutableArray *)fetchTeams{
    NSArray *originalTeams =  [[NIMSDK sharedSDK].teamManager allMyTeams];
    NSMutableArray *teams = [NSMutableArray arrayWithArray:originalTeams];
    return teams;
}

#pragma mark - 自定义
- (void) setupNavigationBar {
    self.navigationItem.title = @"群组";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _myTeams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamListCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamListCell"];
    }
    NIMTeam *team = [_myTeams objectAtIndex:indexPath.row];
    cell.textLabel.text = team.teamName;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NIMTeam *team = [_myTeams objectAtIndex:indexPath.row];
    NIMSession *session = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:vc animated:YES];
}

@end



@implementation NTESAdvancedTeamListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"NTESTeamListViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"高级群组";
}

- (NSMutableArray *)fetchTeams{
    NSMutableArray *myTeams = [[NSMutableArray alloc]init];
    for (NIMTeam *team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        if (team.type == NIMTeamTypeAdvanced) {
            [myTeams addObject:team];
        }
    }
    return myTeams;
}

- (void)onTeamAdded:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamUpdated:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}


- (void)onTeamRemoved:(NIMTeam *)team{
    if (team.type == NIMTeamTypeAdvanced) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}


@end


@implementation NTESNormalTeamListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:@"NTESTeamListViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"讨论组";
}

- (NSMutableArray *)fetchTeams{
    NSMutableArray *myTeams = [[NSMutableArray alloc]init];
    for (NIMTeam *team in [NIMSDK sharedSDK].teamManager.allMyTeams) {
        if (team.type == NIMTeamTypeNormal) {
            [myTeams addObject:team];
        }
    }
    return myTeams;
}

- (void)onTeamUpdated:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}


- (void)onTeamRemoved:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}

- (void)onTeamAdded:(NIMTeam *)team{
    if (team.type == NIMTeamTypeNormal) {
        self.myTeams = [self fetchTeams];
    }
    [self.tableView reloadData];
}
@end

