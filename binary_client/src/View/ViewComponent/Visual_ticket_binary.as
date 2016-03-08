package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;	
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import Model.modelName;
	import View.GameView.gameState;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_ticket_binary  extends VisualHandler
	{
		
		public function Visual_ticket_binary() 
		{
			
		}
		
		public function init():void
		{			
			
			var stockchat:MultiObject = create("stage_3_ticket", ["stage_3_ticket"] );	
			stockchat.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stockchat.Post_CustomizedData = [3, 600, 247];
			stockchat.Create_(9);
			stockchat.container.x = 80;
			stockchat.container.y = 268;
			setFrame("stage_3_ticket", 1);
			
			put_to_lsit(stockchat);
			
			var font:Array = [ { size:24, align:_text.align_center,bold:true, color:0x000000 } ];			
			font = font.concat(_model.getValue("current_list"));
			var ticket_name:MultiObject = create("ticket_name", [ResName.TextInfo] );	
			ticket_name.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			ticket_name.Post_CustomizedData = [3, 600, 251];
			ticket_name.CustomizedData = font;
			ticket_name.CustomizedFun = _text.textSetting;
			ticket_name.Create_(9);
			ticket_name.container.x = -126;
			ticket_name.container.y = 280;
			
			put_to_lsit(ticket_name);
			
			var stage_btn:MultiObject = create("stage_3_btn", ["stage_3_btn"] );	
			stage_btn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 3, 2]);
			stage_btn.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage_btn.Post_CustomizedData = [3, 600, 247];
			stage_btn.Create_(9);
			stage_btn.container.x = 497;
			stage_btn.container.y = 354;
			
			put_to_lsit(stage_btn);
			
			//票卷種類
			var stage3_ticket_type:MultiObject = create("stage_3_ticket_type", ["stage_3_ticket_type"] );	
			stage3_ticket_type.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			stage3_ticket_type.Post_CustomizedData = [3, 600, 247];
			stage3_ticket_type.Create_(9);
			stage3_ticket_type.container.x = 83;
			stage3_ticket_type.container.y = 318;			
			
			put_to_lsit(stage3_ticket_type);
			
			//購買種類漲跌點數
			var font:Array = [ { size:24, align:_text.align_center,bold:true, color:0x000000 } ];			
			font = font.concat([100,200,300,400,500,600,700,800,900]);
			var by_point:MultiObject = create("by_point", [ResName.TextInfo] );	
			by_point.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			by_point.Post_CustomizedData = [3, 600, 250];
			by_point.CustomizedData = font;
			by_point.CustomizedFun = _text.textSetting;
			by_point.Create_(9);
			by_point.container.x = -126;
			by_point.container.y = 360;
			
			put_to_lsit(by_point);
			
			//購入數量,到期支付,棄權回報 字樣
			//var font:Array = [ { size:24, align:_text.align_center,bold:true, color:0xEEDD7E } ];			
			//font = font.concat([100,200,300,400,500,600,700,800,900]);
			//var by_point:MultiObject = create("by_point", [ResName.TextInfo] );	
			//by_point.Posi_CustzmiedFun =  _regular.Posi_Row_first_Setting;
			//by_point.Post_CustomizedData = [3, 600, 250];
			//by_point.CustomizedData = font;
			//by_point.CustomizedFun = _text.textSetting;
			//by_point.Create_(9);
			//by_point.container.x = -126;
			//by_point.container.y = 360;
			
			
			
			state_parse([gameState.END_ROUND]);
			
		}
		
		override public function appear():void
		{
			setFrame("stage_3_ticket", 2);
			
			var stock:MultiObject = Get("stage_3_ticket");		
			//
			//stock.CustomizedFun = mystockchat;
			//stock.FlushObject();
			
			var item_name:MultiObject = Get("item_name");
			item_name.CustomizedData = _model.getValue("current_list");
			item_name.CustomizedFun = _text.text_update;
			item_name.FlushObject();
			
			setFrame("stage_3_btn", 2);
			var stage_btn:MultiObject = Get("stage_3_btn");
			stage_btn.mousedown = item_select;
			stage_btn.mouseup = empty_reaction;
			stage_btn.FlushObject();			
			
			//setFrame("stage_3_ticket_type", 2);
			var stage3_ticket_type:MultiObject = Get("stage_3_ticket_type");
			stage3_ticket_type.CustomizedData = [2, 3, 4, 5, 2, 3, 4, 5, 2];
			stage3_ticket_type.CustomizedFun =  _regular.FrameSetting;
			stage3_ticket_type.FlushObject();
			
			var by_point:MultiObject = Get("by_point");
			by_point.CustomizedData = [100, 200, 300, 400, 500, 600, 700, 800, 900];
			by_point.CustomizedFun = _text.text_update;
			by_point.FlushObject();
			
		}
		
		override public function disappear():void
		{
			
			clean_child("stage_3_ticket");
			setFrame("stage_3_ticket", 1);
			
			
			setText("item_name", "");			
			
			setFrame("stage_3_btn", 1);			
			var stage_btn:MultiObject = Get("stage_3_btn");
			stage_btn.mousedown = null;
			stage_btn.mouseup = null;
			
			setFrame("stage_3_ticket_type", 1);	
			
			setText("by_point", "");			
			
		}
		
		public function item_select(e:Event, idx:int):Boolean
		{
			utilFun.Log("idx= "+idx);
			return true;
		}		
		
	}

}