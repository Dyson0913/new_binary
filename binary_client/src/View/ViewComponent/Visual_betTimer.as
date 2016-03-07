package View.ViewComponent 
{	
	import View.ViewBase.VisualHandler;		
	import util.*;
	
	import View.Viewutil.*;
	import Res.ResName;	
	import View.GameView.gameState;
	import Model.modelName;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * Visual_betTimer
	 * @author David
	 */
	public class Visual_betTimer  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;	
		
		public const NEW_SECOND:int = 3;
		private var sec_array:Array = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		
		private var current_idx:int = -1;
		
		public function Visual_betTimer() 
		{
			
		}
		
		public function init():void
		{			
			
			var bet_timer_xy:Array = _model.getValue(modelName.COIN_BETTIMER_XY);
			
			//倒數
			var bet_timer:MultiObject = create("bet_timer",["bet_timer"]);
		    bet_timer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet_timer.Post_CustomizedData = bet_timer_xy;
			bet_timer.Create_(12);
		    bet_timer.container.x = 3;
		    bet_timer.container.y = 615;
		   
		    // utilFun.scaleXY(Get("bet_timer").container, 0.8, 0.8);
			
			put_to_lsit(bet_timer);
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{	
			Get("bet_timer").container.visible = true;
			 setFrame("bet_timer", 2);
			 
			 for each(var timer_mc:* in Get("bet_timer").ItemList) {
				timer_mc.visible = false;
			}
		}
		
		override public function disappear():void
		{
			Get("bet_timer").container.visible = false;
			
			//停止所有Timer
			for each(var timer_mc:* in Get("bet_timer").ItemList) {
				Tweener.removeTweens(timer_mc);
			}
			//初始秒數資料
			 sec_array = [ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
			 setFrame("bet_timer", 1);	
			 
		}
		
		public function TimerStart(idx:int):void {
			
			//停止上一個timer
			var preTimerIdx:int = StopCurrentTimer();
			
			//送出前一次押注的注單
			if (preTimerIdx > -1 && preTimerIdx != idx) {
				
				GetSingleItem("coin_cancel", preTimerIdx).visible = false;
				GetSingleItem("coin_cancel", preTimerIdx).gotoAndStop(1);
				
				_betCommand.sendBet(preTimerIdx);
			}
			
			sec_array[idx] = NEW_SECOND;
			var time:int = sec_array[idx];
			frame_setting_way(idx, time);
				
			//讓秒數計到-1，方便判斷hide bet_timer元件
			var update_count:int = time + 1;
			Tweener.addCaller(GetSingleItem("bet_timer", idx), {  time:update_count , count: update_count, onUpdate:TimeCount , onUpdateParams:[idx],  transition:"linear" } );
				
			current_idx = idx;
				
			GetSingleItem("bet_timer", idx).visible = true;
		}
		
		private function TimeCount(idx:int):void
		{			
			var time:int  = sec_array[idx] - 1;
			if ( time < 0) {
				StopCurrentTimer();
				//hide取消
				GetSingleItem("coin_cancel", idx).visible = false;
				
				//倒數結束送單
				_betCommand.sendBet(idx);

				return;
			}

			frame_setting_way(idx, time);		
			
			sec_array[idx] = time;
		}
		
		public function StopCurrentTimer():int {
			if(current_idx > -1){
				Tweener.removeTweens(GetSingleItem("bet_timer", current_idx));
				GetSingleItem("bet_timer", current_idx).visible = false;
				
				var pre_idx:int = current_idx;
				current_idx = -1;
				
				return pre_idx;
			}
			
			return -1;
		}
		
		public function frame_setting_way(idx:int, time:int):void
		{
			var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem("bet_timer", idx)["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem("bet_timer", idx)["_num_1"].gotoAndStop(arr[1]);
		}		
		
	}

}