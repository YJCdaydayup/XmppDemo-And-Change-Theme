//
//  ChatViewController.m
//  XmppDemo
//
//  Created by 杨力 on 17/6/2016.
//  Copyright © 2016 杨力. All rights reserved.
//

#import "ChatViewController.h"
#import "ZCFaceToolBar.h"
#import "MessageCell.h"
#import "Photo.h"

@interface ChatViewController (){
    
    ZCXMPPManager * manager;
    ZCFaceToolBar * faceToolBar;
}

@property (nonatomic,strong) UIImage * friendImage;
@property (nonatomic,strong) UIImage * myImage;

@end

@implementation ChatViewController

-(void)dealloc{
    
    [faceToolBar removeObserver:self forKeyPath:@"frame" context:nil];
    //不在接收消息
    [manager valuationChatPersonName:nil IsPush:NO MessageBlock:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createFaceToolBar];
    [self loadData];
    [self createVcard];
}

#pragma mark -获取Vcard
-(void)createVcard{
    
    [[ZCXMPPManager sharedInstance]getMyVcardBlock:^(BOOL isOk, XMPPvCardTemp * vCard) {
      
        if(vCard.photo){
            self.myImage = [UIImage imageWithData:vCard.photo];
        }else{
            self.myImage = [UIImage imageNamed:@"logo_2.png"];
        }
        [_tableView reloadData];
    }];
    
    [[ZCXMPPManager sharedInstance]friendsVcard:[[self.friendJid componentsSeparatedByString:@"@"]firstObject ] Block:^(BOOL isSucceed, XMPPvCardTemp *friendVcard) {
        if (friendVcard.photo) {
            self.friendImage=[UIImage imageWithData:friendVcard.photo];
        }else{
            self.friendImage=[UIImage imageNamed:@"logo_2.png"];
        }
        
        [_tableView reloadData];
    }];
    
}

#pragma mark －创建emoj键盘
-(void)createFaceToolBar{
    
    faceToolBar = [[ZCFaceToolBar alloc]initWithFrame:CGRectMake(0, 0, 10, 1000) voice:nil ViewController:self Block:^(NSString * sign, NSString * message) {
        
        [manager sendMessageWithJID:self.friendJid Message:message Type:sign];
        [self loadData];
    }];
    [self.view addSubview:faceToolBar];
    
    //观察键盘的弹出/消失
    [faceToolBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 开始观察
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    _tableView.frame = CGRectMake(0, 0, WIDTH, faceToolBar.frame.origin.y);
    //移动时刷新数据
    if(self.dataArray.count){
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)loadData{
    
    //获取消息
    manager = [ZCXMPPManager sharedInstance];
    [manager valuationChatPersonName:self.friendJid IsPush:YES MessageBlock:^(ZCMessageObject * obj) {
        
        //获取消息
        [self loadData];
    }];
    
    //获取消息记录
    NSArray * array = [manager messageRecord];
    if(array){
        self.dataArray = [[NSMutableArray alloc]initWithArray:array];
    }else{
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    //刷新界面
    if(self.dataArray.count>0){
        [_tableView reloadData];
        //产生偏移
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //给tableView添加回收键盘的手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideToolBar)];
    [_tableView addGestureRecognizer:tap];
}

#pragma mark - 键盘点击回收
-(void)hideToolBar{
    [faceToolBar dismissKeyBoard];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    //获取数据
    XMPPMessageArchiving_Message_CoreDataObject * obj = self.dataArray[indexPath.row];
    [cell configFriendImage:self.friendImage myImage:self.myImage message:obj];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取内容
    XMPPMessageArchiving_Message_CoreDataObject*object=self.dataArray[indexPath.row];
    NSString*str=object.message.body;
    
    if ([str hasPrefix:MESSAGE_STR]) {
        CGFloat height=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size.height;
        
        return height+40;
    }else{
        if ([str hasPrefix:MESSAGE_IMAGESTR]) {
            UIImage*image=[Photo string2Image:[str substringFromIndex:3]];
            return image.size.height>200?220:image.size.height;
        }else{
            if ([str hasPrefix:MESSAGE_BIGIMAGESTR]) {
                return 210;
            }else{
                return 70;
            }
            
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
