//
//  MyShopListViewController.h
//  mapTest
//
//  Created by 이 상찬 on 13. 8. 22..
//  Copyright (c) 2013년 이 상찬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyShopListViewController : UITableViewController {
    NSMutableArray *_myShopArray;
}

@property(nonatomic, retain) NSMutableArray *myShopArray;


- (id)initWithStyle:(UITableViewStyle)style shopList:(NSArray *)_myShopArray;
@end
