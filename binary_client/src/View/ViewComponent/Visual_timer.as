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
		public const Timer:String = "countDowntimer";
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		//TODO intgergreat
		public const _Timer:String = "countDowntimer";
		
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
			var countDown:MultiObject = create(_Timer,[_Timer]);
			countDown.Create_(1);
			countDown.container.x = 1188;
			countDown.container.y = 528;
		   
			put_to_lsit(countDown);
		   
		   
			var time_bar_container:MultiObject = create("time_bar_container", [ResName.emptymc]);			
			time_bar_container.CustomizedFun = time_init;			
			time_bar_container.container.x = 490;
			time_bar_container.container.y = 50;
			time_bar_container.Create_(1);
			
			put_to_lsit(time_bar_container);	
			
		   
		   disappear();
		   
		   Waring_sec = 7;
		   
		   state_parse([gameState.START_BET]);
		}
		
		public function time_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "time_";
			var component:Array =  [timenow,timebar,timebar];
			var ob_cotainer:MultiObject = create(name + idx, component , mc);			
			ob_cotainer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			ob_cotainer.Post_CustomizedData = [[-37, 153], [650, 630],[860, 630]];			
			ob_cotainer.Create_(component.length);
			
			//default setting
			GetSingleItem(name + idx, now_time)["_text"].text = time_format.get_time("yyyy/MM/dd  hh:mm:ss");
			GetSingleItem(name + idx, bar_from)["_text"].text = "from  " +time_format.get_time("MM / dd  hh:mm");
			GetSingleItem(name + idx, bar_to)["_text"].text = "  To  " +time_format.get_time("MM / dd  hh:mm") ;			
			
			//specialize setting
			var mc:MovieClip = GetSingleItem(name + idx, bar_from);
			var bg:MovieClip = utilFun.GetClassByString("time_bar_bg");
			bg.x = -40;
			bg.y = -11;
			mc.addChildAt(bg,0);
			
			put_to_lsit(ob_cotainer);	
		}
		
		override public function appear():void
		{
			setInterval(updatetimer, 1000, "time_", 0);
			
			//setFrame(Timer, 2);
			//var time:int = _model.getValue(modelName.REMAIN_TIME);
			//frame_setting_way(time);
			//
			//Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
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
			setFrame(Timer, 1);			
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub, 1);
			if ( time < 0) 
			{
				return;
			}
			if ( time <= Waring_sec ) play_sound("sound_final");
			
			if (time == 0) {
				//注區停止押注
				var betzone:MultiObject = Get("betzone_s");
				betzone.mousedown = null;
				betzone.mouseup = null;
				betzone.rollout = null;
				betzone.rollover = null;
			
				 //停止上一個timer
				var preTimerIdx:int = 1
				
				utilFun.Log("preTimerIdx:" + preTimerIdx);
			
				//送出最後一張還在計時的注單
				if (preTimerIdx > -1 ) {
					//hide取消鈕
					GetSingleItem("coin_cancel", preTimerIdx).visible = false;
				//	_betCommand.sendBet(preTimerIdx);
				}
			}
			
			frame_setting_way(time);			
		}
		
		public function frame_setting_way(time:int):void
		{
			var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem(Timer)["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem(Timer)["_num_1"].gotoAndStop(arr[1]);
		}		
		
		override public function test_suit():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if ( state == gameState.START_BET )
			{
				test_frame_Not_equal( GetSingleItem(Timer) , 2);	
			}
			else if ( state != 0)
			{
				test_frame_Not_equal( GetSingleItem(Timer) , 1);	
			}
			else
			{
				Log("Visual_timer not  handle");
			}
		}
	}

}