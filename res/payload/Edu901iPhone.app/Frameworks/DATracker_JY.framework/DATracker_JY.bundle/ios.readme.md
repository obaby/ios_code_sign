# iOS SDK 使用文档 #

## 依赖库 ##

* AdSupport.framework - 启用 Apple ADID 支持
* CoreTelephony.framework - 获取运营商
* Security.framework - 加密支持
* SystemConfiguration.framework - 获取联网方式(wifi, cellular)
* libsqlite3.dylib - sqlite 支持
* libz.dylib - gzip 压缩支持

**路径：TARGETS -> Build Phases -> Link Binary With Libraries**

## 导入 SDK ##

将下载包里面 DATracker.h, libMobilytics.a 文件添加到 App 项目中

## 启用 API ##

在 `*AppDelegate.m` `application:didFinishLaunchingWithOptions` 方法中调用如下方法，参数依次为 app key，版本和来源渠道。

    [[DATracker sharedTracker] startTrackerWithAppKey:@"app-key" appVersion:@"0.1" appChannel:@"AppStore"];

如需要禁用 SDK 自动上传数据功能，调用

    [[DATracker sharedTracker] startTrackerWithAppKey:@"app-key" appVersion:@"0.1" appChannel:@"AppStore" autoUpload:NO];

如需要设置只在 wifi 环境下发送数据，调用

    [[DATracker sharedTracker] startTrackerWithAppKey:@"app-key" appVersion:@"0.1" appChannel:@"AppStore" autoUpload:YES sendOnWifi:YES];

**设置为只在 WIFI 下发送数据，会导致服务器接收数据延迟，对统计系统结果的及时性会产生影响，不建议使用**

如需要使用自定义设备标识（比如 UDID），调用

    [[DATracker sharedTracker] startTrackerWithAppKey:@"app-key" appVersion:@"0.1" appChannel:@"AppStore" autoUpload:YES sendOnWifi:NO deviceUDID:@"id-set-by-app"];

**App Key 可从移动分析系统网站获取，不得使用为空值或者 null**

**以下所有调用均需发生在 `启用 API` 之后**

--------------------------

**手动发送数据请调用**

    [[DATracker sharedTracker] upload];

**手动禁用自动上传**

    [[DATracker sharedTracker] setAutoUploadOn:NO];

**手动开启只在 WIFI 下发送数据**

    [[DATracker sharedTracker] setSendOnWifiOn:YES];

## 推广跟踪 ##

紧跟 `启用 API` 后调用

    [[DATracker sharedTracker] enableCampaign];

## 获取 Device ID ##

    [[DATracker sharedTracker] getDeviceId];

**该 Device ID 并非 Apple UDID, 仅用户系统本身设备去重用途, 并且可能根据 Apple 政策做相应调整, 不保证长期唯一性**

## 用户帐号管理 ##

在用户登录后，请调用如下接口，参数为用户帐号

    - (void)loginUser:(NSString *)userId;

当用户登出后，请调用

    - (void)logoutUser;

**如登录发生在需要捕捉事件后，则该事件无用户信息**

## 用户位置记录 ##

在拿到用户经纬度时, 调用如下接口记录用户位置

    - (void)setLocation:(double)latitude andLongitude:(double)longitude

## 事件捕捉 ##

调用如下方法进行事件捕捉

    - (void)trackEvent:(NSString *)eventId;
    - (void)trackEvent:(NSString *)eventId withAttributes:(NSDictionary *)attributes;

eventId 为事件标识，如 "login", "buy"

    [[DATracker sharedTracker] trackEvent:@"buy"];

attributes 为自定义字段名称，格式如 "{@"money":@"100", @"timestamp":@"1357872572"}"

可对事件发生时的其他信息进行记录

    [[DATracker sharedTracker] trackEvent:@"login"
	    withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:@"100", @"money", nil]];

