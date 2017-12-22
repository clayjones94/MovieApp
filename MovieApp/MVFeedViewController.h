//
//  MVFeedViewController.h
//  MovieApp
//
//  Created by Clay Jones on 11/20/16.
//  Copyright © 2016 ClayJones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MKDropdownMenu/MKDropdownMenu.h>

@interface MVFeedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKDropdownMenuDelegate, MKDropdownMenuDataSource>
-(CGRect) getTableViewRec;
@end
