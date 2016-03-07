package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.*;
	import util.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;	
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author Dyson0913
	 */
	public class Visual_Hintmsg  extends VisualHandler
	{
		public const Hint:String = "HintMsg";
		
		private var frame_start_bet:int = 2;
		private var frame_stop_bet:int = 3;
		private var frame_pre_open:int = 4;
		private var frame_open_card:int = 5;
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var Hintmsg:MultiObject = create(Hint, [Hint]);
			Hintmsg.Create_(1);
			Hintmsg.container.x = 951.65;
			Hintmsg.container.y = 507.80;
			
			put_to_lsit(Hintmsg);
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			set_frame(frame_start_bet);
			play_sound("sound_start_bet");			
		}
		
		override public function disappear():void
		{			
			var state:int = _model.getValue(modelName.GAMES_STATE);
			var frame:int = 1;
			if ( state == gameState.NEW_ROUND) frame = frame_pre_open;
			if ( state == gameState.END_BET)
			{
				frame = frame_stop_bet;
				play_sound("sound_stop_bet");
			}
			
			if ( state == gameState.START_OPEN) frame = frame_open_card;
			set_frame(frame);			
		}
		
		private function set_frame(frame:int):void
		{
			GetSingleItem(Hint).gotoAndStop(frame);
			if ( frame == frame_pre_open) return;
			_regular.FadeIn( GetSingleItem(Hint), 2, 2, _regular.Fadeout);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			set_frame(6);
		}
		
		override public function test_suit():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if ( state == gameState.NEW_ROUND )
			{				
				test_frame_Not_equal( GetSingleItem(Hint) , frame_pre_open);			
			}
			else if ( state == gameState.START_BET )
			{
				test_frame_Not_equal( GetSingleItem(Hint) , frame_start_bet);	
			}
			else if ( state == gameState.END_BET)
			{
				test_frame_Not_equal( GetSingleItem(Hint) , frame_stop_bet);	
			}
			else if ( state == gameState.START_OPEN )
			{
				test_frame_Not_equal( GetSingleItem(Hint) , frame_open_card);	
			}
			else if ( state == gameState.END_ROUND )
			{
				test_frame_Not_equal( GetSingleItem(Hint) , 1);
			}
			else 
			{
				Log("Visual_Hintmsg not  handle");
			}
		}
	}

}