//
//  TableViewController.h
//  objC_FileManager
//
//  Created by kluv on 15/03/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileCell.h"
#import "FolderCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : UITableViewController

- (id) initWithFolderPath: (NSString*) path;

@property (strong, nonatomic) NSString* path;

@property (weak, nonatomic) IBOutlet UIButton *testButton;



@end

NS_ASSUME_NONNULL_END
