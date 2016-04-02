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
	
	
	/**
	 * differ theme
	 * @author Dyson0913
	 */
	public class Visual_theme  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		public const theme:String = "theme_binany"		
		public const Zonetitle:String = "Zone_title"		
		
		public function Visual_theme() 
		{
			
		}
		
		public function init():void
		{			
			var theme:MultiObject = create("theme", [theme]);	
			theme.container.x = 52.65;
			theme.container.y = 255.7;
			theme.Create_(1);
			
			//上方切換頁籤
			var tag:MultiObject = create("tag", ["clip_1","clip_2","clip_3"]);
			tag.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			tag.Post_CustomizedData = [3,256,0];
			tag.container.x = 61.15;
			tag.container.y = 85.35;
			tag.Create_(3);
			
			var arrow:MultiObject = create("arrow", ["arrow_left", "arrow_right"]);
			arrow.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			arrow.Post_CustomizedData = [2,1826,0];
			arrow.container.x = 1.1;
			arrow.container.y =593.35
			arrow.Create_(2);
			
			state_parse([gameState.NEW_ROUND]);
		}
		
		override public function appear():void
		{	
			setFrame("theme",1)			
			
			GetSingleItem("tag", 0).gotoAndStop(2);			
			
			var tag:MultiObject = Get("tag");
			tag.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			tag.mousedown = clip_change;			
			tag.FlushObject();
			//more and more
			//  xxx. setting ....
		}
		
		public function clip_change(e:Event, idx:int):Boolean
		{			
			_model.putValue("Current_item_selcet_idx", 0);			
			dispatcher(new ModelEvent("theme_update", idx));			
			return false;
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "theme_update")]
		public function theme_switch(para:ModelEvent):void
		{
			var idx:int = para.Value;
			// tag 變化
			setFrame("tag", 1);
			GetSingleItem("tag", idx).gotoAndStop(2);
			
			//底圖切換
			setFrame("theme", idx+1);
			
			//狀態切換
			if ( idx == 0) 
			{
				//切換page model
				_betCommand.set_current_page_module(_model.getValue("all_list")[_model.getValue("cata_idx")], "stage1" );
				_betCommand.update_select_item(_model.getValue("Current_item_selcet_idx"));
				_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);
			}
			else if ( idx == 1)  
			{
				//切換page model
				_betCommand.set_current_page_module(_model.getValue("all_list")[_model.getValue("cata_idx")], "stage1" );				
				_betCommand.update_select_item(_model.getValue("Current_item_selcet_idx"));
				_model.putValue(modelName.GAMES_STATE,gameState.START_BET);
			}
			else if ( idx == 2) 
			{				
				//更新下注值
				_betCommand.set_current_page_module(_betCommand.get_my_betlist(), "buy_ticket" );				
				_model.putValue(modelName.GAMES_STATE,gameState.END_ROUND);
			}
			dispatcher(new ModelEvent("update_state"));
		}
		
		override public function test_suit():void
		{
			//var state:int = _model.getValue(modelName.GAMES_STATE);
			//if ( state == gameState.NEW_ROUND  || state == gameState.START_BET)
			//{				
				//test_frame_Not_equal( GetSingleItem("theme") , 1);
				//test_frame_Not_equal(GetSingleItem("theme")["Logo"] , 1);	
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 1);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 2);
			//}
			//else if ( state == gameState.END_BET  || state == gameState.START_OPEN)
			//{
				//test_frame_Not_equal( GetSingleItem("theme") , 2);
				//test_frame_Not_equal(GetSingleItem("theme")["Logo"] , 1);	
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 4);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 3);
			//}
			//else if ( state == gameState.END_ROUND )
			//{
				//test_frame_Not_equal( GetSingleItem("theme") , 2);
				//test_frame_equal(GetSingleItem("theme")["Logo"] , 1);
				//
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 0), 4);
				//test_frame_Not_equal(GetSingleItem("Zonetitle", 1), 5);
			//}
			//else 
			//{
				//Log("visual_theme not  handle");
			//}
		}
		
	}

}