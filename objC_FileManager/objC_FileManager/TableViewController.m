//
//  TableViewController.m
//  objC_FileManager
//
//  Created by kluv on 15/03/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSString* path;
@property (strong, nonatomic) NSArray* contents;

@end

@implementation TableViewController

- (id) initWithFolderPath: (NSString*) path {
 
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
        
        NSError* error = nil;
        
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    if ([self.navigationController.viewControllers count] > 1) {
     
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"ROOT" style:UIBarButtonItemStylePlain target:self action:@selector(actionBackToRoot:)];
        
        self.navigationItem.rightBarButtonItem = item;
        
    }
    
}

#pragma mark - Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - Methods
    
- (BOOL) isFolderAtIndexPath:(NSIndexPath*) indexPath {

    NSString* filePath = [self fullPathAtIndexPath:indexPath];
    
    BOOL isFolder = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isFolder];
    
    return isFolder;
    
}

- (NSString*) fullPathAtIndexPath:(NSIndexPath*) indexPath {
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    
    return filePath;
    
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
 
    [self setupView];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.contents count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* indetifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
    }
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isFolderAtIndexPath:indexPath]) {
        cell.imageView.image = [UIImage imageNamed:@"folder"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"file"];
    }
    
    cell.textLabel.text = fileName;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isFolderAtIndexPath:indexPath]) {
     
        NSString* filePath = [self fullPathAtIndexPath:indexPath];
        
        TableViewController* folderView = [[TableViewController alloc] initWithFolderPath:filePath];
        
        [self.navigationController pushViewController:folderView animated:YES];
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
