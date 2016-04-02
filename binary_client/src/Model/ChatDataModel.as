package Model 
{
	import util.utilFun;
	/**
	 * ...
	 * @author divia
	 */
	public class ChatDataModel 
	{
		
		private static var _instance:ChatDataModel = null;
		
		private var _keyArray:Array = [];
		private var _dataArray:Array = [];
		
		public function ChatDataModel() 
		{
			_keyArray = [ "歐元", "美元", "英鎊", "加幣", "日元", "韓元", "港幣", "新台幣", "人民幣", "比特幣", "新加坡幣", "加幣", "法郎", "南非幣",
									"上海A股", "上海B股", "上海綜合", "香港恆生", "香港國企", "日經225", "台灣加權", "韓國100", "鈕西蘭50", "澳洲ASX", "菲律賓PSEI", "印尼綜合", "印度BSE30", "深圳B股",
									"2317鴻海", "2332友訊", "2352佳世達", "2356英業達", "2365昆盈", "2390云辰", "2392正崴", "2423固緯", "2424隴華", "2451創見", "2481連宇", "2497怡利電", "2498宏達電", "3024憶聲"
								];
			for each(var key:String in _keyArray) {
				var data:Array = ran_data();
				_dataArray[key] = data;
			}
		}
		
		public static function getInstance():ChatDataModel {
			if (_instance == null) {
				_instance = new ChatDataModel();
			}
			
			return _instance;
		}
		
		public function getChatData(key:String):Array {
			return _dataArray[key];
		}
		
		private function ran_data():Array
		{
			var date:Array = []
			for (var i:int = 0; i < 100; i++)
			{
				date.push([ i*5,  utilFun.Random(50)  * (utilFun.Random(2) *2-1)   ]);
			}
			return date;
		}
		
	}

}