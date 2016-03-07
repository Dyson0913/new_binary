package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;		
		
		private var _rule_table:MultiObject ;
		
		//res
		public const paytable_btn:String = "btn_paytable";
		public const rebet_btn:String = "btn_rebet";
		public const ruletable:String = "rule_table";
		
		//res
		public const scaletext:String = "scale_text";
		//tag
		private const theme_text:int = 0;
			
		//res
		public const theme:String = "theme_binary";
		//tag
		private const theme_title:int = 0;
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function init():void
		{
				//最少,最多字樣 ,現價bar hard to define put where
			var title_container:MultiObject = create("title_container", [ResName.emptymc]);
			title_container.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			title_container.Post_CustomizedData = [2, 850, 0];			
			title_container.CustomizedFun = theme_init;
			title_container.CustomizedData = [1, 2];
			title_container.container.x = 897;
			title_container.container.y = 910;
			title_container.Create_(2);
			
			put_to_lsit(title_container);
			
			_model.putValue("money_high", 100000);
			//時間刻度及金額高低 hard to define put where
			var title_text_container:MultiObject = create("title_text_container", [ResName.emptymc]);
			title_text_container.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			title_text_container.Post_CustomizedData = [[0,0],[10,0],[854,0],[5,299],[854,295]];			
			title_text_container.CustomizedFun = title_text_init;
			title_text_container.CustomizedData = ["now","","1day","100","100000"];
			title_text_container.container.x = 836;
			title_text_container.container.y = 633;
			title_text_container.Create_(5);
			
			put_to_lsit(title_text_container);
			
			state_parse([gameState.START_BET]);
		}		
		
		//public function scal(mc:MovieClip, idx:int, data:Array):void
		//{		
			//utilFun.scaleXY(mc, 0.68, 0.68);
		//}
		
		private function price_update(name:String,idx:int ):void
		{
			var price:Number = 8400+ utilFun.Random(40) -20 ;
			GetSingleItem(name + idx, idx)["_text"].text = "現價:" +price.toFixed(2);
		}
		
			public function theme_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "theme_";
			var component:Array =  [theme];
			var progress_bar:MultiObject = create(name + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0]];			
			progress_bar.Create_(component.length);
			GetSingleItem(name + idx, theme_title).gotoAndStop(data[idx]);			
			
			//custzmied			
			//if ( idx == 1) 	GetSingleItem("progress_" + idx, style)["_sec_bar"].gotoAndStop(4);
			
			//object_init("progress_"+idx, percent);
			
			put_to_lsit(progress_bar);
		}
		
		
		public function title_text_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "title_text_";
			var component:Array =  [scaletext];
			var progress_bar:MultiObject = create(name + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0]];
			progress_bar.Create_(component.length);
			GetSingleItem(name + idx, theme_text)["_text"].text = data[idx];
			
			//custzmied			
			//if ( idx == 1) 	GetSingleItem("progress_" + idx, style)["_sec_bar"].gotoAndStop(4);
			
			//object_init("progress_"+idx, percent);
			
			put_to_lsit(progress_bar);
		}
		
		
		public function table_true(e:Event, idx:int):Boolean
		{
			_rule_table.container.visible = !_rule_table.container.visible;				
			return true;
		}
		
		public function rebet_fun(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("mybtn_group");
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
			
			_betCommand.re_bet();
			dispatcher(new StringObject("sound_rebet","sound" ) );
			return false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			//Log("_betCommand.need_rebet() ="+_betCommand.need_rebet());
			//if ( !_betCommand.need_rebet() )
			//{
				//can_not_rebet()				
			//}
			//else
			//{
				//can_rebet();
			//}		
			
		}
		
		public function can_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(1);
			betzone.rollout = empty_reaction;
			betzone.rollover = empty_reaction;
			betzone.mousedown = rebet_fun;
			betzone.mouseup = empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "can_not_rebet")]
		public function can_not_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
		}
		
		
		
	}

}