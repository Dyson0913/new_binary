package View.ViewComponent 
{	
	import flash.display.MovieClip;
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
			
			put_to_lsit(theme);
			
			//Zonetitle
			var Zonetitle:MultiObject = create("Zonetitle", ["clip_1","clip_2","clip_3"]);
			Zonetitle.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			Zonetitle.Post_CustomizedData = [3,256,0];
			Zonetitle.container.x = 61.15;
			Zonetitle.container.y = 83.35;
			Zonetitle.Create_(3);
			
			put_to_lsit(Zonetitle);
			
			state_parse([gameState.NEW_ROUND,gameState.NEW_ROUND]);
		}
		
		override public function appear():void
		{	
			GetSingleItem("theme").gotoAndStop(1);
			
			GetSingleItem("Zonetitle", 0).gotoAndStop(2);			
			
			//more and more
			//  xxx. setting ....
		}
		
		override public function disappear():void
		{
			
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