package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;	
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Item_list  extends VisualHandler
	{		
		
		public static const up:String = "raise_up";	
		public static const down:String = "fall_down";	
		public static const outprice:String = "out_price";	
		public static const Inprice:String = "In_price";	
		
		public function Visual_Item_list() 
		{
			
		}
		
		public function init():void
		{			
			
			var stockchat:MultiObject = create("stage_1_stock", ["stage_1_stock"] );	
			stockchat.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stockchat.Post_CustomizedData = [3, 600, 350];
			stockchat.Create_(6);
			stockchat.container.x = 80;
			stockchat.container.y = 318;
			setFrame("stage_1_stock", 1);
			
			//put_to_lsit(stockchat);
			
			var font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xFFFFFF } ];			
			font = font.concat(_model.getValue("current_list"));
			var item_name:MultiObject = create("item_name", [ResName.TextInfo] );	
			item_name.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			item_name.Post_CustomizedData = [3, 600, 350];
			item_name.CustomizedData = font;
			item_name.CustomizedFun = _text.textSetting;
			item_name.Create_(6);
			item_name.container.x = -86;
			item_name.container.y = 596;
			
			//put_to_lsit(item_name);
			
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
			setFrame("stage_1_stock", 2);
			
			var stock:MultiObject = Get("stage_1_stock");
			//以昨日收盤價為中點 
			stock.CustomizedData =  [];
			stock.CustomizedFun = mystockchat;
			stock.FlushObject();
			
			var item_name:MultiObject = Get("item_name");
			item_name.CustomizedData = _model.getValue("current_list");
			item_name.CustomizedFun = _text.text_update;
			item_name.FlushObject();
			
			setFrame("stage_1_btn", 2);
			var stage_btn:MultiObject = Get("stage_1_btn");
			stage_btn.mousedown = item_select;
			stage_btn.mouseup = empty_reaction;
			stage_btn.FlushObject();			
		}
		
		override public function disappear():void
		{
			
			clean_child("stage_1_stock");
			setFrame("stage_1_stock", 1);
			
			
			setText("item_name", "");			
			
			setFrame("stage_1_btn", 1);			
			var stage_btn:MultiObject = Get("stage_1_btn");
			stage_btn.mousedown = null;
			stage_btn.mouseup = null;
		}
		
		public function item_select(e:Event, idx:int):Boolean
		{
			utilFun.Log("idx= "+idx);
			return true;
		}
		
		public function mystockchat(mc:MovieClip, idx:int, data:Array):void
		{			
			var graph:MovieClip =  utilFun.GetClassByString("View.ViewComponent.FinancialGraph");
			var chat:FinancialGraph  = graph as FinancialGraph;
			chat.x = 10;
			chat.y = 20;
			chat._newdate = ran_data();
			chat.setSize(520, 210, 0x80ffff);				
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