package
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	import flash.utils.getTimer;


	/**
	 *  时间都是毫秒
	 * @author mani
	 */
	public class UMSocial extends EventDispatcher
	{
		// UMShareToSina, UMShareToTencent, UMShareToRenren, UMShareToDouban , UMShareToQzone  , UMShareToEmail  , UMShareToSms  , UMShareToWechatSession  , UMShareToWechatTimeline  ,UMShareToWechatFavorite  , UMShareToQQ  , UMShareToFacebook  , UMShareToTwitter  , UMShareToYXSession  , UMShareToYXTimeline  , UMShareToLWSession , UMShareToLWTimeline  ,UMShareToInstagram  , UMShareToWhatsapp  , UMShareToLine  , UMShareToTumblr  , UMShareToPinterest  , UMShareToKakaoTalk  , UMShareToFlickr  
		// sina  tencent  renren  douban  qzone  email  sms  wxsession  wxtimeline  wxfavorite  qq  facebook  twitter  yixin  yixin_circle  laiwang  laiwang_dynamic  instagram  whatsapp  line  tumblr  pinterest  kakaotalk flickr  
		public static const TYPE_WEIXIN_FRIEND = "wxtimeline"
		public static const TYPE_WEIXIN_CHAT = "wxsession"
		public static const TYPE_QQ= 'qq'
		public static const TYPE_QZONE= 'qzone'
		public static const TYPE_SINA = "sina"
			
		private static var _instance:UMSocial;
		private static var extensionContext:ExtensionContext;
		private static const EXTENSION_ID:String="com.pamakids.UMSocial";

		public function get isPushNotificationSupported():Boolean
		{
			var result:Boolean = (Capabilities.manufacturer.search('iOS') > -1 || Capabilities.manufacturer.search('Android') > -1);
			return result;
		}
		public function get isSupport():Boolean
		{
			return extensionContext&&isPushNotificationSupported
		}
//		UMSResponseCodeSuccess            = 200,        //成功
//			UMSResponseCodeBaned              = 505,        //用户被封禁
//			UMSResponseCodeShareRepeated      = 5016,       //分享内容重复
//			UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
//			UMSResponseCodeAccessTokenExpired = 5027,       //token过期
//			UMSResponseCodeNetworkError       = 5050,       //网络错误
//			UMSResponseCodeGetProfileFailed   = 5051,       //获取账户失败
//			UMSResponseCodeCancel             = 5052        //用户取消授权

		public static function get instance():UMSocial
		{
			if (!_instance)
			{
				_instance=new UMSocial();
				extensionContext=ExtensionContext.createExtensionContext(EXTENSION_ID, null);
				if (!extensionContext)
					trace("ERROR - Extension context is null. Please check if extension.xml is setup correctly.");
				else
					extensionContext.addEventListener(StatusEvent.STATUS, onStatus);
			}
			return _instance;
		}

		public static var sharedOK:Function;

		public static var keepCallback:Function;
		
		public static const callbackObj:Object={};

		protected static function onStatus(event:StatusEvent):void
		{
			if (event.code == 'shared' && event.level == '200')
				sharedOK();
			else if(event.code == 'AuthResult' && keepCallback != null)
				keepCallback(event.level);
			else if(event.code == 'CancelAuthResult' && keepCallback != null)
				keepCallback(event.level);
			trace(event.code, event.level);
			var func:Function = callbackObj[event.code];
			if(func)
			{
				func(event.level);
			}
			keepCallback = null;
		}

		public function init(appkey:String="", bugLog:Boolean=false):void
		{
			if (isSupport)
				extensionContext.call('init', appkey, bugLog);
		}
		
		public function initWeChat(wxappid:String="", appSecret:String="", weixinURL:String=""):void
		{
			if (isSupport)
				extensionContext.call('initWeChat', wxappid, appSecret, weixinURL);
		}
		public function initQQ(appid:String="", appkey:String="", url:String=""):void
		{
			if (isSupport)
				extensionContext.call('initQQ', appid, appkey, url);
		}

		/**
		 * 控制分享条是否显示，因为分享条初始化的时候可能有卡顿，所以初始化的时候是看不见的
		 * @param visible
		 */
		public function status(visible:Boolean):void
		{
			if (isSupport)
				extensionContext.call('status', visible ? 1 : 0);
		}

		/**
		 * 设置bar的属性
		 * @param id 数据ID
		 * @param shareText 分享文本
		 * @param imageUrl 分享图片地址
		 * @param title 分享邮件时使用的标题
		 */
		public function dataID(id:String, shareText:String='', imageUrl:String='', title:String=''):void
		{
			if (isSupport)
				extensionContext.call('dataID', id, shareText, imageUrl, title);
		}
		
		public function setAccountInfo(platform:String, usid:String='', accessToken:String='', openId:String='',callback:Function=null):void
		{
			keepCallback = callback
			if (isSupport)
				extensionContext.call('setAccountInfo', platform, usid, accessToken, openId);
		}

		/**
		 * 弹出分享列表分享选择
		 * @param id 数据ID
		 * @param shareText 分享文本
		 * @param imageUrl 分享图片地址
		 * @param title 分享邮件时使用的标题
		 * @param type 分享的平台类型，默认新浪微博，目前只支持： sina, tencent, qzone, email
		 */
		public function share(id:String, shareText:String='', imageUrl:String='', title:String='', type:String='sina',shareCallBack:Function=null):void
		{
			if (isSupport)
				extensionContext.call('share', id, shareText, imageUrl, title, type);
			sharedOK=shareCallBack||sharedOK;
		}

		/**
		 * 第三方平台登录
		 * @param platform 平台名称，目前只支持：sina,tencent,qzone,renren,douban
		 * @callback 返回登录结果
		 */
		public function login(platform:String, callback:Function):void
		{
			keepCallback = callback;
			if (isSupport)
				extensionContext.call('login', platform);
		}
		public function isoAuth(platform:String):Boolean
		{
			if (isSupport)
				return extensionContext.call('isoAuth', platform);
			return false;
		}
		public function unOauth(platform:String, callback:Function):void
		{
			var token:String = getTimer()+""
			callbackObj[token]=callback
			if (isSupport)
				extensionContext.call('unOauth', platform,token);
		}
		public function getSnsInformation(platform:String, callback:Function):void
		{
			var token:String = getTimer()+""
			callbackObj[token]=callback
			if (isSupport)
				extensionContext.call('getSnsInformation', platform,token);
		}

		public function cancelLogin(platform:String, callback:Function):void
		{
			var token:String = getTimer()+""
			callbackObj[token]=callback
			if (isSupport)
				extensionContext.call('cancelLogin', platform,token);
		}
		public function unBindUm(callback:Function):void
		{
			var token:String = getTimer()+""
			callbackObj[token]=callback
			if (isSupport)
				extensionContext.call('unBindUm',token);
		}
	}
}

