//
//  ViewController.h
//  mapTest
//
//  Created by 이 상찬 on 13. 8. 20..
//  Copyright (c) 2013년 이 상찬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MyShopListViewController.h"

#define LIST_TABLE 1
#define POPUP_TABLE 2

@interface ViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UITableView *popupTableView;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray *mySearchArray;
- (IBAction)buttonClicked:(id)sender;
- (IBAction)button2Clicked:(id)sender;

@end
