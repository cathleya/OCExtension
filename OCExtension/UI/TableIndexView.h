
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@class TableIndexView;
@protocol TableIndexViewDelegate <NSObject>
@optional
-(void)touchBegin;
-(void)touchEnd;
-(NSArray*)sectionIndexTitlesForIndexView:(TableIndexView*)tableIndexView;
@end

@interface TableIndexView : UIView

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) id<TableIndexViewDelegate> delegate;

- (TableIndexView *)initWithFrame:(CGRect)frame tableView:(UITableView *)tableView;
- (void)refreshIndexItems;

@end
