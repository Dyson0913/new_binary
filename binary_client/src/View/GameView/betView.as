package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*
	import Res.ResName;
	import util.DI;
	import Model.*
	import util.math.Path_Generator;
	import util.node;
	import View.ViewBase.Visual_Version;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;
	import util.*;
	import View.ViewComponent.*;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		[Inject]
		public var _theme:Visual_theme;
		
		[Inject]
		public var _Version:Visual_Version;
		
		[Inject]
		public var _downlist:Visual_downList;	
		
		[Inject]
		public var _debug_tool:Visual_debugTool;
		
		[Inject]
		public var _ticket_binary:Visual_ticket_binary;
		
		[Inject]
		public var _Item_list:Visual_Item_list;
		
		[Inject]
		public var _FinancialGraph:Visual_FinancialGraph;
		
		[Inject]
		public var _pop_hint:Visual_pop_hint;
		
		public function betView()  
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");			
			
			_tool = new AdjustTool();			
			
			var view:MultiObject = create("_view", [ResName.Bet_Scene], this);		
			view.Create_(1);
			
			
			_debug_tool.init();
			
			//share
			_theme.init();
			_page_arrow.init();		
			
			//stage 3 for order
			_ticket_binary.init();
			
			//stage 1
			_Item_list.init();		
			
			//stage 2			
			_progressbar.init();	
			_FinancialGraph.init();			
			_timer.init();		
			
			//top of all
			_downlist.init();
			_pop_hint.init();
			
		
						
			//dispatcher(new StringObject("Soun_Bet_BGM","Music" ) );
		}
		
		
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}		
	}

}