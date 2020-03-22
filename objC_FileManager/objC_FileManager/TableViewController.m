//
//  TableViewController.m
//  objC_FileManager
//
//  Created by kluv on 15/03/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray* contents;

@property (strong, nonatomic) NSMutableArray* contentsFolders;
@property (strong, nonatomic) NSMutableArray* contentsFiles;

@property (strong, nonatomic) NSString* selectedPath;

@property (strong, nonatomic) UIView* previousViewController;

@end

@implementation TableViewController

- (id) initWithFolderPath: (NSString*) path {
 
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
    
}

- (void) reloadFileData {
    
    self.contentsFolders = [[NSMutableArray alloc] init];
    self.contentsFiles = [[NSMutableArray alloc] init];
    
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil];
    
    for (NSString* stringPath in self.contents) {
        
        BOOL isDirectory = NO;
                
        [[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:stringPath] isDirectory:&isDirectory];
        
        if (isDirectory) {
            [self.contentsFolders addObject:stringPath];
        } else {
            
            NSString *firstLetter = [stringPath substringToIndex:1];
            if ([firstLetter isEqualToString:@"."]) {
                continue;
            }
            
            [self.contentsFiles addObject:stringPath];
        }
        
    }
    
    [self.contentsFolders sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.contentsFiles sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (void) setPath:(NSString *)path {
 
    _path = path;
            
    [self reloadFileData];
        
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
        
    if (!self.path) {
        self.path = @"/Volumes/osx/Users/kluv/Documents/temp/";
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
 
    [super viewWillAppear:animated];
    
    [self setupBarButtonsItem];
    
    if (self.previousViewController == self.view) {
        
        [self setPath:self.path];
        
    }
        
}

- (void) setupBarButtonsItem {
     

    //folder btn
    UIButton* folderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 22)];
    [folderBtn addTarget:self action:@selector(actionCreateFolder:) forControlEvents:UIControlEventTouchUpInside];
    [folderBtn setImage:[UIImage systemImageNamed:@"folder.fill"] forState:UIControlStateNormal];
    
    //home btn
    UIButton* homeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 22)];
    [homeBtn addTarget:self action:@selector(actionBackToRoot:) forControlEvents:UIControlEventTouchUpInside];
    [homeBtn setImage:[UIImage systemImageNamed:@"house"] forState:UIControlStateNormal];
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithCustomView:folderBtn];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    
    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];;
    spaceItem.width = 11.0f;
    
    NSArray* buttons = [NSArray arrayWithObjects:item1, nil];
    
    if ([self.navigationController.viewControllers count] > 1) {
        buttons = [NSArray arrayWithObjects:item1, spaceItem, item2, nil];
    }
    
    self.navigationItem.rightBarButtonItems = buttons;
    
    if ([self.navigationController.viewControllers count] > 1) {
    
        //back button
        UIButton* folderBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 22)];
        [folderBtn addTarget:self action:@selector(actionCreateFolder:) forControlEvents:UIControlEventTouchUpInside];
        [folderBtn setImage:[UIImage systemImageNamed:@"arrow.uturn.left"] forState:UIControlStateNormal];
        
    }
        
    //arrow.uturn.left
        
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void) actionCreateFolder:(UIBarButtonItem*) sender {
 
    UIAlertController* alertCtrl = [UIAlertController alertControllerWithTitle:@"Enter folder name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCtrl addTextFieldWithConfigurationHandler:^(UITextField* textField) {
        textField.placeholder = @"Folder name";
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    
    UIAlertAction *actionOK = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
        UITextField *folderNameTextField = alertCtrl.textFields.firstObject;
        NSString* folderName = folderNameTextField.text;
        
        [self createFolder:folderName];
    }];
    
    [alertCtrl addAction:actionCancel];
    [alertCtrl addAction:actionOK];
    
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

#pragma mark - Methods
    
- (NSString*) getFileNameAtIndexPath:(NSIndexPath*) indexPath {
    
    NSString* fileName = @"";
    
    if ([self isFolderAtIndexPath:indexPath]) {
        fileName = [self.contentsFolders objectAtIndex:indexPath.row];
    } else {
        fileName = [self.contentsFiles objectAtIndex:indexPath.row - (int)[self.contentsFolders count]];
    }
    
    return fileName;
    
}

- (void) createFolder:(NSString*) folderName {
 
    NSString* filePath = [self.path stringByAppendingPathComponent:folderName];
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:nil];
    
    [self setPath:self.path];
    
}

- (void) deleteFileAtIndexPath:(NSIndexPath*) indexPath {
    
    NSString* fullPath = [self.path stringByAppendingPathComponent:[self getFileNameAtIndexPath:indexPath]];
    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
    
    [self reloadFileData];
    
}

- (void) printConstraintConstants:(UIView*) view {
    
    for (NSLayoutConstraint* constraint in view.constraints) {
        NSLog(@"%f",constraint.constant);
    }

    for (UIView* subview in view.subviews) {
        [self printConstraintConstants:subview];
    }
    
}

