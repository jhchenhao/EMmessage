//
//  ViewController.m
//  EMMessage-demo
//
//  Created by jhtxch on 16/5/14.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import "ViewController.h"
#import "EMSDK.h"
#import "ChatVC.h"
#import "EMSDKFull.h"


@interface ViewController ()<EMContactManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UILabel *prompt;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITextField *contactname;
@property (weak, nonatomic) IBOutlet UITextField *contactMessage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingaaa)]];
    
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    _user.text = @"chenhao";
    _pwd.text = @"111111";
    _contactname.text = @"chenhao2";
}

- (void)endEditingaaa
{
    [self.view endEditing:YES];
}

- (IBAction)reg:(UIButton *)sender {
    EMError *error = [[EMClient sharedClient] registerWithUsername:_user.text password:_pwd.text];
    if (!error) {
        _prompt.text = @"注册成功";
        NSLog(@"注册成功");
    }else{
        _prompt.text = @"注册失败";
        NSLog(@"注册失败");
    }
}
- (IBAction)login:(UIButton *)sender {
    EMError *error = [[EMClient sharedClient] loginWithUsername:_user.text password:_pwd.text];
    if (!error) {
        _prompt.text = @"登入成功";
        NSLog(@"登入成功");
        NSArray *contacts = [self getContactsFromServer];
        NSLog(@"好友列表 %@",contacts);
    }else{
        _prompt.text = @"登入失败";
        NSLog(@"登入失败");
    }
}
- (IBAction)logout:(UIButton *)sender {
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        _prompt.text = @"退出成功";
        NSLog(@"退出成功");
    }else{
        _prompt.text = @"登入失败";
        NSLog(@"退出失败");
    }
        
}


- (IBAction)send:(UIButton *)sender {
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_message.text];
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_contactname.text from:from to:_contactname.text body:body ext:nil];
    message.chatType = EMChatTypeChat;
    
    
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            _prompt.text = @"发送成功";
            NSLog(@"发送成功");
        }else{
            _prompt.text = @"发送失败";
            NSLog(@"发送失败");
        }
    }];
}
- (IBAction)sendCustomer:(UIButton *)sender {
    ChatVC *chatVc = [[ChatVC alloc] initWithConversationChatter:_contactname.text conversationType:EMConversationTypeChat LinkInfo:[self getEXT1]];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
}


- (IBAction)addContact:(id)sender {
    EMError *error = [[EMClient sharedClient].contactManager addContact:_contactname.text message:_contactMessage.text];
    if (!error) {
        _prompt.text = @"发送好友请求成功";
        NSLog(@"发送好友请求成功");
    }else{
        _prompt.text = @"发送好友请求失败";
        NSLog(@"发送好友请求失败");
    }
    
}
- (IBAction)deleteContact:(UIButton *)sender {
    EMError *error = [[EMClient sharedClient].contactManager deleteContact:_contactname.text];
    if (!error) {
        _prompt.text = @"删除好友成功";
        NSLog(@"删除好友成功");
    }else{
        _prompt.text = @"删除好友失败";
        NSLog(@"删除好友失败");
    }
}
- (IBAction)enterUI:(UIButton *)sender {
    ChatVC *vc = [[ChatVC alloc] initWithConversationChatter:_contactname.text conversationType:EMConversationTypeChat];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)call:(UIButton *)sender {
    EMError *error = nil;
    [[EMClient sharedClient].callManager makeVoiceCall:_contactname.text error:&error];
    if (!error) {
        _prompt.text = @"呼叫成功";
        NSLog(@"呼叫成功");
    }else{
        _prompt.text = @"呼叫失败";
        NSLog(@"呼叫失败");
    }
}

#pragma mark - cortact delegate
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername message:(NSString *)aMessage
{
    UIAlertController *alerVc = [UIAlertController alertControllerWithTitle:aUsername message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            _prompt.text = @"同意好友申请";
            NSLog(@"同意好友申请");
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            _prompt.text = @"拒绝好友申请";
            NSLog(@"拒绝好友申请");
        }
    }];
    
    [alerVc addAction:okaction];
    [alerVc addAction:cancelAction];
    [self presentViewController:alerVc animated:YES completion:^{
        
    }];
}


