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

@property (strong, nonatomic) NSString* selectedPath;

@end

@implementation TableViewController

- (id) initWithFolderPath: (NSString*) path {
 
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.path = path;
    }
    return self;
    
}

- (void)setPath:(NSString *)path {
 
    _path = path;
    
    NSError* error = nil;
    
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
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

    return [self.contents count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* indetifier = nil;
    
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];

    if ([self isFolderAtIndexPath:indexPath]) {
        
        indetifier = @"FolderCell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        }
        
        cell.textLabel.text = fileName;
        
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
