package View.ViewComponent 
{
	import flash.display.MovieClip;		
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import util.time.time_format;
	import Command.*;
	import flash.utils.setInterval;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import View.GameView.gameState;
	
	
	/**
	 * downlist present way
	 * @author Dyson0913
	 */
	public class Visual_downList  extends VisualHandler
	{		
		//res		
		public const productbg:String = "product_bg";
		public const productbtn:String = "product_btn";		
		public const productitem_conext:String = "product_item_conext";
		
		[Inject]
		public var _page_arrow:Visual_page_arrow;
		
		public function Visual_downList() 
		{
			
		}
		
		public function init():void
		{			
			var all_list:Array = _model.getValue("all_catalog");
			
			//所有商品下拉選單
			var all_font:Array = [ { size:30, align:_text.align_left, bold:true, color:0x999999 } ];
			all_font = all_font.concat([]);
			var catalog:MultiObject = create("catalog_0", [productitem_conext]);	
			catalog.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);		
			catalog.mousedown = cata_pulldown;			
			catalog.CustomizedData = all_font;
			catalog.CustomizedFun = _text.textSetting;
			catalog.container.x = 71;
			catalog.container.y = 207;
			catalog.Create_(all_list.length);
			
			//目錄不會再變更
			catalog.CustomizedFun = _text.text_update;
			catalog.CustomizedData = all_list;
			catalog.FlushObject_bydata();
			
			//TODO 選最多個的生成
			var all_item:Array = _model.getValue("all_list")[0];
			var catalog_1:MultiObject = create("catalog_1", [productitem_conext]);	
			catalog_1.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);		
			catalog_1.mousedown = cata_item_pulldown;
			catalog_1.CustomizedData = all_font;
			catalog_1.CustomizedFun = _text.textSetting;
			catalog_1.container.x = 431;
			catalog_1.container.y = 207;
			catalog_1.Create_(all_item.length);
			
			put_to_lsit(catalog_1);
			
			//下拉底圖
			var bg:MultiObject = create("down_bg", [productbg]);
			bg.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			bg.Post_CustomizedData = [2, 360, 0];
			bg.container.x = 63;
			bg.container.y = 172;
			bg.Create_(2);
			
			
			//目前選擇項目
			var all_catalog:Array = _model.getValue("all_catalog");
			var one_catalog_data:Array = _model.getValue("one_catalog_data");
			var tart_font:Array = [ { size:30, align:_text.align_left,bold:true, color:0x999999 } ];			
			tart_font = tart_font.concat([all_catalog[0],one_catalog_data[0]]);
			var select_item:MultiObject = create("select_item", [productitem_conext]);
			select_item.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);	
			select_item.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			select_item.Post_CustomizedData = [2, 360, 0];
			select_item.mousedown = catalog_select;			
			select_item.container.x = 71;
			select_item.container.y = 192;
			select_item.CustomizedData = tart_font;
			select_item.CustomizedFun = _text.textSetting;	
			select_item.Create_(2);			
			
			//下拉開關
			var btn:MultiObject = create("down_btn", [productbtn]);
			btn.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);	
			btn.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			btn.Post_CustomizedData = [2, 360, 0];
			btn.mousedown = catalog_select;
			btn.mouseup = empty_reaction;
			btn.container.x = 333;
			btn.container.y = 192;
			btn.Create_(2);
			
			
			
		   state_parse([gameState.NEW_ROUND,gameState.START_BET,gameState.END_ROUND]);
		}	
		
		
		override public function appear():void
		{
			
			var all_item:Array = _model.getValue("one_catalog_data");
			
			var cate_item:MultiObject = Get("catalog_1");		
			cate_item.CustomizedData = all_item;
			cate_item.CustomizedFun = _text.text_update;			
			cate_item.FlushObject_bydata();		
			
			utilFun.Log("downlsit = " + _model.getValue("current_item")); 
			_text_update("select_item", 1, _model.getValue("current_item"));				
		}		
		
		public function catalog_select(e:Event, idx:int):Boolean
		{
			pull_effect(idx);
			
			return false;
		}
		
		private function pull_effect(idx:int):void 
		{
			var mu:MultiObject =  Get("catalog_" + idx);			
			var _diff:Number = 43;			
			for ( var i:int = 0; i < mu.ItemList.length; i++)
			{
				Tweener.addTween(mu.ItemList[i], { y: (i+1) * _diff , transition: "easeOutCubic", time: 0.5 } );				
			}		
		}
		
		private function pull_back_effect(idx:int):void 
		{
			var mu:MultiObject =  Get("catalog_" + idx);
			for (var i:int = 0; i < mu.ItemList.length; i++)
			{
				Tweener.addTween(mu.ItemList[i], { y: 0, transition: "easeOutCubic", time: 0.5 } );				
			}
		}
		
		
		public function cata_pulldown(e:Event, idx:int):Boolean
		{
			pull_back_effect(0);
			_text_update("select_item", 0, e.currentTarget.getChildByName("Dy_Text").text);
			dispatcher(new ModelEvent("first_pull_update", idx));
			
			appear();
			
			return true;
		}
		
		public function cata_item_pulldown(e:Event, idx:int):Boolean
		{
			pull_back_effect(1);
			_text_update("select_item", 1, e.currentTarget.getChildByName("Dy_Text").text);
			dispatcher(new ModelEvent("sec_pull_update", idx));
			//_text_update("select_item", 1, e.currentTarget.getChildByName("Dy_Text").text);
			
			
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "page_update")]
		public function page_upate(para:ModelEvent):void
		{
			if ( !_diplay ) return;			
			appear();
		}
		
		private function _text_update(target_name:String,_taget_idx:int ,str:String):void
		{
			var target_ob:MultiObject = Get(target_name);
			_text.text_update(target_ob.ItemList[_taget_idx], 0, [str]);
		}
		
	}

}