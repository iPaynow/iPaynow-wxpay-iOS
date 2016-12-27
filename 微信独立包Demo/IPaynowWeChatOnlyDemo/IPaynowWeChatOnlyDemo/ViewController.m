//
//  ViewController.m
//  IPNWeChatOnlyDemo
//
//  Created by 黄睿 on 2016/10/27.
//  Copyright © 2016年 ipaynow. All rights reserved.
//

#import "ViewController.h"
#import "IpaynowPluginDelegate.h"
#import "IPNPreSignMessageUtil.h"
#import "IPNDESUtil.h"
#import "IpaynowPluginApi.h"


#define COEFFICIENT   self.view.frame.size.width / 320

#define kBtnFirstTitle    @"获取订单，开始支付"
#define kWaiting          @"正在获取订单,请稍候..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果："
@interface ViewController ()<IpaynowPluginDelegate,UIAlertViewDelegate>

@end

@implementation ViewController{
    NSString *_presignStr;
    NSString *_orderNo;
    UIAlertView *_mAlert;
    NSString *_prepareString;
    UITextField *_appId;
    UITextField *_appKey;
    UITextField *_txtOrderNo;
    UITextField *_txtAmt;
    UITextField *_txtOrderDetail;
    UITextField *_txtOrderStartTime;
    UITextField *_notifyUrl;
    UITextField *_txtMhtPreserved;
    // 原始订单(mhtPreserved部分没经过URL编码)
    NSString *_originalString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [IpaynowPluginApi setLoadingViewHidden:NO];
    [IpaynowPluginApi setBeforeReturnLoadingHidden:YES];
}

- (void)startPay{
    [self payByType:@"13"];
}

#pragma mark - 订单发起