还可以对事件进行归类和打标签

    - (void)trackEvent:(NSString *)eventId cagtegory:(NSString *)category label:(NSString *)label;
    - (void)trackEvent:(NSString *)eventId cagtegory:(NSString *)category label:(NSString *)label withAttributes:(NSDictionary *)attributes;

如果需要记录事件发生持续时间，可调用如下接口

    - (void)trackEvent:(NSString *)eventId costTime:(int)seconds category:(NSString *)category label:(NSString *)label;
    - (void)trackEvent:(NSString *)eventId costTime:(int)seconds category:(NSString *)category label:(NSString *)label withAttributes:(NSDictionary *)attributes;

如果需要记录事件发生时的位置信息, 可调用如下接口

    - (void)trackEvent:(NSString *)eventId costTime:(int)seconds latitude:(double)latitude longitude:(double)longitude category:(NSString *)category label:(NSString *)label withAttributes:(NSDictionary *)attributes;

以上事件记录只能记录用户会话内的行为, 如果需要记录用户会话外行为, 比如 `applicationWillEnterForeground` 之前 App 的行为, 可调用如下接口 (mustInSession=false)

    - (void)trackEvent:(NSString *)eventId costTime:(int)seconds latitude:(double)latitude longitude:(double)longitude category:(NSString *)category label:(NSString *)label withAttributes:(NSDictionary *)attributes mustInSession:(BOOL)mustInSession;

如需要捕捉的事件具有层级结构，请调用如下接口

    - (void)trackEvent:(NSString *)eventId costTime:(int)seconds withMultipleCategories:(NSString *)primaryId, ... NS_REQUIRES_NIL_TERMINATION;

    [tracker trackEvent:@"eventId" costTime:0 withMultipleCategories:@"cat1", @"var1", @"cat2", @"var2", @"cat3", @"var3", @"cat4", @"var4", nil];

**层级结构需要实现在移动分析系统内部设置，才可使用, 层级结构按从高到低依次填写，比如 主题 id， 主题名，咨询源 id，咨询源名，新闻 id，新闻名 ...**

**事件捕捉调用虽然可以使用在任何地方，但最好不要在较多循环内或者非主线程中调用，以及最好不要使用很长 eventID 或者 key value 值，否则会增加 SDK 发送的数据量**

## 异常捕捉 ##

可以在 try catch block 中进行异常捕捉，传入参数为 NSException (含子类)实例

    @try {
        [@"str" characterAtIndex:10];
    }
    @catch (NSException *exception) {
        [[DATracker sharedTracker] trackException:exception];
    }

如还需要记录 Callstack，可调用

    [[DATracker sharedTracker] trackExceptionWithCallstack:exception];

如需要手动指定异常信息，可调用

    [[DATracker sharedTracker] trackExceptionWithName:@"exception" reason:@"some reason" callstack:@"long callstack"];

如需要 crash 捕捉, 需要在启用 SDK 后尽早调用如下方法来开启该功能, 并确保 App 中没有绑定过 signal 和 uncaught exception handler

- (void)enableCrashReporting;

## 屏幕 View 捕捉 ##

screenName 为当前 View 名称

    - (void)trackScreen:(NSString *)screenName;

## 搜索动作捕捉 ##

keyword 为搜索关键词，searchType 为搜索类型，比如新闻搜索，视频搜索等

    - (void)trackSearch:(NSString *)keyword in:(NSString *)searchType;

## 分享动作捕捉 ##

content 为分享内容，from 为分享发生地，to 为分享目的地，比如新浪微博，网易微博等

    -(void)trackShare:(NSString*)content from:(NSString *)from to:(NSString *)to;

## 用户任务记录 ##

对用户的任务进行记录，参数为任务 id 和任务失败原因，可用于用户行为完成，用户行为耗时等统计。

    [[DATracker sharedTracker] trackOnMissionBegan:@"mission-1"];
    [[DATracker sharedTracker] trackOnMissionAccomplished:@"mission-1"];
    [[DATracker sharedTracker] trackOnMissionFailed:@"mission-2" reason:@"no power"];
