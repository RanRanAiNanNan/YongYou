//  接口链接地址
//  B.swift
//  ydzbapp-hybrid
//
//  Created by 刘驰 on 15/3/1.
//  Copyright (c) 2015年 银多资本. All rights reserved.
//

import Foundation
import UIKit


struct B {
    
//    static let BASE_URL = "http://121.43.118.86:15522/Member/"
//    static let BASE_URL = "http://123.57.32.68:15520/Member/"
//    static let BASE_URL = "http://218.244.133.47:15522/Member/"
//    static let BASE_URL = "https://www.yinduoziben.com/api/Member/"
////    static let BASE_URL = "http://192.168.0.106:15520/Member/"
//    static let BASE_URL = "http://192.168.0.222/Member/"
    
    
      static let BASE_URL = "http://121.40.92.117:8777/api"
    
//    static let BASE_URL = "http://192.168.1.88:8080/api"
    
//    static let BASE_WEB_URL = "http://121.40.92.117:90/"
//    static let BASE_WEB_URL = "http://123.57.32.68:901/"
    static let BASE_WEB_URL = "http://m.yinduoziben.com/"
    
    /** 服务协议基础地址 **/
    static let SERVICE_CONTRACT_BASE = "http://www.yinduoziben.com/Public/pdf/"
    /** 推荐分享 注册地址 **/
    static let SOCIAL_REGISTER_ADDRESS = "http://wx.yinduoziben.com/index.php/Member/Public/register/code/"
    /** 宝付充值地址 **/
    static let RECHARGE_ADDRESS = BASE_WEB_URL + "index.php/Member/Fund/index/mm/"
    /** 产品理财 用户推荐地址 **/
    static let FINANCE_USERRECOMMEND_ADDRESS = BASE_WEB_URL + "index.php/Member/Claim/user_recommendation/mm"
    /** 资产 基金投资 **/
    static let ASSEST_FUNDINVESTMENT_ADDRESS = BASE_WEB_URL + "index.php/Member/Fund/index/mm/"
    /** 收益分享 收益地址 **/
    static let SOCIAL_REVENUE_ADDRESS = BASE_WEB_URL + "index.php/Member/Claim/share"
    /** 帮助中心地址 **/
    static let HELPCENTER_ADDRESS = BASE_WEB_URL + "index.php/Member/Claim/qa"
    
    
    /** VIP规则页面 **/
    static let ROLE_VIP = BASE_WEB_URL + "index.php/Member/Claim/vip_rule"
    /** 分享规则页面 **/
    static let ROLE_SHARE = BASE_WEB_URL + "index.php/Member/Claim/share_rule"
    /** 推荐规则页面 **/
    static let ROLE_RECOMMEND = BASE_WEB_URL + "index.php/Member/Claim/recommend_rule"
    /** 债权转让页面 **/
    static let ROLE_TRANSFER = BASE_WEB_URL + "index.php/Member/Claim/transfer_rule"
    /** 提现规则页面 **/
    static let ROLE_WITHDRAW = BASE_WEB_URL + "index.php/Member/Claim/withdraw_rule"
    /** 资讯本地页 **/
    static let ACTIVITY_INFORMATION = BASE_WEB_URL + "index.php/Member/Claim/news"
    
    
    
