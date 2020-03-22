//
//  FolderCell.h
//  objC_FileManager
//
//  Created by kluv on 22/03/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FolderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *folderName;
@property (weak, nonatomic) IBOutlet UILabel *folderInfo;

@end

NS_ASSUME_NONNULL_END
