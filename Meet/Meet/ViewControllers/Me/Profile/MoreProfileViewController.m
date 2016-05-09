//
//  MoreProfileViewController.m
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MoreProfileViewController.h"
#import "CellTextField.h"
//#import "CellPlaceHolderTextView.h"
#import "TextViewCell.h"
#import "UITextView+Placeholder.h"
#import "CellTextView.h"

#define TABLE_HEADER_VIEW_H         49

@interface MoreProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate> {
    
    NSMutableArray *_arraySection;
    NSMutableDictionary *_dicHeaderContent;
    NSMutableDictionary *_dicPlaceHolder;
    
    BOOL keyboardShow;
    CGRect tableViewFrame;
    
    NSIndexPath *_editingIndexPath;
    BOOL isEditSectionTitle;
    NSUInteger *_editingSection;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoreProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationBar];
    self.navigationItem.title = @"更多个人介绍";
    self.view.backgroundColor = [UIColor whiteColor];
    [UITools navigationRightBarButtonForController:self action:@selector(saveAction:) normalTitle:@"保存" selectedTitle:nil];
    
    
    _arraySection = [NSMutableArray arrayWithArray:@[@"lifeAndJob",@"interset",@"custom0",@"hopeFriends",@"last"]];
    
    _dicHeaderContent = [NSMutableDictionary dictionaryWithDictionary:@{_arraySection[0]:@"您的工作、生活情况",_arraySection[1]:@"您的兴趣及爱好",_arraySection[2]:@"给您增加的内容起个标题吧",_arraySection[3]:@"您希望认识什么样的朋友",_arraySection[4]:@""}];
    _dicPlaceHolder = [NSMutableDictionary dictionaryWithDictionary:@{_arraySection[0]:@"包括但不限于：你的工作内容、工作状态及工作中的收获；你的生活方式、对生活要求及对未来生活的期待。",_arraySection[1]:@"可以分享下你的兴趣爱好都有哪些，为什么会喜欢，以及有什么期待",_arraySection[2]:@"再分享一些其他的故事",_arraySection[3]:@"可以说说你希望认识什么样的朋友",_arraySection[4]:@""}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideAction:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - customView
-(void)customNavigationBar {
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBut];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)cancelButtonAction:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)saveAction:(id)sender {
    
}

#pragma mark - NSNotificationCenter
- (void)keyboardShowAction:(NSNotification *)notification {
    if (keyboardShow) {
        return ;
    }
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    tableViewFrame = _tableView.frame;
    _tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height - keyboardSize.height);
    if (isEditSectionTitle) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_editingSection] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    } else
        [self.tableView scrollToRowAtIndexPath:_editingIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    keyboardShow = YES;
}

- (void)keyboardHideAction:(NSNotification *)sender {
    if (!keyboardShow) {
        return ;
    }
    _tableView.frame = tableViewFrame;
    keyboardShow = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _arraySection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == _arraySection.count -1) {
        return 1;
    } else
        return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && indexPath.section != _arraySection.count -1) {
        return 150;
    } else
        return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, TABLE_HEADER_VIEW_H)];
    CellTextField *textField = [[CellTextField alloc] initWithFrame:CGRectMake(20, (TABLE_HEADER_VIEW_H -30)/2 , self.tableView.bounds.size.width *2/3, 30)];
    textField.section = section;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleNone;
    textField.text = _dicHeaderContent[_arraySection[section]];
    [view addSubview: textField];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLE_HEADER_VIEW_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell ;
    if (indexPath.row == 0) {
        if (indexPath.section == _arraySection.count -1) {
            NSString * const labelCell =@"defaultCell";
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:labelCell];
//            cell.textLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"申请Meet记者采编";
            return cell;
        } else {
            NSString *cellIdentifier = @"textViewCell";
            TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.textView.delegate = self;
            }
            cell.textView.placeholder = _dicPlaceHolder[_arraySection[indexPath.section]];
            cell.textView.indexPath = indexPath;
            return cell;
        }
    } else if (indexPath.row == 1){
        NSString *cellIdentifier = @"addImageCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        UIImageView *imageView1 = (UIImageView *)[cell viewWithTag:2];
        UIImageView *imageView2 = (UIImageView *)[cell viewWithTag:3];
        if (imageView1.image != nil || imageView2.image != nil) {
            label.hidden = YES;
            imageView2.hidden = NO;
            imageView1.hidden = NO;
        } else {
            label.hidden = NO;
            imageView2.hidden = YES;
            imageView1.hidden = YES;
        }
    }
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CellTextField class]]) {
        CellTextField *cellTextField = (CellTextField *)textField;
        _editingSection = cellTextField.section;
        isEditSectionTitle = YES;
    }
    return YES;
}

#pragma mark -  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    isEditSectionTitle = NO;
    if ([textView isKindOfClass:[CellTextView class]]) {
        CellTextView *cellText = (CellTextView *)textView;
        _editingIndexPath = cellText.indexPath;
        
    }
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    return YES;
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end