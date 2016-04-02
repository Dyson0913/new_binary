package View.ViewComponent 
{
	import flash.display.MovieClip;
	import util.math.Value_Transfer;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_FinancialGraph  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _value_trans:Value_Transfer;
		
		public static const up:String = "raise_up";	
		public static const down:String = "fall_down";	
		public static const outprice:String = "out_price";	
		public static const Inprice:String = "In_price";	
		
		private var _shoppingboard:MultiObject;
		private var _sc:ScollBar;
		
		public function Visual_FinancialGraph() 
		{
			
		}
		
		public function init():void
		{			
			//線圖
			var stockchat:MultiObject = create("stock_chat",["stock_chat"] );			
			stockchat.Create_(1);
			stockchat.container.x = 50;
			stockchat.container.y = 276;
			setFrame("stock_chat", 1);
			
			//put_to_lsit(stockchat);
			
			//底圖
			var shoppingbg:MultiObject = create("shoppingbg", ["shopping_bg"] );
			shoppingbg.container.x = 50;
			shoppingbg.container.y = 578;
			shoppingbg.Create_(1);
			
			//購買清單
			var shoppingboard:MultiObject = create("shoppingboard", ["shopping_board"] );
			shoppingboard.container.x = 50;
			shoppingboard.container.y = 588;
			shoppingboard.Create_(20);
			setFrame("shoppingboard", 1);
			
			_shoppingboard = shoppingboard;
			
			//scollbar mask
			var _mask:MultiObject = create("scollbar_mask", ["scollbar_mask"] );
			_mask.Create_(1);
			_mask.container.x = 50;
			_mask.container.y = 588;
			_mask.container.width = shoppingboard.container.width + 120;
			_mask.container.height = shoppingbg.container.height -20;
			shoppingboard.container.mask = _mask.container;
		
			//scollbar
			_sc = new ScollBar(GetSingleItem("_view").parent.parent, shoppingboard.container, _mask.container);
			add(_sc);
			
			state_parse([gameState.START_BET]);
			
			
		}
		
		//動態刷新
		private function dynamicFresh():void {
			//清除
			utilFun.Clear_ItemChildrenNotBg(_shoppingboard.container);
			
			//資料筆數
			var itemNum:int = _betCommand.get_my_bet_info(BetCommand.ITEM_NAME).length;
			
			//購買清單細節
			if (Get("itemdetail") != null) {
				Del("itemdetail");
			}
			var itemdetail:MultiObject = create("itemdetail", ["Item_detail"], _shoppingboard.container);
			itemdetail.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			itemdetail.Post_CustomizedData = [itemNum, 0, 74];	
			itemdetail.container.x = 9.9;
			itemdetail.container.y = 69.35;
			itemdetail.Create_(itemNum);
			
			//己購買種類
			if (Get("ticket_type") != null) {
				Del("ticket_type");
			}
			var font:Array = [ { size:22, align:_text.align_left,bold:true, color:0xFFFFFF } ];			
			font = font.concat([]);
			var ticket_type:MultiObject = create("ticket_type", [ResName.TextInfo] ,_shoppingboard.container);	
			ticket_type.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			ticket_type.Post_CustomizedData = [itemNum, 0, 74];
			ticket_type.CustomizedData = font;
			ticket_type.CustomizedFun = _text.textSetting;
			ticket_type.container.x = 19.9
			ticket_type.container.y = 89.35	
			ticket_type.Create_(itemNum);
			
			//對賭範圍
			//己購買種類
			if (Get("bet_range") != null) {
				Del("bet_range");
			}
			var font_range:Array = [ { size:22, align:_text.align_center,bold:true, color:0xFF0000 } ];			
			font_range = font_range.concat([]);
			var bet_range:MultiObject = create("bet_range", [ResName.TextInfo] ,_shoppingboard.container);	
			bet_range.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			bet_range.Post_CustomizedData = [itemNum, 0, 74];
			bet_range.CustomizedData = font_range;
			bet_range.CustomizedFun = _text.textSetting;
			bet_range.Create_(itemNum);
			bet_range.container.x = 90;
			bet_range.container.y = 112.35;
			
			//購買現值
			if (Get("buy_at") != null) {
				Del("buy_at");
			}
			var font_buy:Array = [ { size:22, align:_text.align_right,bold:true, color:0xFFFFFF } ];			
			font_buy = font_buy.concat([]);
			var buy_at:MultiObject = create("buy_at", [ResName.TextInfo] ,_shoppingboard.container);	
			buy_at.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			buy_at.Post_CustomizedData = [itemNum, 0, 74];
			buy_at.CustomizedData = font_buy;
			buy_at.CustomizedFun = _text.textSetting;
			buy_at.Create_(itemNum);
			buy_at.container.x = 200;
			buy_at.container.y = 89.35;
			
			//到期支付
			if (Get("expect_get_value") != null) {
				Del("expect_get_value");
			}
			var font_get_value:Array = [ { size:22, align:_text.align_right,bold:true, color:0xFFFFFF } ];			
			font_get_value = font_get_value.concat([]);
			var expect_get_value:MultiObject = create("expect_get_value", [ResName.TextInfo] ,_shoppingboard.container);	
			expect_get_value.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			expect_get_value.Post_CustomizedData = [itemNum, 0, 74];
			expect_get_value.CustomizedData = font_get_value;
			expect_get_value.CustomizedFun = _text.textSetting;
			expect_get_value.Create_(itemNum);
			expect_get_value.container.x = 340;
			expect_get_value.container.y = 89.35;
			
			//剩餘時間
			if (Get("rest_time") != null) {
				Del("rest_time");
			}
			var font_time:Array = [ { size:22, align:_text.align_right,bold:true, color:0xFF0000 } ];			
			font_time = font_time.concat([]);
			var rest_time:MultiObject = create("rest_time", [ResName.TextInfo] ,_shoppingboard.container);	
			rest_time.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			rest_time.Post_CustomizedData = [itemNum, 0, 74];
			rest_time.CustomizedData = font_time;
			rest_time.CustomizedFun = _text.textSetting;
			rest_time.Create_(itemNum);
			rest_time.container.x = 460;
			rest_time.container.y = 89.35;
		}
		
		override public function appear():void
		{
			setFrame("stock_chat", 2);
			graph_update();
			
			var shoppingboard:MultiObject = Get("shoppingboard");
			shoppingboard.container.visible = true;			
			
			Get("shoppingbg").container.visible = true;
			
			dynamicFresh();
			ticket_update();
			_sc.visible = true;
			_sc.reSetScollBar();
		}
		
		public function itemFrameSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			if( idx % 2 == 1) mc.gotoAndStop(2);
			else  mc.gotoAndStop(3);
			
			mc["_mc"].gotoAndStop(data[idx]);
		}
		
		override public function disappear():void
		{
			clean_child("stock_chat");
			setFrame("stock_chat", 1);
			
			var shoppingboard:MultiObject = Get("shoppingboard");
			shoppingboard.container.visible = false;			
			
			Get("shoppingbg").container.visible = false;
			_sc.visible = false;
			
			_sc.remove();
			
			//var itemdetail:MultiObject = Get("itemdetail");
			//itemdetail.container.visible = false;
		}
		
		public function mystockchat(mc:MovieClip, idx:int, data:Array):void
		{			
			var graph:MovieClip =  utilFun.GetClassByString("View.ViewComponent.FinancialGraph");
			var chat:FinancialGraph  = graph as FinancialGraph;
			chat.x = 39;
			chat.y = 14;
			chat._newdate = data;
			chat.setSize(600, 250, 0x80ffff);				
			chat.name = "chat";
			//_tool.SetControlMc(chat);
			//_tool.y = 50;
			//add(_tool);
			
			mc.addChild(chat);
		}
		
		public function reset_chat():void
		{
			var mu:MultiObject =  Get("stock_chat");
			var mc:MovieClip = 	GetSingleItem("stock_chat");
			var ch:MovieClip = mc.getChildByName("chat") as MovieClip;
			utilFun.Clear_ItemChildren(mc);
			var graph:MovieClip =  utilFun.GetClassByString("View.ViewComponent.FinancialGraph");
			var chat:FinancialGraph  = graph as FinancialGraph;
			chat.x = 59;
			chat.y = 32;
			
			var date:Array = []
			for (var i:int = 0; i < 100; i++)
			{
				date.push([ i*5,  utilFun.Random(50)  * (utilFun.Random(2) *2-1)   ]);
			}
			
			chat._newdate = date;
			chat.setSize(600, 250, 0x80ffff);				
			chat.name = "chat";			
			mc.addChild(chat);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updatet_icket")]
		public function ticket_upate(para:ModelEvent):void
		{			
			if ( !_diplay ) return;
			
			utilFun.Log("update in ticket_upate");
			
			dynamicFresh();
			ticket_update();
			_sc.reSetScollBar();
		}
		
		private function ticket_update():void
		{			
			var itemNum:int = _betCommand.get_my_bet_info(BetCommand.ITEM_NAME).length;
			
			if(Get("ticket_type") != null){
				//己購買種類
				var ticket_type:MultiObject = Get("ticket_type");
				ticket_type.CustomizedData = _betCommand.get_my_bet_info(BetCommand.ITEM_NAME);
				ticket_type.CustomizedFun = _text.text_update;
				ticket_type.FlushObject_bydata();
			}
			
			if(Get("itemdetail") != null){
				//購買清單細節
				var itemdetail:MultiObject = Get("itemdetail");
				itemdetail.CustomizedFun = itemFrameSetting;
				itemdetail.CustomizedData = _betCommand.get_my_bet_info(BetCommand.BUY_TYPE);
				itemdetail.FlushObject_bydata();
			}
			
			if(Get("bet_range") != null){
				//對賭範圍
				var bet_range:MultiObject = Get("bet_range");
				bet_range.CustomizedData = _betCommand.get_my_bet_info(BetCommand.BUY_POINT);
				bet_range.CustomizedFun = my_color_update;
				bet_range.FlushObject_bydata();
			}
			
			if(Get("buy_at") != null){
				//購買現值
				var buy_at:MultiObject = Get("buy_at");
				buy_at.CustomizedData = _betCommand.get_my_bet_info(BetCommand.BUY_AT_PRICE);
				buy_at.CustomizedFun = _text.text_update;
				buy_at.FlushObject_bydata();		
			}
			
			if(Get("expect_get_value") != null){
				//到期支付
				var expect_get_value:MultiObject = Get("expect_get_value");
				expect_get_value.CustomizedData = _betCommand.get_my_bet_info(BetCommand.EXPECT_VALUE);
				expect_get_value.CustomizedFun = _text.text_update;
				expect_get_value.FlushObject_bydata();
			}
			
			if(Get("rest_time") != null){
				//剩餘時間
				var rest_time:MultiObject = Get("rest_time");
				rest_time.CustomizedData = _betCommand.get_my_bet_info(BetCommand.REST_TIME);
				rest_time.CustomizedFun = _text.text_update;
				rest_time.FlushObject_bydata();
			}
		}
		
		public function my_color_update(mc:MovieClip, idx:int, data:Array):void
		{
			_text.text_update(mc, idx, data);
			var type:Array = _betCommand.get_my_bet_info(BetCommand.BUY_TYPE);
			
			//漲 : 1 ,跌: 2,   區間外: 3 區間內: 4:區間外
			if ( type[idx] == 1 ) _text.color_update(mc,0,[0x00CC660])
			else if ( type[idx] == 2 ) _text.color_update(mc,0,[0xFF0000])
			else _text.color_update(mc,0,[0xFFFFFF])
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "graph_update")]
		public function graph_update():void
		{
			
			var date:Array = []
			for (var i:int = 0; i < 100; i++)
			{
				date.push([ i*5,  utilFun.Random(50)  * (utilFun.Random(2) *2-1)   ]);
			}
			var stock:MultiObject = Get("stock_chat");
			//以昨日收盤價為中點 

			var key:String = _model.getValue("current_item");
			utilFun.Log("select:" + key);
			var chat_data:Array = ChatDataModel.getInstance().getChatData(key);
			stock.CustomizedData =  chat_data;
			
			//stock.CustomizedData =  date;// [[40, 30], [50, -50], [60, 30], [90, -50], [100, 40]];
			stock.CustomizedFun = mystockchat;
			stock.FlushObject();
		}
	}

}