package View.ViewComponent 
{
	import flash.display.MovieClip;		
	import flash.events.Event;	
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
	
	
	
	/**
	 * downlist present way
	 * @author Dyson0913
	 */
	public class Visual_downList  extends VisualHandler
	{		
		//res		
		public const productbg:String = "product_bg";
		public const productbtn:String = "product_btn";		
		public const productitem_bg:String = "product_item_bg";		
		public const productitem_conext:String = "product_item_conext";		
		
		//tag
		private const item_conext:int = 0;		
		
		[Inject]
		public var _FinancialGraph:Visual_FinancialGraph;
		
		public function Visual_downList() 
		{
			
		}
		
		public function init():void
		{
			var down_list_container:MultiObject = create("down_list_container", [ResName.emptymc]);			
			down_list_container.CustomizedFun = down_init;
			down_list_container.CustomizedData = ["TWSE", "NASDAQ","TPS","NYSE","SP500"];
			down_list_container.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			down_list_container.Post_CustomizedData = [2, 500, 0];			
			down_list_container.container.x = 240;
			down_list_container.container.y = 110;
			down_list_container.Create_(1);
			
			put_to_lsit(down_list_container);	
			
			//control model
			_model.putValue("down_list", [0,0]);
		   
			_model.putValue("down_select", 0 );
		   disappear();		   
		}
		
		
		
		public function down_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "down_list";
			var component:Array =  [productitem_conext];
			var ob_cotainer:MultiObject = create(name + idx, component , mc);			
			ob_cotainer.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			ob_cotainer.mousedown = down_list;
			ob_cotainer.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;			
			ob_cotainer.Post_CustomizedData = [5, 0, 0];			
			ob_cotainer.Create_(5);
			
			//default setting			
			for ( var i:int = 0; i < component.length; i++)
			{
				GetSingleItem(name + idx, i)["_text"].text = data[i];
			}
			
			
			//specialize setting
			var mid:int = 0;
			if ( component.length % 2 == 0) mid = component.length / 2 ;
			else mid = Math.floor( component.length / 2);			
			for ( var i:int = 0; i < mid; i++)
			{
				ob_cotainer.order_switch(i, component.length - (1 + i));
				
			}
			
			var bg_idx:int =0;
			for ( var i:int = 0; i < component.length; i++)
			{
				Log("order = " + ob_cotainer.container.getChildIndex(ob_cotainer.ItemList[i]));
				//var mc:MovieClip
				//mc.getChildIndex(
				if ( i == bg_idx )
				{
					var mc:MovieClip = GetSingleItem(name + idx, bg_idx);
					var bg:MovieClip = utilFun.GetClassByString(productbg);
					bg.x = -16;
					bg.y = -22;
					mc.addChildAt(bg, 0);
					
					//var btns:MovieClip = utilFun.GetClassByString(productbtn);
					//btns.name = "btn";
					//btns.x = 387;
					//btns.y = 2;
					//mc.addChild(btns);
				}
				else
				{
					var mc:MovieClip = GetSingleItem(name + idx, i);
					var bg:MovieClip = utilFun.GetClassByString(productitem_bg);					
					bg.y = -5;
					mc.addChildAt(bg,0);
				}
			}
			
			
			
			
			put_to_lsit(ob_cotainer);	
		}
		
		public function get_Container_idx(name:String):int
		{			
			var contain_name_with_idx:String = name.substr(0 ,name.length - 1);
			var contain_idx:String = contain_name_with_idx.substr(contain_name_with_idx.length -1 , contain_name_with_idx.length);
			return parseInt( contain_idx);
		}
		
		public function down_list(e:Event, idx:int):Boolean
		{
			var contain_idx:int = get_Container_idx(e.currentTarget.name);
			
			var mu:MultiObject = Get("down_list" + contain_idx.toString());
			var _diff:Number = 52;
			var open:Array = _model.getValue("down_list");
			if ( open[contain_idx] == 0) 
			{
				for (var i:int = 0; i < mu.ItemList.length; i++)
				{
					if ( i == 0) continue;
					Tweener.addTween(mu.ItemList[i], { y: i * _diff + 20, transition: "easeOutCubic", time: 0.5 } );				
				}
				open[contain_idx] = 1;
			}
			else
			{
				for (var i:int = 0; i < mu.ItemList.length; i++)
				{
					
					if ( i == 0) continue;
					Tweener.addTween(mu.ItemList[i], { y: 0, transition: "easeOutCubic", time: 0.5 } );				
				}
				open[contain_idx] = 0;
				Log("conitx = " + idx);
				var taget_childIdx:int = mu.container.getChildIndex(mu.ItemList[idx]);				
				mu.order_switch(taget_childIdx, mu.ItemList.length - 1);
				
				_FinancialGraph.reset_chat();
			}
			
			
			_model.putValue("down_select", idx);
			return true;
		}
		
		
		
		
	}

}