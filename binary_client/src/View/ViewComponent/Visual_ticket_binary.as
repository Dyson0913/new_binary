package View.ViewComponent 
{
	import Command.BetCommand;
	import flash.display.MovieClip;
	import flash.events.Event;	
	import Model.ModelEvent;
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import Model.PageStyleModel;
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_ticket_binary  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		public function Visual_ticket_binary() 
		{
			
		}
		
		public function init():void
		{
			
			create_container();
			
			//票卷底圖
			var stage3_ticket:MultiObject = create("stage_3_ticket", ["stage_3_ticket"] ,_myContain.container);	
			stage3_ticket.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage3_ticket.Post_CustomizedData = [3, 600, 247];
			stage3_ticket.Create_(9);
			stage3_ticket.container.x = 80;
			stage3_ticket.container.y = 268;			
			
			put_to_lsit(stage3_ticket);
			
			//買入部位名稱
			var font:Array = [ { size:24, align:_text.align_left,bold:true, color:0x000000 } ];			
			font = font.concat([]);
			var ticket_name:MultiObject = create("ticket_name", [ResName.TextInfo],_myContain.container );	
			ticket_name.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			ticket_name.Post_CustomizedData = [3, 600, 251];
			ticket_name.CustomizedData = font;
			ticket_name.CustomizedFun = _text.textSetting;
			ticket_name.Create_(9);
			ticket_name.container.x = 158;			
			ticket_name.container.y = 270;			
			
			put_to_lsit(ticket_name);
			
			
			//票卷種類
			var stage3_ticket_type:MultiObject = create("stage_3_ticket_type", ["stage_3_ticket_type"], _myContain.container);	
			stage3_ticket_type.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage3_ticket_type.Post_CustomizedData = [3, 600, 247];
			stage3_ticket_type.Create_(9);
			stage3_ticket_type.container.x = 84;
			stage3_ticket_type.container.y = 305;			
			
			put_to_lsit(stage3_ticket_type);
			
			//購買種類漲跌點數
			var font2:Array = [ { size:24, align:_text.align_center,bold:true, color:0x000000 } ];			
			font2 = font2.concat([]);
			var by_point:MultiObject = create("by_point", [ResName.TextInfo] ,_myContain.container);	
			by_point.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			by_point.Post_CustomizedData = [3, 600, 250];
			by_point.CustomizedData = font2;
			by_point.CustomizedFun = _text.textSetting;
			by_point.Create_(9);
			by_point.container.x = 86;
			by_point.container.y = 355;
			
			put_to_lsit(by_point);
			
			
			//票卷細節 項目名稱
			var ticket_detail_title:MultiObject = create("ticket_detail_title", [ResName.emptymc],_myContain.container );	
			ticket_detail_title.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			ticket_detail_title.Post_CustomizedData = [3, 600, 250];
			ticket_detail_title.CustomizedData =  ["購入數量", "到期支付", "棄權回報"];
			ticket_detail_title.CustomizedFun =  text_creat
			ticket_detail_title.Create_(9);
			ticket_detail_title.container.x = 288;
			ticket_detail_title.container.y = 276;
			
			put_to_lsit(ticket_detail_title);
			
			//買入價
			var buy_at_font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xFFFFFF } ];			
			buy_at_font = buy_at_font.concat([111]);
			var buy_at:MultiObject = create("stage_3_buy_at", [ResName.TextInfo] ,_myContain.container);	
			buy_at.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			buy_at.Post_CustomizedData = [3, 600, 250];
			buy_at.CustomizedData = buy_at_font;
			buy_at.CustomizedFun = _text.textSetting;
			buy_at.Create_(9);
			buy_at.container.x = 286;
			buy_at.container.y = 302;
			
			put_to_lsit(buy_at);
			
			//到期支付
			var ex_value_font:Array = [ { size:24, align:_text.align_center,bold:true, color:0x00CC660 }];			
			ex_value_font = ex_value_font.concat([]);
			var stage_3_expect_value:MultiObject = create("stage_3_expect_value", [ResName.TextInfo],_myContain.container );	
			stage_3_expect_value.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_3_expect_value.Post_CustomizedData = [3, 600, 250];
			stage_3_expect_value.CustomizedData = ex_value_font;
			stage_3_expect_value.CustomizedFun = _text.textSetting;
			stage_3_expect_value.Create_(9);
			stage_3_expect_value.container.x = 286;
			stage_3_expect_value.container.y = 379;
			
			put_to_lsit(stage_3_expect_value);
			
			//棄權回報
			var give_up_value_font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xFF0000 }];			
			give_up_value_font = give_up_value_font.concat([]);
			var stage_3_giveup_value:MultiObject = create("stage_3_giveup_value", [ResName.TextInfo],_myContain.container );	
			stage_3_giveup_value.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_3_giveup_value.Post_CustomizedData = [3, 600, 250];
			stage_3_giveup_value.CustomizedData = give_up_value_font;
			stage_3_giveup_value.CustomizedFun = _text.textSetting;
			stage_3_giveup_value.Create_(9);
			stage_3_giveup_value.container.x = 286;
			stage_3_giveup_value.container.y = 456;
			
			put_to_lsit(stage_3_giveup_value);
			
			//剩餘時間
			var rest_vime_font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xFFFFFF } ];			
			rest_vime_font = rest_vime_font.concat([]);
			var stage_3_restime_value:MultiObject = create("stage_3_restime_value", [ResName.TextInfo] ,_myContain.container);	
			stage_3_restime_value.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_3_restime_value.Post_CustomizedData = [3, 600, 250];
			stage_3_restime_value.CustomizedData = rest_vime_font;
			stage_3_restime_value.CustomizedFun = _text.textSetting;
			stage_3_restime_value.Create_(9);
			stage_3_restime_value.container.x = 96;
			stage_3_restime_value.container.y = 446;
			
			put_to_lsit(stage_3_restime_value);
			
			//剩餘時間 提示字
			var rest_vime_hint_font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xFFFFFF } ];			
			rest_vime_hint_font = rest_vime_hint_font.concat([]);
			var stage_3_restime_hint:MultiObject = create("stage_3_restime_hint", [ResName.TextInfo] ,_myContain.container);	
			stage_3_restime_hint.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_3_restime_hint.Post_CustomizedData = [3, 600, 250];
			stage_3_restime_hint.CustomizedData = rest_vime_hint_font;
			stage_3_restime_hint.CustomizedFun = _text.textSetting;
			stage_3_restime_hint.Create_(9);
			stage_3_restime_hint.container.x = 86;
			stage_3_restime_hint.container.y = 406;
			
			put_to_lsit(stage_3_restime_hint);
			
			//剩餘時間 圖示
			var stage_3_time_stamp:MultiObject = create("stage_3_time_stamp", ["time_stamp"], _myContain.container);	
			stage_3_time_stamp.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_3_time_stamp.Post_CustomizedData = [3, 600, 250];
			stage_3_time_stamp.Create_(9);
			stage_3_time_stamp.container.x = 121;
			stage_3_time_stamp.container.y = 453;	
			setFrame("stage_3_time_stamp", 2);
			
			//棄權按鈕
			var stage_btn:MultiObject = create("stage_3_btn", ["stage_3_btn"],_myContain.container );	
			stage_btn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);
			stage_btn.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_btn.Post_CustomizedData = [3, 600, 247];
			stage_btn.Create_(9);
			stage_btn.container.x = 497;
			stage_btn.container.y = 355;
			
			put_to_lsit(stage_btn);
			
			
			state_parse([gameState.END_ROUND]);
			
		}
		
		override public function appear():void
		{			
			_myContain.container.visible = true;
			var my:Array = _model.getValue("one_page_data");
			
			var data:Array = _betCommand.get_key_info(BetCommand.ITEM_NAME, my); // _betCommand.get_my_bet_info(BetCommand.ITEM_NAME);
			
			//票卷底圖			
			var stage3_ticket:MultiObject = Get("stage_3_ticket");
			stage3_ticket.CustomizedFun = _regular.empty_setting;
			stage3_ticket.CustomizedData = data;
			stage3_ticket.FlushObject_bydata();			
			
			//買入部位名稱
			var item_name:MultiObject = Get("ticket_name");
			item_name.CustomizedData = data;
			item_name.CustomizedFun = _text.text_update;
			item_name.FlushObject_bydata();
			
			//棄權按鈕			
			var stage_btn:MultiObject = Get("stage_3_btn");
			stage_btn.CustomizedData = data;
			stage_btn.CustomizedFun = _regular.empty_setting;
			stage_btn.mousedown = item_select;
			stage_btn.mouseup = empty_reaction;
			stage_btn.FlushObject_bydata();			
			
			var ticket_type_data:Array = _betCommand.get_key_info(BetCommand.BUY_TYPE, my); // _betCommand.get_my_bet_info(BetCommand.BUY_TYPE);
			
			//票卷種類
			var stage3_ticket_type:MultiObject = Get("stage_3_ticket_type");
			stage3_ticket_type.CustomizedData = ticket_type_data;
			stage3_ticket_type.CustomizedFun =  _regular.FrameSetting;
			stage3_ticket_type.FlushObject_bydata();
			
			var ticket_price_data:Array = _betCommand.get_key_info(BetCommand.BUY_POINT, my); //_betCommand.get_my_bet_info(BetCommand.BUY_AT_PRICE);			
			//購買種類漲跌點數
			var by_point:MultiObject = Get("by_point");
			by_point.CustomizedData = ticket_price_data;
			by_point.CustomizedFun = _text.text_update;
			by_point.FlushObject_bydata();
			
			//票卷細節
			var ticket_detail:MultiObject = Get("ticket_detail_title");			
			ticket_detail.CustomizedData = data; 
			ticket_detail.CustomizedFun =  _regular.empty_setting;
			ticket_detail.FlushObject_bydata();		
			
			var buy_at_data:Array =  _betCommand.get_key_info(BetCommand.BUY_AT_PRICE, my);  //_betCommand.get_my_bet_info(BetCommand.BUY_POINT);	
			
			//買入價
			var ticket_detail_price:MultiObject = Get("stage_3_buy_at");			
			ticket_detail_price.CustomizedData = buy_at_data;
			ticket_detail_price.CustomizedFun =  _text.text_update;
			ticket_detail_price.FlushObject_bydata();
			
			//到期支付
			var ex_evlue_data:Array =  _betCommand.get_key_info(BetCommand.EXPECT_VALUE, my); //_betCommand.get_my_bet_info(BetCommand.EXPECT_VALUE);
			
			var stage_3_expect_value:MultiObject = Get("stage_3_expect_value");
			stage_3_expect_value.CustomizedData = ex_evlue_data;
			stage_3_expect_value.CustomizedFun =  _text.text_update;
			stage_3_expect_value.FlushObject_bydata();
			
			//棄權回報 TODO real data get
			var give_up_data:Array = _betCommand.get_key_info(BetCommand.EXPECT_VALUE, my);  //_betCommand.get_my_bet_info(BetCommand.EXPECT_VALUE);	
			var stage_3_giveup_value:MultiObject = Get("stage_3_giveup_value");
			stage_3_giveup_value.CustomizedData = give_up_data;
			stage_3_giveup_value.CustomizedFun = _text.text_update;
			stage_3_giveup_value.FlushObject_bydata();
			
			//剩餘時間
			var rest_time_data:Array = _betCommand.get_key_info(BetCommand.REST_TIME, my); //_betCommand.get_my_bet_info(BetCommand.REST_TIME);
			
			var stage_3_restime_value:MultiObject = Get("stage_3_restime_value");
			stage_3_restime_value.CustomizedData = rest_time_data;
			stage_3_restime_value.CustomizedFun = _text.text_update;
			stage_3_restime_value.FlushObject_bydata();
			
			//剩餘時間 提示字
			var stage_3_restime_hint:MultiObject = Get("stage_3_restime_hint")
			stage_3_restime_hint.CustomizedData = rest_time_data;
			stage_3_restime_hint.CustomizedFun = mytext_Setting;
			stage_3_restime_hint.FlushObject_bydata();
			
			//剩餘時間 圖示
			var stage_3_time_stamp:MultiObject = Get("stage_3_time_stamp")
			stage_3_time_stamp.CustomizedData = rest_time_data;
			stage_3_time_stamp.CustomizedFun = _regular.empty_setting;
			stage_3_time_stamp.FlushObject_bydata();
		}
		
		public function myFrame_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			_regular.FrameSetting(mc, 0, [2]);
		}
		
		public function mytext_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			_text.text_update(mc, 0, ["到期時間還剩"]);
		}
		
		override public function disappear():void
		{			
			_myContain.container.visible = false;
			return;
			
			//setFrame("stage_3_ticket", 1);
			//
			//setText("ticket_name", "");
			//
			//setFrame("stage_3_btn", 1);			
			//var stage_btn:MultiObject = Get("stage_3_btn");
			//stage_btn.mousedown = null;
			//stage_btn.mouseup = null;
			//
			//setFrame("stage_3_ticket_type", 1);	
			//
			//setText("by_point", "");			
			//
			//var ticket_detail:MultiObject = Get("ticket_detail");
			//ticket_detail.container.visible = false;
			//
			//var ticket_detail_price:MultiObject = Get("ticket_detail_price");
			//ticket_detail_price.container.visible = false;
		}
		
		public function item_select(e:Event, idx:int):Boolean
		{
			utilFun.Log("idx= " + idx);
			if( idx ==0) dispatcher(new ModelEvent("pop_hint",[1, true, this.give_up,idx]) );			
			//if( idx ==1) dispatcher(new ModelEvent("pop_hint",[1, false, this.give_up,idx]) );	
			dispatcher(new ModelEvent("pop_hint",[1, true, this.give_up,idx]) );
			return true;
		}		
		
		public function give_up(idx:int):void
		{
			utilFun.Log("give_up= " + idx);
			var module:PageStyleModel = _model.getValue("current_page_module");
			_betCommand.cleanBet(module.ItemPageIdx + idx);
			
			//model
			_betCommand.set_current_page_module(_betCommand.get_my_betlist(), "buy_ticket" );
			
			appear();
		}
		
		public function text_creat(mc:MovieClip, idx:int, data:Array):void
		{
			var font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xEEDD7E } ];			
			font = font.concat(data);
			var ticket_detail:MultiObject = create("ticket_detail_"+idx,[ResName.TextInfo],mc);
			ticket_detail.Posi_CustzmiedFun =  _regular.Posi_Colum_first_Setting;
			ticket_detail.Post_CustomizedData = [3, 0, 77];
			ticket_detail.CustomizedData = font;
			ticket_detail.CustomizedFun = _text.textSetting;
			ticket_detail.Create_(3);			
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "page_update")]
		public function page_upate(para:ModelEvent):void
		{			
			if ( !_diplay ) return;
			utilFun.Log("update in phase 3");
			
			appear();
		}
	}

}