

#import <UIKit/UIKit.h>

@class FETouchableView;

/**
 * @brief delegate to receive touch events
 */
@protocol FETouchableViewDelegate<NSObject>

- (void)viewTouchesEnded:(FETouchableView*)view;

@end

@interface FETouchableView : UIView


@property(nonatomic, weak) id<FETouchableViewDelegate> delegate;

@end
