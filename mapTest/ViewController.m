//
//  ViewController.m
//  mapTest
//
//  Created by 이 상찬 on 13. 8. 20..
//  Copyright (c) 2013년 이 상찬. All rights reserved.
//

#import "ViewController.h"
#define SEARCH_DB @"searchList.sqlite"

@interface ViewController ()

@end

@implementation ViewController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        self.title = @"메인화면";
        self.popupTableView = [[UITableView alloc]init];
        [self.view addSubview:self.popupTableView];
        
        self.popupTableView.delegate = self;
        self.popupTableView.dataSource = self;
        
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.searchBar.delegate = self;
        
        UIImage *image = [[UIImage imageNamed:@"1-the-scream.jpg"] resizedImage:CGSizeMake(100, 100) interpolationQuality:kCGInterpolationDefault];
        image = [image roundedCornerImage:50 borderSize:2];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        CGRect imageViewFrame = imageView.frame;
        imageViewFrame.origin.y = 100;
        imageView.frame = imageViewFrame;
        [self.view addSubview:imageView];
        //image roundedCornerImage:<#(NSInteger)#> borderSize:<#(NSInteger)#>
    }
    return self;
}

-(NSArray*)loadSearchListFromDB {
    //self.mySearchArray = nil;
    //self.mySearchArray = [NSMutableArray arrayWithObjects:@"테스트1",@"테스트2",@"test3", nil];
    NSMutableArray *nameFromDB = [[NSMutableArray alloc]init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"searchList"ofType:@"sqlite"];
    
    sqlite3 *database;
    if (sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database);
        
        NSLog(@"Error");
    }
    
    sqlite3_stmt *selectStatement;
    
    char *selectSql = "SELECT name FROM search_list";
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        
        // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
        while (sqlite3_step(selectStatement)==SQLITE_ROW) {
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0) ];
            //[self.mySearchArray addObject:name];
            [nameFromDB addObject:name];
            //NSLog(@"name : %@",name);
        }
        
    }
    
    
    //statement close
    sqlite3_finalize(selectStatement);
    
    //db close
    sqlite3_close(database);
    return nameFromDB;
    //self.mySearchArray = [NSMutableArray arrayWithArray:nameFromDB];
    //[self.listTableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.listTableView.hidden = NO;
    self.popupTableView.hidden = YES;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.listTableView.hidden = YES;
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect popupTableViewFrame = self.popupTableView.frame;
    popupTableViewFrame.size.width = 160;
    popupTableViewFrame.size.height = 240;
    popupTableViewFrame.origin.x = 0;
    popupTableViewFrame.origin.y = self.leftButton.frame.origin.y - popupTableViewFrame.size.height;
    self.popupTableView.frame = popupTableViewFrame;
    self.listTableView.hidden = YES;
    self.popupTableView.hidden = YES;
    NSArray *result = [self loadSearchListFromDB];
    self.mySearchArray = [NSMutableArray arrayWithArray:result];
    [self.listTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClicked:(id)sender {
    //self.view addSubview:<#(UIView *)#>
    self.popupTableView.hidden = !self.popupTableView.hidden;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (tableView.tag == POPUP_TABLE)? 40 : 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView.tag == POPUP_TABLE)? 6: self.mySearchArray.count;
}

static NSString *popupTableViewCellIdentifier = @"popupTableViewCell";
static NSString *listTableVIewCellIdentifier = @"listTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *thisCell;
    if (tableView.tag == POPUP_TABLE) {
        thisCell = [tableView dequeueReusableCellWithIdentifier:popupTableViewCellIdentifier];
        if (thisCell == nil) {
            thisCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:popupTableViewCellIdentifier];
            thisCell.textLabel.text = [self stringForPopupTableIndex:indexPath.row];
        }
    }
    else {
        thisCell = [tableView dequeueReusableCellWithIdentifier:listTableVIewCellIdentifier];
        if (thisCell == nil) {
            thisCell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listTableVIewCellIdentifier];
            thisCell.textLabel.text = [self.mySearchArray objectAtIndex:indexPath.row];
            thisCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    return thisCell;
}

-(NSString *)stringForPopupTableIndex : (int)rowNumber {
    switch (rowNumber) {
        case 0:
            return @"전체선택";
        case 1:
            return @"V 매장";
        case 2:
            return @"VS 매장";
        case 3:
            return @"R 매장";
        case 4:
            return @"A 매장";
        case 5:
            return @"Gz 매장";
        default:
            return @"";
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == POPUP_TABLE) {
        if (indexPath.row == 0) {
            BOOL checked = (thisCell.accessoryType == UITableViewCellAccessoryNone)? YES:NO;
            NSArray *cells = [tableView visibleCells];
            for (UITableViewCell *tempCell in cells) {
                [self tableViewCell:tempCell checked:checked];
            }
        }
        else {
            [self tableViewCell:thisCell checked:(thisCell.accessoryType == UITableViewCellAccessoryNone)? YES:NO];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView.tag == POPUP_TABLE) {
        if (indexPath.row == 0) {
            BOOL checked = (thisCell.accessoryType == UITableViewCellAccessoryNone)? YES:NO;
            NSArray *cells = [tableView visibleCells];
            for (UITableViewCell *tempCell in cells) {
                [self tableViewCell:tempCell checked:checked];
            }
        }
        else {
            [self tableViewCell:thisCell checked:(thisCell.accessoryType == UITableViewCellAccessoryNone)? YES:NO];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    [self.view endEditing:YES];
}

-(void)tableViewCell:(UITableViewCell*)cell checked:(BOOL)checked {
    cell.selected = checked;
    cell.accessoryType = (checked) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (IBAction)button2Clicked:(id)sender {
    NSDictionary *shopData = [[NSDictionary alloc]initWithObjectsAndKeys:@"이름",@"name",@"주소",@"address", nil];
    NSArray *shopList = @[shopData,shopData,shopData,shopData,shopData,shopData];
    MyShopListViewController *myShopListViewController = [[MyShopListViewController alloc]initWithStyle:UITableViewStylePlain shopList:shopList];
    [self.navigationController pushViewController:myShopListViewController animated:YES];
}
- (void)viewDidUnload {
    [self setListTableView:nil];
    [self setSearchBar:nil];
    [self setLeftButton:nil];
    [super viewDidUnload];
}
@end
