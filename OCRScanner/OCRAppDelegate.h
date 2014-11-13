//
//  OCRAppDelegate.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface OCRAppDelegate : UIResponder <UIApplicationDelegate,NSXMLParserDelegate>
{
    NSMutableArray *feeds;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSString *element;
}
@property (strong, nonatomic) UIImage* imageToProcess;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *NavigationController;
-(void)SetUpTabbarControllerwithcenterView :(UIViewController *)CenterView;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
