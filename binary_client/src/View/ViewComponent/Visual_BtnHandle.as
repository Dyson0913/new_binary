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
		public const theme:String = "scale_title";
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
			title_container.container.x = 897;
			title_container.container.y = 910;
			title_container.Create_(2);
			
			put_to_lsit(title_container);
			
			_model.putValue("money_high", 100000);
			//時間刻度及金額高低 hard to define put where
			var title_text_container:MultiObject = create("title_text_container", [ResName.emptymc]);		
			title_text_container.container.x = 836;
			title_text_container.container.y = 633;
			title_text_container.Create_(5);
			
			put_to_lsit(title_text_container);
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			var title_container:MultiObject = Get("title_container");
			title_container.CustomizedFun = theme_init;
			title_container.CustomizedData = [2, 3];
			title_container.FlushObject();
			
			var title_text_container:MultiObject = Get("title_text_container");
			title_text_container.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			title_text_container.Post_CustomizedData = [[0,0],[10,0],[854,0],[5,299],[854,295]];			
			title_text_container.CustomizedFun = title_text_init;
			title_text_container.CustomizedData = ["now", "", "1day", "100", "100000"];
			title_text_container.FlushObject();
		}	
		
		public function theme_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "theme_";
			var component:Array =  [theme];
			var progress_bar:MultiObject = create(name + idx, component , mc);
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
		
	}

}