- (BOOL) isFolderAtIndexPath:(NSIndexPath*) indexPath {

    if (indexPath.row > (int)[self.contentsFolders count] - 1) {
        return NO;
    }
    
    return YES;
        
}

- (NSString*) fullPathAtIndexPath:(NSIndexPath*) indexPath {
    
    NSString* fileName = [self getFileNameAtIndexPath:indexPath];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    return filePath;
    
}

- (unsigned long long) folderSizeAtPath:(NSString*) path {
    
    NSArray* folderContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    unsigned long long folderSize = 0;
    
    for (NSString* fileName in folderContents) {
        
        NSString* fullPath = [path stringByAppendingPathComponent:fileName];
        
        BOOL isFolder = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isFolder];
        
        if (isFolder) {
        
            folderSize += [self folderSizeAtPath:fullPath];
            
        } else {
            
            NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:nil];
            folderSize += [fileAttributes fileSize];
        }
        
    }
    
    return folderSize;
    
}

- (NSString*) fileSizeFromValue:(unsigned long long) size {
 
    static NSString* units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
    static int unitsCount = 5;
    
    int index = 0;
    
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitsCount) {
     
        fileSize /= 1024;
        index++;
        
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
    
}

- (BOOL) detectFaceIDSafeAreaType {
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            case 1136:
                return NO;
                break;
                
            case 1334:
                return NO;
                break;
                
            case 1920:
                return NO;
                break;
                
            case 2208:
                return NO;
                break;
                
            case 2436:
                return YES;
                break;
                
            case 2688:
                return YES;
                break;
                
            case 1792:
                return YES;
                break;
                
            default:
                return NO;
                break;
        }
    }
    
    return NO;
    
}

- (void) setupView {
     
    CGFloat topInset = 0;
    
    if (![self detectFaceIDSafeAreaType]) {
        topInset = 20;
    }
        
    self.navigationController.additionalSafeAreaInsets = UIEdgeInsetsMake(topInset, 0, 0, 0);
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (int)[self.contentsFiles count] + (int)[self.contentsFolders count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* indetifier = nil;
    
    NSString* fileName = [self getFileNameAtIndexPath:indexPath];

    if ([self isFolderAtIndexPath:indexPath]) {
        
        indetifier = @"FolderCell";

        FolderCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
        
        if (!cell) {
            cell = [[FolderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        }
        
        cell.folderName.text = fileName;
        
        unsigned long long folderSize = [self folderSizeAtPath:[self.path stringByAppendingPathComponent:fileName]];
        
        cell.folderInfo.text = [NSString stringWithFormat:@"folder size: %@;", [self fileSizeFromValue:folderSize]];
        
        return cell;
        
    } else {
        
        indetifier = @"FileCell";
        
        NSString* filePath = [self fullPathAtIndexPath:indexPath];
        
        NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        
        FileCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
        
        if (!cell) {
            cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        }
        
        static NSDateFormatter* dateFormatter = nil;
        
        if (!dateFormatter) {
         
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/YY"];
            
        }
        
        cell.nameLabel.text = fileName;
        cell.infoLabel.text = [NSString stringWithFormat:@"size: %@; date mod.: %@", [self fileSizeFromValue:[fileAttributes fileSize]], [dateFormatter stringFromDate:[fileAttributes fileModificationDate]]];
        
        //[NSString stringWithFormat:@"size: %lld; modified: %@", [fileAttributes fileSize], [fileAttributes fileModificationDate]];
        
        return cell;
        
    }
    
}


#pragma mark - UITableViewDelegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                         title:@"DELETE"
                                                                       handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        [self deleteFileAtIndexPath:indexPath];
                            
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
                
        completionHandler(YES);
        
    }];
    
    delete.backgroundColor = [UIColor  purpleColor]; //arbitrary color
    
    UISwipeActionsConfiguration *swipeActionConfig = nil;
    
    swipeActionConfig = [UISwipeActionsConfiguration configurationWithActions:@[delete]];

    swipeActionConfig.performsFirstActionWithFullSwipe = NO;
    
    return swipeActionConfig;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isFolderAtIndexPath:indexPath]) {
     
        NSString* filePath = [self fullPathAtIndexPath:indexPath];
        
        //option 1
        
//        TableViewController* folderView = [[TableViewController alloc] initWithFolderPath:filePath];
//
//        [self.navigationController pushViewController:folderView animated:YES];
  
        //option 2 (best practice)
        
//        UIStoryboard* storyBoard = self.storyboard;
//
//        TableViewController* vc = [storyBoard instantiateViewControllerWithIdentifier:@"TableViewController1"];
//        vc.path = filePath;
//
//        [self.navigationController pushViewController:vc animated:YES];
        
        //option 3 with segue (not recomended)
        
        self.selectedPath = filePath;
        [self performSegueWithIdentifier:@"navigateDeep" sender:nil];
        
    }
    
}

#pragma mark - Seque

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    return YES;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    TableViewController* vc = segue.destinationViewController;
    vc.path = self.selectedPath;
    self.previousViewController = self.view;
    
}

@end