//对面同意后的回调
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    _prompt.text = @"对方同意添加好友";
    NSLog(@"对方同意添加好友");
}
//对面拒绝后的回调
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    _prompt.text = @"对方拒绝添加好友";
    NSLog(@"对方拒绝添加好友");
}


#pragma mark - contacts
- (NSArray *)getContactsFromServer
{
    EMError *error = nil;
    NSArray *userList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取好友列表成功");
        return userList;
    }
    NSLog(@"获取好友列表失败");
    return nil;
}

- (NSArray *)getContactsFromDB
{
    return [[EMClient sharedClient].contactManager getContactsFromDB];
}



- (NSDictionary *)getEXT1
{
    return @{@"type":@"link",
             @"order":@"订单号 123456",
             @"img_url":@"http://www.lagou.com/upload/indexPromotionImage/ff8080814cffb587014d09b2d7810206.png",
             @"dec":@"2015早春新款高腰复古牛仔裤",
             @"price":@"¥200",
             @"title":@"测试test223"};
}
- (NSDictionary *)getEXT
{
    NSDictionary *info = @{@"price":@"￥128",
                           @"imageName":@"mallImage0.png",
                           @"img_url":@"http://www.lagou.com/upload/indexPromotionImage/ff8080814cffb587014d09b2d7810206.png",
                           @"item_url":@"http://www.easemob.com",
                           @"title":@"123test",
                           @"type":@"track",
                           @"desc":@"2015早春新款高腰复古牛仔裤"};
    NSString *type = [info objectForKey:@"type"];
    NSString *title = [info objectForKey:@"title"];
    NSString *desc = [info objectForKey:@"desc"];
    NSString *price = [info objectForKey:@"price"];
    NSString *imageUrl = [info objectForKey:@"img_url"];
    NSString *itemUrl = [info objectForKey:@"item_url"];
    
    NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
    if (title) {
        [itemDic setObject:title forKey:@"title"];
    }
    if (desc) {
        [itemDic setObject:desc forKey:@"desc"];
    }
    if (price) {
        [itemDic setObject:price forKey:@"price"];
    }
    if (imageUrl) {
        [itemDic setObject:imageUrl forKey:@"img_url"];
    }
    if (itemUrl) {
        [itemDic setObject:itemUrl forKey:@"item_url"];
    }
    
    if ([type isEqualToString:@"order"]) {
        NSString *orderTitle = [info objectForKey:@"order_title"];
        if (orderTitle) {
            [itemDic setObject:orderTitle forKey:@"order_title"];
        }
    }
    
    NSString *imageName = [info objectForKey:@"imageName"];
    NSMutableDictionary *extDic = [NSMutableDictionary dictionaryWithDictionary:[self getWeiChat]];
    [extDic setObject:@{type:itemDic} forKey:@"msgtype"];
    [extDic setObject:imageName forKey:@"imageName"];
    [extDic setObject:@"custom" forKey:@"type"];
    
    return extDic;
}

- (NSDictionary*)getWeiChat
{
    NSDictionary *ext = nil;
    NSDictionary* weichat = [self getUserInfoAttribute];
    ext = @{@"weichat":weichat};
    return ext;
}

- (NSDictionary*)getUserInfoAttribute
{
    NSDictionary *ext = nil;
    NSMutableDictionary *visitor = [NSMutableDictionary dictionary];
    [visitor setObject:@"李明" forKey:@"trueName"];
    [visitor setObject:@"10000" forKey:@"qq"];
    [visitor setObject:@"13512345678" forKey:@"phone"];
    [visitor setObject:@"环信" forKey:@"companyName"];
    [visitor setObject:@"李敏".length==0?@"李明":@"李敏" forKey:@"userNickname"];
    [visitor setObject:@"abc@123.com" forKey:@"email"];
    ext = @{@"visitor":visitor,@"queueName":@"shouqian"};
    return ext;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
