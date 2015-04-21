//
//  PhotoCell.h
//  WheelyClone
//
//  Created by Vitaly Berg on 19/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCell : UITableViewCell

- (void)fillPhoto:(id)photo;

+ (UINib *)nib;

@end
