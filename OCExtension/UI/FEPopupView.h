

#import <UIKit/UIKit.h>

#define SHADOW_OFFSET					CGSizeMake(10, 10)
#define CONTENT_OFFSET					CGSizeMake(10, 10)
#define POPUP_ROOT_SIZE					CGSizeMake(20, 10)

#define HORIZONTAL_SAFE_MARGIN			30

#define POPUP_ANIMATION_DURATION		0.3
#define DISMISS_ANIMATION_DURATION		0.2

#define DEFAULT_TITLE_SIZE				20

#define ALPHA							0.85
#define CORNER_RADIOUS                  6

#define BAR_BUTTON_ITEM_UPPER_MARGIN	10
#define BAR_BUTTON_ITEM_BOTTOM_MARGIN	5

@class TouchPeekView;

typedef enum
{
	FEPopupViewUp		= 1,
	FEPopupViewDown		= 2,
	FEPopupViewRight	= 1 << 8,
	FEPopupViewLeft		= 2 << 8,
}FEPopupViewDirection;

@class FEPopupView;

@protocol FEPopupViewModalDelegate <NSObject>
@optional
- (void)didDismissModal:(FEPopupView*)popupview;

@end

@interface FEPopupView : UIView
{
	
	CGRect		_contentRect;
	CGRect		_contentBounds;
	
	CGRect		_popupRect;
	CGRect		_popupBounds;
	CGRect      _showRect;
    
	CGRect		_viewRect;
	CGRect		_viewBounds;
	
	CGPoint		_pointToBeShown;
	
	NSString	*_title;
	UIImage		*_image;
	float		_fontSize;
	
	UIView		*_contentView;
	
	float		_horizontalOffset;
    
    
	FEPopupViewDirection            _direction;

	TouchPeekView                   *_peekView;
	
	BOOL                            _animatedWhenAppering;
}
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic, assign)   CGSize  contentOffset;//默认 CONTENT_OFFSET
@property (nonatomic, weak) id <FEPopupViewModalDelegate> delegate;

- (id)initWithString:(NSString*)newValue withFontOfSize:(float)newFontSize;
- (id)initWithString:(NSString*)newValue;
- (id)initWithImage:(UIImage*)newImage;
- (id)initWithContentView:(UIView*)newContentView contentSize:(CGSize)contentSize;

- (void)presentModalAtPoint:(CGPoint)p inView:(UIView*)inView;
- (void)presentModalAtPoint:(CGPoint)p inView:(UIView*)inView animated:(BOOL)animated;
- (void)presentModalAtRect:(CGRect)rect inView:(UIView*)inView animated:(BOOL)animated;

- (BOOL)shouldBeDismissedFor:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)dismissModal;

@end