- (void)payByType:(NSString *)payChannelType{
    NSInteger amt = [_txtAmt.text integerValue];
    if (_txtAmt == nil || [_txtAmt.text isEqualToString:@""] || 0 == amt) {
        [self showAlertMessage:@"请输入金额"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    // 订单拼接
    IPNPreSignMessageUtil *preSign = [[IPNPreSignMessageUtil alloc] init];
    preSign.appId = _appId.text;
    preSign.mhtOrderNo = [formatter stringFromDate:[NSDate date]];
    preSign.mhtOrderName = _txtOrderNo.text;
    preSign.mhtOrderType = @"01";
    preSign.mhtCurrencyType = @"156";
    preSign.mhtOrderAmt = _txtAmt.text;
    preSign.mhtOrderDetail = _txtOrderDetail.text;
    preSign.mhtOrderStartTime = _txtOrderStartTime.text;
    preSign.notifyUrl = _notifyUrl.text;
    preSign.mhtCharset = @"UTF-8";
    preSign.mhtOrderTimeOut = @"3600";
    preSign.mhtReserved = _txtMhtPreserved.text;
    preSign.consumerId = @"IPN00001";
    preSign.consumerName = @"IPaynow";
    

    
    if (payChannelType != nil) {
        preSign.payChannelType = payChannelType;
    }
    
    _presignStr = [preSign generatePresignMessage];
    
    
    if (_presignStr == nil) {
        [self showAlertMessage:@"缺少必填字段"];
        return;
    }
    
    _orderNo = preSign.mhtOrderNo;
    [self payByLocalSign];
}

/**
 *   订单签名该由服务器完成，此处本地签名仅作为展示使用。
 */
- (void)payByLocalSign{
    NSString *md5 = [IPNDESUtil md5Encrypt:_appKey.text];
    md5 = [_presignStr stringByAppendingFormat:@"&%@",md5];
    md5 = [IPNDESUtil md5Encrypt:md5];
    md5 = [NSString stringWithFormat:@"mhtSignType=MD5&mhtSignature=%@",md5];
    NSString *payData = [_presignStr stringByAppendingFormat:@"&%@",md5];
    [IpaynowPluginApi pay:payData AndScheme:@"IPaynowPluginSDK" viewController:self delegate:self];
}

#pragma mark - SDK的回调方法
- (void)iPaynowPluginResult:(IPNPayResult)result errorCode:(NSString *)errorCode errorInfo:(NSString *)errorInfo{
    NSString *resultString = @"";
    switch (result) {
        case IPNPayResultFail:
            resultString = [NSString stringWithFormat:@"支付失败:\r\n错误码:%@,异常信息:%@",errorCode, errorInfo];
            break;
        case IPNPayResultCancel:
            resultString = @"支付被取消";
            break;
        case IPNPayResultSuccess:
            resultString = @"支付成功";
            break;
        case  IPNPayResultUnknown:
            resultString = [NSString stringWithFormat:@"支付结果未知:%@",errorInfo];
        default:
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kNote
                                                        message:resultString
                                                       delegate:self
                                              cancelButtonTitle:kConfirm
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - 支付发起AlertView

- (void)showAlertMessage:(NSString *)message{
    _mAlert = [[UIAlertView alloc] initWithTitle:kNote message:message delegate:self cancelButtonTitle:kConfirm otherButtonTitles:nil];
    [_mAlert show];
}

- (void)showAlertWait{
    _mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_mAlert show];
    UIActivityIndicatorView *indictor = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indictor.center = CGPointMake(_mAlert.frame.size.width / 2.0f - 15, _mAlert.frame.size.height / 2.0f + 10 );
    [indictor startAnimating];
    [_mAlert addSubview:indictor];
}

- (void)hideAlert{
    if (_mAlert != nil) {
        [_mAlert dismissWithClickedButtonIndex:0 animated:YES];
        _mAlert = nil;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 创建UI界面
- (void)createUI{
    [self.navigationItem setTitle:@"微信独立包测试Demo"];
    [self addLabelWithY:95 text:@"应用ID:" andFontSize:13];
    [self addLabelWithY:133 text:@"应用秘钥:" andFontSize:13];
    [self addLabelWithY:171 text:@"订单名称:" andFontSize:13];
    [self addLabelWithY:209 text:@"订单金额(分):" andFontSize:13];
    [self addLabelWithY:247 text:@"订单详情:" andFontSize:13];
    [self addLabelWithY:285 text:@"订单开始时间:" andFontSize:13];
    [self addLabelWithY:323 text:@"后台通知地址:" andFontSize:13];
    [self addLabelWithY:360 text:@"商户保留域:" andFontSize:13];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    _appId = [self addTextFieldWithY:91 text:@"1408709961320306" keyboardType:UIKeyboardTypeDecimalPad];
    _appKey = [self addTextFieldWithY:129 text:@"0nqIDgkOnNBD6qoqO5U68RO1fNqiaisg" keyboardType:UIKeyboardTypeDefault];
    _txtOrderNo = [self addTextFieldWithY:167 text:@"merchantTest" keyboardType:UIKeyboardTypeDefault];
    _txtAmt = [self addTextFieldWithY:205 text:@"1" keyboardType:UIKeyboardTypeDecimalPad];
    _txtOrderDetail = [self addTextFieldWithY:243 text:@"mhtOrderDetail" keyboardType:UIKeyboardTypeDefault];
    _txtOrderStartTime = [self addTextFieldWithY:281 text:[dateFormatter stringFromDate:[NSDate date]] keyboardType:UIKeyboardTypeDecimalPad];
    _notifyUrl = [self addTextFieldWithY:319 text:@"http://localhost:10802/" keyboardType:UIKeyboardTypeDefault];
    _txtMhtPreserved = [self addTextFieldWithY:357 text:@"" keyboardType:UIKeyboardTypeDefault];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(20.0f, 400 * COEFFICIENT, self.view.frame.size.width - 40.0f, 60.0f);
    payButton.layer.cornerRadius = 4.0f;
    payButton.layer.masksToBounds = YES;
    [payButton setTitle:@"微信支付" forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor colorWithRed:81.0f/255.0f green:141.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    [payButton addTarget:self action:@selector(startPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
}

#pragma mark - About UI
- (void)addLabelWithY:(CGFloat)y text:(NSString *)text andFontSize:(CGFloat)size{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(38 * COEFFICIENT, y, 91, 21)];
    lable.text = text;
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:size];
    [self.view addSubview:lable];
}

- (UITextField *)addTextFieldWithY:(CGFloat)y text:(NSString *)text keyboardType:(UIKeyboardType)type{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(143 * COEFFICIENT, y, 157, 30)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.text = text;
    textField.keyboardType = type;
    textField.font = [UIFont systemFontOfSize:14];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:textField];
    return textField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
