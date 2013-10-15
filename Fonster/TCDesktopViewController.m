#import "TCDesktopViewController.h"

@interface TCDesktopIcon : NSObject
@property UIImage *icon;
@property NSString *title;
@property(weak) id target;
@property SEL action;
@end

@interface TCDesktopViewController ()
{
    NSMutableArray *_icons;
}
@end

@implementation TCDesktopViewController

- (id)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.itemSize = CGSizeMake(125, 125);
    if(!(self = [super initWithCollectionViewLayout:layout]))
        return nil;
    
    _icons = [NSMutableArray new];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TCDesktopIconCell" bundle:nil] forCellWithReuseIdentifier:@"TCDesktopIconCell"];

    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _icons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCDesktopIcon *desktopIcon = _icons[indexPath.row];
    
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TCDesktopIconCell" forIndexPath:indexPath];
    UIImageView *image = (id)[cell viewWithTag:1];
    image.layer.cornerRadius = 11;
    image.layer.masksToBounds = YES;
    UILabel *label = (id)[cell viewWithTag:2];
    
    image.image = desktopIcon.icon;
    label.text = desktopIcon.title;
    return cell;
}

- (void)addIcon:(UIImage*)icon title:(NSString*)title target:(id)target action:(SEL)action
{
    TCDesktopIcon *desktopIcon = [TCDesktopIcon new];
    desktopIcon.icon = icon;
    desktopIcon.title = title;
    desktopIcon.target = target;
    desktopIcon.action = action;
    [_icons addObject:desktopIcon];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TCDesktopIcon *desktopIcon = _icons[indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [desktopIcon.target performSelector:desktopIcon.action withObject:nil];
#pragma clang diagnostic pop
}

@end

@implementation TCDesktopIcon
@end