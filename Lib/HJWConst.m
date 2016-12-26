//
//  HJWConst.m
//  Fragment
//
//  Created by Lion_Lemon on 15/11/29.
//  Copyright © 2015年 Lion_Lemon. All rights reserved.
//
#import "HJWConst.h"

#pragma mark - 首页
/**
 *  引导图接口
 */
NSString * const Net_Splash = @"http://api2.pianke.me/pub/screen";
/**
 *  主页接口
 *  param  参数为limit、start
 *  return limit来控制返回的数据数 start每次以limit基数增加
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10"};
 */
NSString * const Net_Today = @"http://api2.pianke.me/pub/today";
/**
 *  文章详情接口
 *  param  参数为contentid
 *  return NSDictionary * dict = @{@"contentid":@"5647504d5d7743eb7c8b474e"};
 */
NSString * const Net_ArticleInfo = @"http://api2.pianke.me/article/info";
/**
 *  文章内容
 *  param  参数为contentid
 *  return 直接加载
 */
NSString * const Net_WebUrl = @"http://pianke.me/webview/%@";
/**
 *  音乐播放器接口
 *  param  参数为sid
 *  return sid/1769264039
 */
NSString * const Net_musicPlay = @"http://img.xiami.net/res/player/widget/singlePlayer.swf?dataUrl=http://www.xiami.com/widget/xml-single/uid/0/sid/%@";
/**
 *  音乐播放器接口
 *  param  参数为sid
 *  return sid/1769264039
 */
NSString * const Net_musicInfo = @"http://www.xiami.com/widget/xml-single/uid/0/sid/%@";

#pragma mark - 碎片
/**
 *  碎片(动态)接口
 *  param  参数为limit、start
 *  return limit来控制返回的数据数 start每次以limit基数增加
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10"};
 */
NSString * const Net_TimelineList = @"http://api2.pianke.me/timeline/list";
/**
 *  碎片详情接口
 *  param  参数为contentid
 *  return contentid=565844a15d774392718b4634
 */
NSString * const Net_TimelineInfo = @"http://api2.pianke.me/timeline/info";
/**
 *  碎片标签页接口
 */
NSString * const Net_tag = @"http://api2.pianke.me/timeline/tags";

#pragma mark - 电台FM
/**
 *  电台上拉接口
 */
NSString * const Net_Radio = @"http://api2.pianke.me/ting/radio";
/**
 *  电台下拉接口
 *  param  参数为limit、start
 *  return limit来控制返回的数据数 start每次以limit基数增加
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10"};
 */
NSString * const Net_RadioList = @"http://api2.pianke.me/ting/radio_list";
/**
 *  电台某一类列表接口
 *  param  参数为limit、start、radioid
 *  return limit来控制返回的数据数 start每次以limit基数增加 radioid=545b4e758ead0e4a06000041
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", @"radioid":@"545b4e758ead0e4a06000041"};
 */
NSString * const Net_RadioDetail = @"http://api2.pianke.me/ting/radio_detail";
/**
 *  电台详情接口
 *  param  参数为tingid
 *  return tingid=56581288723125d3178b461b
 */
NSString * const Net_RadioInfo =  @"http://api2.pianke.me/ting/info";
/**
 *  电台具体描述页面
 *  param  参数为ting_contentid
 *  return 5663dcb45d7743d37c8b4712
 */
NSString * const Net_TingInfo = @"http://pianke.me/webview/%@";
#pragma mark - 阅读
/**
 *  阅读列表接口
 */
NSString * const Net_ReadColumns = @"http://api2.pianke.me/read/columns";
/**
 *  阅读某一类列表接口
 *  param   参数为limit、sort、start、typeid
 *  return limit来控制返回的数据数 start每次以limit基数增加 sort分为addtime和hot分别代表<最近>和<热门>  typeid代表哪一类
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", @"sort":@"addtime", @"typeid":@"1"};
 */
NSString * const Net_ReadDetail = @"http://api2.pianke.me/read/columns_detail";
/**
 *  自由写作接口
 *  param   参数为limit、sort、start
 *  return limit来控制返回的数据数 start每次以limit基数增加 sort分为addtime和hot分别代表<最近>和<热门>
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", @"sort":@"addtime"};
 */
NSString * const Net_ReadLatest = @"http://api2.pianke.me/read/latest";

#pragma mark - 社区-----话题
/**
 *  话题主页接口
 *  param   参数为limit、sort、start
 *  return limit来控制返回的数据数 start每次以limit基数增加 sort分为addtime和hot分别代表<最近>和<热门>
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", @"sort":@"addtime"};
 */
NSString * const Net_PostsHotList = @"http://api2.pianke.me/group/posts_hotlist";
/**
 *  话题详情接口
 *  param  参数为contentid
 *  return contentid = 56581288723125d3178b461b;
 */
NSString * const Net_PostsInfo = @"http://api2.pianke.me/group/posts_info";

#pragma mark - 社区-----小组
/**
 *  小组主页接口
 *  param  参数为limit、sort、start
 *  return limit来控制返回的数据数 start每次以limit基数增加 sort分为addtime和hot分别代表<最近>和<热门>
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", @"sort":@"addtime"};
 */
NSString * const Net_GroupList = @"http://api2.pianke.me/group/group_list";
/**
 *  小组详情接口
 *  param  参数为groupid
 *  return groupid = 54d1aa629ea288bd18000127;
 */
NSString * const Net_GroupInfo = @"http://api2.pianke.me/group/group_info";

#pragma mark - 良品
/**
 *  良品接口
 *  param  参数为limit、start
 *  return limit来控制返回的数据数 start每次以limit基数增加
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10"};
 */
NSString * const Net_Shop = @"http://api2.pianke.me/pub/shop";
/**
 *  良品详情接口
 *  param  参数为contentid
 *  return contentid = 55eef064723125d2668b45a2;
 直接调用 话题详情接口，将参数传过去就可以了
 */

#pragma mark - 更多评论
/**
 * 更多评论接口
 * param  参数为limit、sort、start、contentid
 * return limit来控制返回的数据数 start每次以limit基数增加 sort为排列的顺序
 NSDictionary * dict = @{@"limit":@"10", @"start":@"10", sort=@"desc", contentid = 55eef064723125d2668b45a2};
 */
NSString * const Net_Comment = @"http://api2.pianke.me/group/posts_comment";
