//
//  ViewController.m
//  SearchApp-demo
//
//  Created by huanghy on 15/12/18.
//  Copyright © 2015年 huanghy. All rights reserved.
//

#import "ViewController.h"
#import "Friend.h"
#import <CoreSpotlight/CoreSpotlight.h>
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *tableDataArray;
    
}
@end

@implementation ViewController

-(NSArray *)tableViewDataSource{
   NSArray *nameArray = @[@"XIAO",@"MING",@"NI",@"HAO"];
    int i = 0;
    NSMutableArray *friendArray = [[NSMutableArray alloc]init];
    for (NSString *item in nameArray) {
        Friend *mfriend = [[Friend alloc]init];
        mfriend.name = item;
        mfriend.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",++i]];
        mfriend.webUrl = @"www.baidu.com";
        mfriend.f_id = [NSString stringWithFormat:@"%d",i];
        [friendArray addObject:mfriend];
    }
    return (friendArray!=nil)?friendArray:nil;
    
}

-(void)saveFriend
{
    NSMutableArray <CSSearchableItem *> *searchableItem = [NSMutableArray array];
    for (Friend *friend in tableDataArray) {
        CSSearchableItemAttributeSet *attritable = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:@"image"];
        attritable.title = friend.name;
        attritable.contentDescription = friend.webUrl;
        attritable.thumbnailData = UIImagePNGRepresentation(friend.image);
        CSSearchableItem *item = [[CSSearchableItem alloc]initWithUniqueIdentifier:friend.f_id domainIdentifier:@"www.baidu.com" attributeSet:attritable];
        [searchableItem addObject:item];
    }
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchableItem completionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"error=%@",error);

        }
    }];
    
}

-(void)loadImage:(NSString *)f_id
{
    Friend *someFriend = nil;
    for (Friend *item in tableDataArray) {
        if ([item.f_id isEqual:f_id]) {
            someFriend = item;
            break;
        }
    }
    if (someFriend) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(150, 300, 50, 50)];
        imageView.image = someFriend.image;
        [self.view addSubview:imageView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //M
    tableDataArray = [self tableViewDataSource];
    //V
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    //C
    [self saveFriend];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    Friend *friendCell = (Friend *)[tableDataArray objectAtIndex:indexPath.row];
    cell.imageView.image = friendCell.image;
    cell.textLabel.text = friendCell.name;
    cell.detailTextLabel.text = friendCell.webUrl;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
