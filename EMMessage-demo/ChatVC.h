//
//  ChatVC.h
//  EMMessage-demo
//
//  Created by jhtxch on 16/5/14.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "EaseMessageViewController.h"

typedef enum : NSUInteger {
    ChatPersonToPerson,
    ChatPersonToCustomer
} ChatType;

@interface ChatVC : EaseMessageViewController

@property (nonatomic, assign) ChatType chatType;

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType LinkInfo:(NSDictionary *)ext;

@end
