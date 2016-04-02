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
	
	
	/**
	 * differ page item diplay
	 * @author Dyson0913
	 */
	public class Visual_page_arrow  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_page_arrow() 
		{
			
		}
		
		public function init():void
		{
			var arrow:MultiObject = create("arrow", ["arrow_left", "arrow_right"]);
			arrow.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 3, 2]);
			arrow.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			arrow.Post_CustomizedData = [2,1826,0];
			arrow.container.x = 1.1;
			arrow.container.y = 593.35;
			arrow.Create_(2);		
			
			//TODO fake
			_betCommand.set_current_page_module(_model.getValue("all_list")[0],"stage1");
			_betCommand.update_select_item(_model.getValue("Current_item_selcet_idx"));
			
			state_parse([gameState.NEW_ROUND,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{
			setFrame("arrow", 2);
			var arrow:MultiObject = Get("arrow");			
			arrow.mousedown = page_change;
			arrow.mouseup = empty_reaction;
			arrow.FlushObject();
			
			//set model
			//var state:int = _model.getValue(modelName.GAMES_STATE);
			//if (state == gameState.NEW_ROUND) _current_Model = _pageModel_set[0];
			//if ( state == gameState.END_ROUND) _current_Model = _pageModel_set[1];
			
		}
		
		override public function disappear():void
		{
			setFrame("arrow", 1);
			var arrow:MultiObject = Get("arrow");						
			arrow.mousedown = null;
			arrow.mouseup = null;
		}
		
		public function page_change(e:Event, idx:int):Boolean
		{			
			var _current_Model:PageStyleModel =  _model.getValue("current_page_module");
			if ( idx == 0) _current_Model.PrePage();		
			else _current_Model.NextPage();
			
			_betCommand.update_page_and_all();			
			updatepage();
			
			return true;
		}
		
		public function updatepage():void
		{			
			dispatcher(new ModelEvent("page_update"));	
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