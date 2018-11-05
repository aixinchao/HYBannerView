//
//  AppDelegate.h
//  HYBannerView
//
//  Created by 艾信超 on 2018/11/3.
//  Copyright © 2018年 aixinchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

