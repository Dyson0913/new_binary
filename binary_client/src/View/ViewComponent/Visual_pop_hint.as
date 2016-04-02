package View.ViewComponent 
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Model.ModelEvent;
	import Model.PageStyleModel;
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	
	/**
	 * differ pop hint diplay
	 * @author Dyson0913
	 */
	public class Visual_pop_hint  extends VisualHandler
	{
		private var _callback:Function = null;
		private var _callback_data:Array = [];
		
		public function Visual_pop_hint() 
		{
			
		}
		
		public function init():void
		{
			var pophint:MultiObject = create("pop_board", ["pop_hint", "pop_hint_btn", "pop_hint_btn"]);
			//pophint.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			pophint.Post_CustomizedData = [[0, 0] , [30, 110], [200, 110]];
			pophint.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			pophint.container.x = 771;
			pophint.container.y = 473.35;
			pophint.Create_(3);
			pophint.container.visible = false;
			pophint.rollover = popRollover;
			pophint.rollout = popRollout;
			
			//state_parse([gameState.NEW_ROUND,gameState.START_BET,gameState.END_ROUND]);		
		}
		
		public function popRollover(e:Event, idx:int):Boolean
		{			
			if (e.currentTarget["_btn"] != undefined) {
				
				if (e.currentTarget["_btn"].currentFrame == 1) {
					Get("pop_board").ItemList[1].gotoAndStop(2);
					Get("pop_board").ItemList[1]["_btn"].gotoAndStop(1);
				}else if (e.currentTarget["_btn"].currentFrame == 2) {
					Get("pop_board").ItemList[2].gotoAndStop(2);
					Get("pop_board").ItemList[2]["_btn"].gotoAndStop(2);
				}
			
			}
			
			return true;
		}
		
			public function popRollout(e:Event, idx:int):Boolean
		{			
			if (e.currentTarget["_btn"] != undefined) {
				
				if (e.currentTarget["_btn"].currentFrame == 1) {
					Get("pop_board").ItemList[1].gotoAndStop(1);
					Get("pop_board").ItemList[1]["_btn"].gotoAndStop(1);
				}else if (e.currentTarget["_btn"].currentFrame == 2) {
					Get("pop_board").ItemList[2].gotoAndStop(1);
					Get("pop_board").ItemList[2]["_btn"].gotoAndStop(2);
				}
			
			}
			
			return true;
		}
		
		/*arr protocal  [  context_frame | text ,
		                         cencel_diplay_or_not :boolen,
                                 comfirm_callback :function ,
		                          data:array
								]
		*/
		[MessageHandler(type = "Model.ModelEvent", selector = "pop_hint")]		
		public function pophint(para:ModelEvent):void
		{
			var config:Array = para.Value[0];
			
			var pop_board:MultiObject = Get("pop_board");						
			pop_board.container.visible = true;
			pop_board.ItemList[0].gotoAndStop(config[0]);			
			pop_board.mousedown = chose;
			_callback = config[2];
			_callback_data.push( config[3]);
			
			if ( config[1] )
			{
				pop_board.Post_CustomizedData = [[0, 0] , [30, 110], [200, 110]];
				pop_board.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
				pop_board.customized();				
				pop_board.ItemList[1]["_btn"].gotoAndStop(1);
				pop_board.ItemList[2]["_btn"].gotoAndStop(2);
				pop_board.mouseup = empty_reaction;
			}
			else
			{				
				//視情況決定中央
				pop_board.ItemList[1].x = 130;
				pop_board.ItemList[1].y = 110;
				// 第三格為空影格
				pop_board.ItemList[2]["_btn"].gotoAndStop(3);				
			}
			
			
			
		}
		
		public function chose(e:Event, idx:int):Boolean
		{
			//bg click
			if ( idx == 0) return false;
			
			//comfirm	
			if ( idx == 1 ) _callback(_callback_data[0]);
			
			this.close(e, idx);
			return true;
		}
		
		public function close(e:Event, idx:int):Boolean
		{
			var pop_board:MultiObject = Get("pop_board");						
			pop_board.container.visible = false;
			pop_board.mousedown = null;
			pop_board.mouseup = null;
			_callback_data.length = 0;
			return true;
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