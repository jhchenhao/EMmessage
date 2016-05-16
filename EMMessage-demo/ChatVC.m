//
//  ChatVC.m
//  EMMessage-demo
//
//  Created by jhtxch on 16/5/14.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "ChatVC.h"
#import "LinkCell.h"

@interface ChatVC ()<EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>
@property (nonatomic, copy) NSDictionary *ext;


@end

@implementation ChatVC

- (instancetype)initWithConversationChatter:(NSString *)conversationChatter conversationType:(EMConversationType)conversationType LinkInfo:(NSDictionary *)ext
{
    self = [super initWithConversationChatter:conversationChatter conversationType:conversationType];
    if (self) {
        _ext = ext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    if (_ext) {
        [self sendLinkMessage:_ext];
    }

}


- (void)sendLinkMessage:(NSDictionary *)ext
{
    EMMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"客服图文混排"];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:[[EMClient sharedClient] currentUsername] to:self.conversation.conversationId body:body ext:ext];
    message.chatType = EMChatTypeChat;
    [self _sendMessage:message];
}

#pragma mark - message datasource
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)messageModel
{
    if (messageModel.message.ext && [[messageModel.message.ext objectForKey:@"type"] isEqualToString:@"link"]) {
        LinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Link"];
        if (!cell) {
            cell = [[LinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Link" model:messageModel];//设置消息内容
        }
        cell.model = messageModel;//头像
        return cell;
    }
    return nil;
}

- (CGFloat)messageViewController:(EaseMessageViewController *)viewController heightForMessageModel:(id<IMessageModel>)messageModel withCellWidth:(CGFloat)cellWidth
{
    if (messageModel.message.ext && [[messageModel.message.ext objectForKey:@"type"] isEqualToString:@"link"]) {
        return 120.f;
    }
    return 0.f;
}

@end
