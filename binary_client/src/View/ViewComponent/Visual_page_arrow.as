package View.ViewComponent 
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import Model.PageStyleModel;
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	
	/**
	 * differ theme
	 * @author Dyson0913
	 */
	public class Visual_page_arrow  extends VisualHandler
	{
		private var _pageModel:PageStyleModel; 
		
		public function Visual_page_arrow() 
		{
			
		}
		
		public function init():void
		{
			var arrow:MultiObject = create("arrow", ["arrow_left", "arrow_right"]);
			arrow.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			arrow.Post_CustomizedData = [2,1826,0];
			arrow.container.x = 1.1;
			arrow.container.y = 593.35;
			arrow.Create_(2);
			
			put_to_lsit(arrow);
			
			_pageModel = new PageStyleModel();
			_pageModel.UpDateModel(["歐元","美元","英鎊","加幣","日元","韓元","港幣","新台幣","人民幣","比特幣","新加坡幣"], 11);	
			
			state_parse([gameState.NEW_ROUND,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{
			setFrame("arrow", 2);
			var arrow:MultiObject = Get("arrow");			
			arrow.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 3, 2]);
			arrow.mousedown = page_change;
			arrow.mouseup = empty_reaction;
			arrow.FlushObject();			
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
			if ( idx == 0) _pageModel.PrePage();		
			else _pageModel.NextPage();
			updatepage();
			
			return true;
		}
		
		private function updatepage():void
		{
			var data:Array = _pageModel.GetPageDate();
			Get("spider").CustomizedData = [data];
			Get("spider").customized();
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