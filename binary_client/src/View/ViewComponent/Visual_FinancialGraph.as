package View.ViewComponent 
{
	import flash.display.MovieClip;
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
		
		public static const up:String = "raise_up";	
		public static const down:String = "fall_down";	
		public static const outprice:String = "out_price";	
		public static const Inprice:String = "In_price";	
		
		public function Visual_FinancialGraph() 
		{
			
		}
		
		public function init():void
		{			
			var date:Array = []
			for (var i:int = 0; i < 100; i++)
			{
				date.push([ i*5,  utilFun.Random(50)  * (utilFun.Random(2) *2-1)   ]);
			}
			var stockchat:MultiObject = create("stock_chat",["stock_chat"] );
			
			//以昨日收盤價為中點 
			stockchat.CustomizedData =  date;// [[40, 30], [50, -50], [60, 30], [90, -50], [100, 40]];
			stockchat.CustomizedFun = mystockchat;
			
			stockchat.Create_(1);
			stockchat.container.x = 30;
			stockchat.container.y = 188;
			
			put_to_lsit(stockchat);
			
			
			//購買清單
			var shoppingboard:MultiObject = create("shoppingboard", ["shopping_board"] );
			shoppingboard.container.x = 30;
			shoppingboard.container.y = 528;
			shoppingboard.Create_(1);
			
			//var itemdetail:MultiObject = create("itemdetail", ["Item_detail"], shoppingboard.container);
			//itemdetail.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			//itemdetail.Post_CustomizedData = [20, 0, 74];
			//itemdetail.container.x = 20.95;
			//itemdetail.container.y = 48.35;			
			//itemdetail.Create_(5);
			
		}
		
		public function mystockchat(mc:MovieClip, idx:int, data:Array):void
		{			
			var graph:MovieClip =  utilFun.GetClassByString("View.ViewComponent.FinancialGraph");
			var chat:FinancialGraph  = graph as FinancialGraph;
			chat.x = 59;
			chat.y = 32;
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
			utilFun.Clear_ItemChildren(ch);
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
		
		//1, 
		[MessageHandler(type = "Model.ModelEvent", selector = "In_price")]
		public function In_price():void
		{			
			item_info(Inprice);
			var price:int = _model.getValue("price_low")
			Log("Inprice = " + price);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "out_price")]
		public function out_price():void
		{		
			item_info(outprice);
			var price:int = _model.getValue("price_high")
			Log("out_price = " + price);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "fall_down")]
		public function fall_down():void
		{		
			item_info(down);
			var price:int = _model.getValue("price_low")
			Log("down = " + price);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "raise_up")]
		public function raise_up():void
		{			
			item_info(up);
			var price:int = _model.getValue("price_high")
			Log("raise = " + price);
		}
		
		public function item_info(behavior:String):void
		{
			var market:MultiObject = Get("down_list_container");
			var Item_name:String = market.CustomizedData[_model.getValue("down_select")];
			Log("Item_name = "+Item_name);
			var frame:int = _opration.getMappingValue(modelName.BUY_ITEM_FRAME, behavior);
			Log("frame = " + frame);
			Log("expect_profit =" + _model.getValue("expect_profit"));
		}
		
	}

}