    /** 苹果商店应用ID **/
    static let APP_ID = "979099448"
    /** 苹果商店应用查询地址 **/
    static let STORE_QUERY_ADDRESS = "http://itunes.apple.com/cn/lookup?id="
    /** 苹果商店应用下载地址 **/
    static let STORE_DOWNLOAD_ADDRESS = "https://itunes.apple.com/cn/app/yin-duo-zi-ben/id"
    /** 客服头像地址 **/
    static let KEFU_AVATAR_LINK = "https://www.yinduoziben.com/Public/new/images/i/a60.png"
    /** 网络连接文字 **/
    static let NETWORK_CONNECTION_ABNORMAL = "网络连接异常,请检验您的网络连接"
    /** 融云APPKEY **/
    static let RONGCLOUD_APP_KEY = "ik1qhw091efap"
    /** 融云客服ID **/
    static let RONGCLOUD_CUSTOMER_ID = "KEFU1432719513161"
    /** 友盟APPKEY **/
    static let UMENG_APP_KEY = "5731a39f67e58e2ae8000767"
    /** 微信APPKEY **/
    static let WX_APP_ID = "wx500b5aa1a5178c53"
    /** 微信APPKEY **/
    static let WX_APP_KEY = "c71b0745196389538eda6852085af428"
    /** 新浪APPKEY **/
    static let SINA_APP_ID = "443686092"
    /** 新浪APP SECRET */
    static let SINA_APP_SECRET = "e8d7691436b64e260094b30259e49279"
    /** 新浪APP回调URL  */
    static let SINA_APP_CALLBACK = "http://sns.whalecloud.com/sina2/callback"
    /** QQ APPID **/
    static let QQ_APP_ID = "1104711683"
    /** QQ APPKEY **/
    static let QQ_APP_KEY = "1RhBOrsb0NnstF7V"
    /* 美洽客服KEY */
    static let MEIQIA_APP_KEY = "346f1ac6413185aef28bdabbf3bfceed"
    /* 美洽客服SECRET */
    static let MEIQIA_APP_SECRET = "$2a$12$2tZaQ57LKt65W2ovN/7wdOMsFwh26g8cFR8EnXr4teSTXZ31J0EC."

    /** 友盟推送 APPKEY **/
    static let UMENG_MESSAGE_KEY = "5731a39f67e58e2ae8000767"
    
    static let MOBILE_ENCRYPT_STR = "yinduoziben_dev_jiami"
    
