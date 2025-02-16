package View.ViewComponent 
{
	import Command.BetCommand;
	import flash.display.MovieClip;
	import flash.events.Event;	
	import Model.ModelEvent;
	import Model.PageStyleModel;
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	
	import Model.ChatDataModel;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Item_list  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		public function Visual_Item_list() 
		{
			
		}
		
		public function init():void
		{			
			//開始購入底圖
			var stockchat:MultiObject = create("stage_1_stock", ["stage_1_stock"] );	
			stockchat.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stockchat.Post_CustomizedData = [3, 600, 350];
			stockchat.Create_(6);
			stockchat.container.x = 80;
			stockchat.container.y = 318;
			setFrame("stage_1_stock", 1);
			
			//put_to_lsit(stockchat);
			
			//商品種類字樣
			var font:Array = [ { size:24, align:_text.align_left,bold:true, color:0xFFFFFF } ];			
			font = font.concat(_model.getValue("one_page_data"));
			var item_name:MultiObject = create("item_name", [ResName.TextInfo] );	
			item_name.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			item_name.Post_CustomizedData = [3, 600, 350];
			item_name.CustomizedData = font;
			item_name.CustomizedFun = _text.textSetting;
			item_name.Create_(6);
			item_name.container.x = 224;
			item_name.container.y = 596;
			
			put_to_lsit(item_name);
			
			//購入btn
			var stage_btn:MultiObject = create("stage_1_btn", ["stage_1_btn"] );	
			stage_btn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 3, 2]);
			stage_btn.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_btn.Post_CustomizedData = [3, 600, 350];
			stage_btn.Create_(6);
			stage_btn.container.x = 367;
			stage_btn.container.y = 578;
			
			//put_to_lsit(stage_btn);
			
			state_parse([gameState.NEW_ROUND]);
			
		}
		
		override public function appear():void
		{
			var data:Array = _model.getValue("one_page_data");
			//開始購入底圖  
			setFrame("stage_1_stock", 2);
			
			//動態產生
			var stock:MultiObject = Get("stage_1_stock");
			//以昨日收盤價為中點 
			stock.CustomizedData =  data;
			stock.CustomizedFun = mystockchat;
			stock.FlushObject_bydata();
			
			//商品種類字樣
			var item_name:MultiObject = Get("item_name");
			item_name.CustomizedData = data;
			item_name.CustomizedFun = _text.text_update;
			item_name.FlushObject_bydata();
			
			//購入btn
			setFrame("stage_1_btn", 2);
			var stage_btn:MultiObject = Get("stage_1_btn");
			stage_btn.CustomizedData = data;
			stage_btn.CustomizedFun = _regular.empty_setting;
			stage_btn.mousedown = item_select;
			stage_btn.mouseup = empty_reaction;
			stage_btn.FlushObject_bydata();
		}
		
		override public function disappear():void
		{
			//動態貼上清除
			clean_child("stage_1_stock");
			setFrame("stage_1_stock", 1);
			
			//商品種類字樣
			setText("item_name", "");			
			
			//購入btn
			setFrame("stage_1_btn", 1);
			var stage_btn:MultiObject = Get("stage_1_btn");
			stage_btn.mousedown = null;
			stage_btn.mouseup = null;
		}
		
		public function item_select(e:Event, idx:int):Boolean
		{
			var module:PageStyleModel = _model.getValue("current_page_module");
			_model.putValue("Current_item_selcet_idx", module.ItemPageIdx + idx );
			utilFun.SetTime(tobetview, 0.001);
			return true;
		}
		
		public function tobetview():void
		{
			dispatcher(new ModelEvent("theme_update", 1));	
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "page_update")]
		public function page_upate(para:ModelEvent):void
		{
			if ( !_diplay ) return;			
			appear();
		}
		
		public function mystockchat(mc:MovieClip, idx:int, data:Array):void
		{			
			var data:Array = _model.getValue("one_page_data");
			var key:String = data[idx];
			var chat_data:Array = ChatDataModel.getInstance().getChatData(key);
			
			var graph:MovieClip =  utilFun.GetClassByString("View.ViewComponent.FinancialGraph");
			var chat:FinancialGraph  = graph as FinancialGraph;
			chat.x = 10;
			chat.y = 20;
			chat._newdate = chat_data;
			chat.setSize(520, 210, 0x80ffff);				
			chat.name = "chat";
			
			//_tool.SetControlMc(chat);
			//_tool.y = 50;
			//add(_tool);
			
			mc.addChild(chat);
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