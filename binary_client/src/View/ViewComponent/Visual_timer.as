package View.ViewComponent 
{
	import flash.display.MovieClip;	
	import View.ViewBase.VisualHandler;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;	
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	import util.time.time_format;
	import flash.utils.setInterval;
	
	/**
	 * timer present way
	 * @author Dyson0913
	 */
	public class Visual_timer  extends VisualHandler
	{		
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		
		//res		
		public const timebar:String = "time_bar";
		public const timeCountDown:String = "time_countDown";
		public const timenow:String = "time_now";
		
		//tag
		private const now_time:int = 0;
		private const bar_from:int = 1;
		private const bar_to:int = 2;
		private const countDown:int = 3;
		public var Waring_sec:int;		
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{			 
			var time_bar_container:MultiObject = create("time_bar_container", [ResName.emptymc]);	
			time_bar_container.container.x = 490;
			time_bar_container.container.y = 130;
			time_bar_container.Create_(1);
			
			put_to_lsit(time_bar_container);			   
		   
		   Waring_sec = 7;
		   
		   state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			var time_bar_container:MultiObject = Get("time_bar_container");
			time_bar_container.container.visible = true;
			time_bar_container.CustomizedFun = time_init;			
			time_bar_container.CustomizedData = [];
			time_bar_container.FlushObject();
			//setInterval(updatetimer, 1000, "time_", 0);
			
			//setFrame(Timer, 2);
			//var time:int = _model.getValue(modelName.REMAIN_TIME);
			//frame_setting_way(time);
			//
			//Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
		}
		
		public function time_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "time_";
			var component:Array =  [timenow,timebar,timebar];
			var ob_cotainer:MultiObject = create(name + idx, component , mc);			
			ob_cotainer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			ob_cotainer.Post_CustomizedData = [[-37, 153], [630, 620],[840, 620]];			
			ob_cotainer.Create_(component.length);
			
			//default setting
			GetSingleItem(name + idx, now_time)["_text"].text = time_format.get_time("yyyy/MM/dd  hh:mm:ss");
			GetSingleItem(name + idx, bar_from)["_text"].text = "from  " +time_format.get_time("MM / dd  hh:mm");
			GetSingleItem(name + idx, bar_to)["_text"].text = "  To  " +time_format.get_time("MM / dd  hh:mm") ;			
			
			//_tool.SetControlMc(ob_cotainer.ItemList[1]);
			//_tool.y = 50;
			//add(_tool);
			
			//specialize setting
			var mc:MovieClip = GetSingleItem(name + idx, bar_from);
			var bg:MovieClip = utilFun.GetClassByString("time_bar_bg");
			bg.x = -40;
			bg.y = -11;
			mc.addChildAt(bg,0);
			
			put_to_lsit(ob_cotainer);	
		}
		
		public function updatetimer():void
		{
			var time:String = time_format.get_time("yyyy/MM/dd  hh:mm:ss");
			GetSingleItem(arguments[0] + arguments[1], now_time)["_text"].text = time;
			
			var time2:String = time_format.get_time("MM / dd  hh:mm");
			GetSingleItem(arguments[0] + arguments[1], bar_from)["_text"].text =  "from  " + time2;
			
			var pointor:MovieClip = GetSingleItem("pullbar_" + "1", 0);
			_progressbar.time_scale_update(pointor);			
			
		}
		
		override public function disappear():void
		{	
			var time_bar_container:MultiObject = Get("time_bar_container");
			time_bar_container.container.visible = false;
		}
		
		override public function test_suit():void
		{
		
		}
	}

}