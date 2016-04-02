package View.GameView
{	
	import Command.*;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
	import Model.valueObject.Intobject;
	import Model.valueObject.StringObject;
	import Res.ResName;
	import util.DI;
	import util.node;
	import View.ViewBase.ViewBase;
	import Command.DataOperation;
	import flash.text.TextFormat;
	import View.ViewComponent.*;
	import View.Viewutil.*;
	
	import Model.*;
	import util.utilFun;
	import caurina.transitions.Tweener;	
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _sound:SoundCommand;
		
		[Inject]
		public var _test:Visual_testInterface;
		
		public function LoadingView()  
		{
			
		}
		
		public function FirstLoad(para:Array ):void
 		{			
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			_model.putValue(modelName.Domain_Name, para[4]);			
			
			_betCommand.bet_init();
			_sound.init();
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			var view:MultiObject = create("_view", [ResName.emptymc], this);		
			view.Create_(1);
					
			//utilFun.SetTime(connet, 0.1);
			//_test.init();
			
			dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );			
			//
			_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
			dispatcher(new ModelEvent("update_state"));
			
			
		}
		private function connet():void
		{	
		
			//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}