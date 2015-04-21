//
//  OfferCell.h
//  WheelyClone
//
//  Created by Vitaly Berg on 18/04/15.
//  Copyright (c) 2015 Vitaly Berg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferCell : UITableViewCell

- (void)fillOffer:(id)offer;

+ (UINib *)nib;

@end