    static let SING = "3e9bb86c6980c3b79e5b936ce10b9b96"
    /** 注册，登录，view边线颜色 **/
    static let RL_VIEW_BRODER_COLOR = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).CGColor
    /** 字体颜色 **/
    static let GP_VIEW_BG = UIColor(red: 26/255, green: 44/255, blue: 56/255, alpha: 1)
    /** 字体颜色 **/
    static let WORD_COLOR = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
    /** 字体颜色 **/
    static let YELLOW_FONT = UIColor(red: 255 / 255, green: 181 / 255, blue: 76 / 255, alpha: 1)
    /** 文本框提示字颜色 **/
    static let WORD_HINT_COLOR = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    /** 按钮选中颜色 **/
    static let BTN_SELECTED = UIColor(red: 255/255, green: 181/255, blue: 76/255, alpha: 1)
    /** 按钮未选中颜色 **/
    static let BTN_NO_SELECTED = UIColor(red: 63/255, green: 82/255, blue: 102/255, alpha: 1)
    /** 按钮金色 **/
    static let BTN_GOLDEN_COLOR = UIColor(red: 190/255, green: 158/255, blue: 118/255, alpha: 1)
    /** 标题栏颜色 **/
    static let NAV_BG = UIColor(red: 90/255, green: 94/255, blue: 109/255, alpha: 1)
    /** 标题栏字体颜色 **/
    static let NAV_TITLE_CORLOR = UIColor(red: 207/255, green: 174/255, blue: 120/255, alpha: 1)
    /** 视图背景颜色 **/
    static let VIEW_BG = UIColor(red: 247.0/255, green: 247.0/255, blue: 247.0/255, alpha: 1)
    /** 视图背景颜色 **/
    static let VIEW_BG1 = UIColor(red: 247/255, green: 247.0/255, blue: 247.0/255, alpha: 1)
    /** 导航颜色 **/
    static let TABBAR_BG = UIColor(red: 0/255, green: 171/255, blue: 155/255, alpha: 1)
    /** tab导航底线未选中颜色 **/
    static let TAB_NO_SELECTED = UIColor(red: 98/255, green: 102/255, blue: 112/255, alpha: 1)
    /** tab导航底线未选中颜色 **/
    static let TAB_NO_SELECTED_WORD = UIColor(red: 255/255, green: 210/255, blue: 148/255, alpha: 1)
    /** tab导航底线选中颜色 **/
    static let TAB_SELECTED = UIColor(red:207/255, green: 174/255, blue: 120/255, alpha: 1)
    /** tableview背景颜色 **/
    static let TABLEVIEW_BG = UIColor(red: 247.0/255, green: 247.0/255, blue: 247.0/255, alpha: 1)
    /** 推荐列表背景 **/
    static let RECOMMEND_TABLEVIEW_BG = UIColor(red: 239.0/255, green: 239.0/255, blue: 239.0/255, alpha: 1)
    /** 活动的tableview cell 背景颜色 **/
    static let ACTIVITY_CELL_BG = UIColor(red: 221.0/255, green: 221.0/255, blue: 221.0/255, alpha: 1)
    /** 分类按钮导航 **/
    static let CATEGORY_BUTTON_BG = UIColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1)
    /** 过滤menu未选中时的字体颜色 **/
    static let MENU_NORMAL_FONT_COLOR = UIColor(red: 149.0/255, green: 149.0/255, blue: 149.0/255, alpha: 1)
    /** 过滤menu选中时的字体颜色 **/
    static let MENU_SELECTED_FONT_COLOR = UIColor(red: 190.0/255, green: 158.0/255, blue: 118.0/255, alpha: 1)
    /** 过滤menu分割线颜色 */
    static let MENU_SEPRATOR_COLOR = UIColor(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1)
    /** 过滤menu背景颜色 */
    static let MENU_BG_COLOR = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1)
    /** 购买界面咖啡色字体 **/
    static let BUY_COFFEE_TEXT_COLOR = UIColor(red: 190.0/255, green: 158.0/255, blue: 118.0/255, alpha: 1)
    /** 购买界面灰色字体 **/
    static let BUY_GRAY_TEXT_COLOR = UIColor(red: 149.0/255, green: 149.0/255, blue: 149.0/255, alpha: 1)
    /** 列表灰色字体颜色 **/
    static let LIST_GRAY_TEXT_COLOR = UIColor(red: 96.0/255, green: 96.0/255, blue: 96.0/255, alpha: 1)
    /** 列表黄色字体颜色 **/
    static let LIST_YELLOW_TEXT_COLOR = UIColor(red: 190.0/255, green: 158.0/255, blue: 118.0/255, alpha: 1)
    /** 列表灰色背景颜色 **/
    static let LIST_GRAY_BG_COLOR = UIColor(red: 215.0/255, green: 215.0/255, blue: 215.0/255, alpha: 1)
    /** 可购买按钮颜色 **/
    static let BUY_ENABLE_BUTTON_BG = UIColor(red: 63.0/255, green: 82.0/255, blue: 102.0/255, alpha: 1)
    /** 不可购买按钮颜色 **/
    static let BUY_DISABLE_BUTTON_BG = UIColor(red: 149.0/255, green: 149.0/255, blue: 149.0/255, alpha: 1)
    static let VIP_COLOR = UIColor(red: 235.0/255, green: 84.0/255, blue: 75.0/255, alpha: 1)
    /** 推荐列表cell颜色灰 **/
    static let RECOMMEND_CELL_COLOR = UIColor(red: 233.0/255, green: 232.0/255, blue: 232.0/255, alpha: 1)
    /** 拥有字体颜色 **/
    static let YONGYOU_TEXT = UIColor(red: 94.0/255, green: 96.0/255, blue: 102.0/255, alpha: 1)

    /********************* 距离 ***************************/
    /** 屏幕宽度 **/
    static let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    /** 屏幕高度 **/
    static let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    /** 用户中心过滤menu高度 **/
    static let MENU_FLITER_HIGHT = CGFloat(50)

    
    
    /********************* 其他 ***************************/
    /** 上传用户版本号 **/
    static let OTHER_UPLOAD_USER_VERSION = "Public/lock"
    /** 检查用户是否允许登录 **/
    static let CHECK_USER_LOGIN = "Public/isLock"
    /********************* 服务协议地址 ***************************/
    /** 服务协议2.0 **/
    static let SERVICE_CONTRACTM_20 = "活期宝居间服务协议.pdf"
    /** 服务协议2.0M **/
    static let SERVICE_CONTRACT_2M = "定存宝居间服务协议.pdf"
    /** 服务协议股票配资 **/
    static let SERVICE_PEIZI = "股票配资债权投资咨询与管理服务协议.pdf"
    /** 服务协议股权众筹 **/
    static let SERVICE_JUMU = "高端理财—股权众筹投资咨询与管理服务协议.pdf"
    /** 服务协议债权转让 **/
    static let SERVICE_TRANSFER = "定存宝居间服务协议.pdf"
    /** 服务协议私人定制 **/
    static let SERVICE_PRIVATEORDER = "私人订制居间服务协议.pdf"
    /** 服务注册协议 **/
    static let SERVICE_REGISTER = "银多资本网站服务协议.pdf"

    /********************* 首页 ***************************/
    
    /** 是否有未读站内信 **/
    static let HOME_USER_MESSAGE = "Message/num/mobile/"
    /** 用户信息 **/
    static let HOME_USER_DATA = "Index/index"
    /** 提现检查 **/
    static let WITHDRAW_CHECK = "Common/checkInfo"
    /** 提现获取到账金额**/
    static let HOME_ACCOUNTMONEY = "Baoyi/getAccountMoney"
    /** 提现提交 **/
    static let HOME_WITHDRAW = "Baoyi/withdraw"
    /** 充值首页 **/
    static let RECHARGE_HOME = "Baoyi/recharge"
    /** 充值 获取订单号 **/
    static let RECHARGE_ORDER = "Baoyi/getOrder"
    /** 添加银行卡 **/
    static let BANKCARD_AUTH = "Baoyi/auth"
    /** 添加银行卡 验证码 **/
    static let BANKCARD_AUTHCODE = "Baoyi/getAuthCode"
    /** 添加银行卡 获取订单号 **/
    static let BANKCARD_ORDER = "Baoyi/getAuthOrder"
    /** 充值检查 **/
    static let RECHARGE_CHECK = "Common/checkPayPaypassword"
    /** 充值验证码 **/
    static let RECHARGE_AUTHCODE = "Baoyi/getRechargeCode"
    /** 充值地址 **/
    static let RECHARGE_POST = "recharge/mobile/"
    /** 活动地址 **/
    static let ACTIVITY_LIST = "Activity/index"
    /** 累积收益 **/
    static let HOME_TOTAL_EARNINGS_RECORD = "Record/totalEarnings"
    /** 首页列表中 稳进宝 期目 记录**/
    static let STABLE_PERIOD_LIST = "Record/stableDeal/mobile/"
    /** 点击 稳进宝 条目记录后的 列表**/
    static let STABLE_PERIOD_DETAIL = "Record/stable/mobile/"
    /********************* 银多理财 ***************************/
    
    /** 银多理财天标首面 **/
    static let YDLC_DAYLOAN_MAIN = "Dayloan/index"
    /** 银多理财定存首面 **/
    static let YDLC_DEPOSIT_MAIN = "Deposit/index"
    /** 银多理财天标购买 **/
    static let YDLC_DAYLOAN_BUY = "Dayloan/buy"
    /** 银多理财定存购买 **/
    static let YDLC_DEPOSIT_BUY = "Deposit/buy"
    /** 银多理财天标赎回交易密码判断 **/
    static let YDLC_DAYLOAN_REDEEM = "Common/checkPayPaypassword"
    /** 银多理财天标赎回 **/
    static let YDLC_DAYLOAN_OVER = "Dayloan/over"
    /** 债权转让列表 **/
    static let YDLC_DEPOSIT_OVER = "Deposit/over"
    /** 债权转让列表购买 **/
    static let YDLC_DEPOSIT_TRANSFER_BUY = "Deposit/transfer"
    /** 银多理财天标预投 **/
    static let YDLC_DAYLOAN_PREPAY = "Dayloan/prepay"
    /** 银多理财定存已购产品列表 **/
    static let YDLC_DEPOSIT_LISTS = "Deposit/lists"
    /** 银多理财定存已购产品全部列表 **/
    static let YDLC_DEPOSIT_WHOLE = "Deposit/whole"
    /** 银多理财定存交易记录 **/
    static let YDLC_DEPOSIT_RECORD = "Record/deposit"
    /** 银多理财定存已购产品详情 **/
    static let YDLC_DEPOSIT_BUY_PRODUCT_DETAIL = "Deposit/show"
    /** 银多理财定存结息列表接口 **/
    static let YDLC_DEPOSIT_TRADE_RECORD = "Deposit/tradeRecord"
    /** 因多理财定存记录详情接口 **/
    static let YDLC_DEPOSIT_RECORD_DETAIL = "Record/depositShow"
    /** 银多理财定存 **/
    static let YDLC_DEPOSIT_TRANSFER = "Deposit/changeStatus"
    /** 银多理财定存已购产品设置本金复投状态 **/
    static let YDLC_DEPOSIT_BUY_PRODUCT_EXPIREMODE = "Deposit/changeExpireMode"
    /** 银多理财定存已购产品设置利息复投状态 **/
    static let YDLC_DEPOSIT_BUY_PRODUCT_INCOMEMODE = "Deposit/changeIncomeMode"
    /** 债权转让记录列表 **/
    static let YDLC_TRANSFER_RECORD_LIST = "Record/transfer"
    /** 活期 查看往期 **/
    static let YDZLC_DAYLOAN_SEEBEFORE = "History/index"
    /** 活期 查看往期 **/
    static let YDZLC_DAYLOAN_CURRENTPERIOD = "History/lists"
    /** 稳进宝记录列表 **/
    static let YDLC_STABLE_RECORD_LIST = "Record/stable"
    
    
    /********************* 安全中心 ***************************/
    
    /** 修改交易密码 忘记密码 **/
    static let SAFECENTER_TRADEPWD_FORGET = "Safety/forget"
    static let SAFECENTER_INDEX = "Safety/index"
    /** 紧急联系人 **/
    static let SAFECENTER_EMERGENCYCONTACTS = "Safety/urgent"
    
    /********************* 用户中心 ***************************/
    /** 用户中心 **/
    static let USERCENTER_MAIN = "Home/home"
    /** 用户帐号提醒 **/
    static let USERCENTER_REMIND = "Safety/lemind"
    /** 交易记录 天标 **/
    static let USERCENTER_FUNDRECORD_DAYLOAN = "Record/dayloan"
    /** 交易记录 定存 **/
    static let USERCENTER_FUNDRECORD_DEPOSIT = "Deposit/lists"
    /** 交易记录 聚募 **/
    static let USERCENTER_JUMURECORD = "Record/jumu"
    /** 交易记录 稳进宝 **/
    static let USERCENTER_STABLERECORD = "Record/stabilize"
    /** 头像上传 **/
    static let USERCENTER_AVATAR_UPLOAD = "Safety/avatar"
    /** 互联网理财地址 **/
    static let INTERNET_FINANCING = "Home/yinduo/mobile/"
    /** 红包列表 使用红包 **/
    static let USERCENTER_REDPACKET_LIST = "Redpacket/index"
    /** 红包列表 使用红包 **/
    static let USERCENTER_REDPACKET_GET = "Redpacket/drawRedpacket"
    /** 红包列表 使用红包 **/
    static let USERCENTER_REDPACKET_USE = "Redpacket/useRedpacket"
    /** 红包列表 活期宝 **/
    static let USERCENTER_REDPACKET_CURRENT_USE = "Redpacket/useCurrentRedpacket"
    /** 红包列表 现金 **/
    static let USERCENTER_REDPACKET_CASH_USE = "Redpacket/useCashRedpacket"
    /** 交易记录 关注列表 **/
    static let USERCENTER_FOLLOWRECORD = "Social/care_list"
    /** 交易记录 关注者列表 **/
    static let USERCENTER_INVIETRECORD = "Social/care_lists"
    /** 交易记录 关注/取消关注 **/
    static let USERCENTER_FOLLOW = "Social/care"
    /** 安全保障 债权列表 **/
    static let USERCENTER_SAFEGUARD_INVEST_LIST = "Claim/invest"
    /** 安全保障 平台列表 **/
    static let USERCENTER_SAFEGUARD_PLATFORM_LIST = "Claim/platform"
    /** 安全保障 总数 **/
    static let USERCENTER_SAFEGUARD_TOTAL = "Claim/total"
    /** 用户中心 推荐列表 **/
    static let USERCENTER_RECOMMEND_LIST = "Recommend/lists"
    /** 用户中心 内部转账 **/
    static let USERCENTER_INTERIOR_TRANSFER = "Interior/transfer"
    /** 用户中心 内部转账 转入记录 **/
    static let USERCENTER_INTO_TRANSFER_LIST = "Interior/transferIn"
    /** 用户中心 内部转账 转出记录 **/
    static let USERCENTER_OUT_TRANSFER_LIST = "Interior/transferOut"
    /** 实名认证 **/
    static let CHECK_ID_CARD = "Common/checkIdCard"
    /** 公告消息详情 **/
    static let USERCENTER_NOTICE_SHOW = "Message/show"
    
    /********************* 配资 ***************************/
    /** 随机配资数据 **/
    static let PEIZI_RANDOM_DATA = "Matchstock/index"
    /** 随机配资购买 **/
    static let PEIZI_COMMIT_DATA = "Matchstock/buy"
    /** 按天配资购买 **/
    static let PEIZI_DAY_BUY = "Matchstock/dayBuy"
    /** 按月配资购买 **/
    static let PEIZI_MONTH_BUY = "Matchstock/monthBuy"
    /** 配资交易列表 **/
    static let PEIZI_LIST_DATA = "Matchstock/lists"
    /** 配资排行榜 **/
    static let PEIZI_LIST_TOP = "Matchstock/top"
    /** 配资购买产品详细 **/
    static let PEIZI_LIST_DETAIL = "Matchstock/show"
    /********************* 高端理财 ***************************/
    /** 债权列表 **/
    static let ADVANCED_TRANSFER_LIST = "Advanced/transfer/index"
    /** 聚募列表 **/
    static let ADVANCED_JUMU_LIST = "Advanced/jumu"
    /** 债权详细 **/
    static let ADVANCED_TRANSFER_DETAIL = "Deposit/transfer"
    /** 聚募详细 **/
    static let ADVANCED_JUMU_DETAIL = "Jumu/index"
    /** 高端理财列表 **/
    static let ADVANCED_PRODCUT_LIST = "Product/index"
    /********************* 财富圈 ***************************/
    /** 实时交易信息**/
    static let WEALTH_REALTIME_LIST = "Top/index"
    /** 投资排行**/
    static let WEALTH_INVEST_LIST = "Top/deal"
    /** 关注人投资信息 **/
    static let WEALTH_TARENTO_DETAIL = "Top/show"
    /********************* 自主投资 ***************************/
    /** 加载未确认列表 **/
    static let AUTOINVEST_NO_LIST = "Trade/index"
    /** 加载已确认列表 **/
    static let AUTOINVEST_YES_LIST = "Trade/lists"
    /** 购买 **/
    static let AUTOINVEST_BUY = "Trade/buy"
    /********************* 注册忘记密码 ***************************/
    /** 注册提交 **/
    static let REGISTER_POST = "Public/register"
    /** 注册验证码 **/
    static let REGISTER_SEND_AUTHCODE = "Common/sendRegisterCode"
    /** 忘记密码验证码 **/
    static let FYP_SEND_AUTHCODE = "Common/sendForgetCode"
    /** 忘记密码提交 **/
    static let FYP_POST = "Public/forget"
    /********************* 资产 ***************************/
    /** 资产首页 **/
    static let ASSEST_MAIN = "Home/index"
    /** 资产银行卡 **/
    static let ASSEST_RECHARGE_BANKCARD = "Safety/bank"
    /** 修改默认银行卡 **/
    static let BANKCARD_UPDATE_DEFAULT = "Safety/editBank"
    /** 删除银行卡 **/
    static let BANKCARD_DELETE = "Safety/delBank"
    /** 总资产 **/
    static let ASSEST_TOTALFUND = "History/assetRatio"
    /** 资产分配 **/
    static let ASSEST_TOTALFUNDS = "Home/allocation"
    /** 收益分享 **/
    static let ASSEST_REVENUE_SHARE = "History/share"
    /** 昨日收益详情 **/
    static let ASSEST_YESTERDAY_TOTAL = "History/yesterday"
    /** 分享给券 **/
    static let ASSEST_REVENUE_REDPACKET = "Redpacket/updateShare"
    /** 我的体验金 **/
    static let ASSEST_MY_EXPERIENCE_RECORD = "Record/exp"
    /** 体验金记录 **/
    static let ASSEST_EXPERIENCE_RECORD = "Record/expmoney"
    /** 我的消息记录 **/
    static let ASSEST_MESSAGE_RECORD = "Message/index"
    /** 删除消息 **/
    static let ASSEST_MESSAGE_DELETE = "Message/del"
    /** 昨日收益 **/
    static let ASSEST_YESTERDAY_INCOME_RECORD = "Record/yesterday"
    /** 累计收益 **/
    static let ASSEST_TOTAL_INCOME_RECORD = "Record/total"
    /** 充值记录 **/
    static let ASSEST_RECHARGE_RECORD = "Record/recharge"
    /** 提现记录 **/
    static let ASSEST_WITHDRAW_RECORD = "Record/withdraw"
    /** 冻结记录 **/
    static let ASSEST_DONGJIE_RECORD = "Record/bloked"

    
}