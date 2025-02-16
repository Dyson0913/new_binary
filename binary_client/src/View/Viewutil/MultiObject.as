package View.Viewutil 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObjectContainer;
	import Interface.ViewComponentInterface;
	
	import util.utilFun;
	
	
	/**
	 * 一次生成多個有規則排列的元件 
	 * @author hhg4092
	 */
	public class MultiObject implements ViewComponentInterface
	{
		private var _Container:DisplayObjectContainer;
		
		private var _autoClean:Boolean;
		
		//元件列表
		private var _ItemList:Array = [];		
		
		public function get ItemList():Array
		{
			return _ItemList;
		}
		
		public var stop_Propagation:Boolean = false;

		private var _ItemNameList:Array = [];
		
		public function get resList():Array
		{
			return _ItemNameList;
		}
		
		public function set resList(value:Array ):void
		{
			_ItemNameList = value;
		}
		
		//客制化功能
		public var CustomizedFun:Function = null;
		public var CustomizedData:Array = null;
		public var MouseFrame:Array = [];
		
		public var Posi_CustzmiedFun:Function = null;
		public var Post_CustomizedData:Array = null;
		//各事件接口
		public var rollout:Function;
		public var rollover:Function;
		public var mousedown:Function;
		public var mouseup:Function;
		
		public var _drag_handle:Function = null;
		
		//元件命名
		private var _ItemName:String;		
		private var _contido:Boolean;
		
		
		
		public function MultiObject() 
		{
			_autoClean =  false;
		}
		
		public function set autoClean(value:Boolean):void
		{
			_autoClean =  value;
		}
		
		
		public function get container():DisplayObjectContainer
		{
			return _Container;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return _Container;
		}
		
		public function setContainer(contain:DisplayObjectContainer):void
		{
			_Container = contain;
		}
		
		public function Create_(ItemNum:int):void
		{
			CleanList();
			
			compensatory_diff(ItemNum);
			_ItemName = _Container.name;
			for (var i:int = 0 ; i < ItemNum; i++)
			{
				var mc:MovieClip = utilFun.GetClassByString(resList[i]);				
				mc.name = _ItemName + i;
				
				ItemList.push(mc);
				_Container.addChild(mc);
			}
			
			//customized area		
			customized();			
			Listen();
		}		
		
		private function compensatory_diff(num:int):void
		{
			var diff:int = num - resList.length;
			if ( diff >0)
			{
				var lastItem:String = resList[ resList.length - 1];
				for ( var j:int = 0; j < diff ;j++) resList.push(lastItem);
			}
		}
		
		public function customized():void
		{
			var ItemNum:int = ItemList.length;
			for (var i:int = 0 ; i < ItemNum; i++)
			{			
				if (CustomizedFun != null)
				{
					if ( CustomizedData != null)
					{
						CustomizedFun(ItemList[i], i, CustomizedData);
					}
				}
				
				if (Posi_CustzmiedFun != null)
				{
					Posi_CustzmiedFun(ItemList[i], i,Post_CustomizedData);
				}
				
			}
		}
		
		public function FlushObject():void
		{
			var ItemNum:int = ItemList.length;
			for (var i:int = 0 ; i < ItemNum; i++)
			{			
				if (CustomizedFun != null)
				{
					CustomizedFun(ItemList[i], i,CustomizedData);
				}
			}
		}
		
		public function FlushObject_bydata():void
		{
			var ItemNum:int = ItemList.length;
			var dataNum:int = CustomizedData.length;
			for (var i:int = 0 ; i < ItemNum; i++)
			{			
				if (CustomizedFun != null)
				{
					if ( i >= dataNum ) ItemList[i].visible = false;
					else 
					{
						ItemList[i].visible = true;
						CustomizedFun(ItemList[i], i,CustomizedData);
					}
				}
			}
		}
		
		public function exclusive(idx:int,gotoFrame:int):void
		{
			for (var i:int = 0; i < _ItemList.length; i++)
			{
				if ( i == idx ) continue;
				else _ItemList[i].gotoAndStop(gotoFrame);
			}
		}
		
		public function CleanList():void
		{
			//removeListen();
			var cnt:int = ItemList.length;
			for ( var i:int = 0; i < cnt; i++)
			{
				_Container.removeChild(ItemList[i]);
			}
			
			ItemList.length = 0;
		}
		
		public function OnExit():void
		{
			if( _autoClean ) CleanList();
		}
		
		public function getName():String
		{
			return _Container.name;
		}
		
		public function getDisplayobject():DisplayObjectContainer
		{
			return _Container;
		}
		
		public function Clear_ItemChildren():void
		{
			//removeListen();
			var cnt:int = ItemList.length;			
			for ( var i:int = 0; i < cnt; i++)
			{
			
				utilFun.Clear_ItemChildren(ItemList[i]);
			}			
		}
		
		
		public function put_to_lsit(viewcomponent:ViewComponentInterface):void
		{
			ItemList.push(viewcomponent);
		}
		
		public function Getidx(name:String):int 
		{
			var s:String = utilFun.Regex_CutPatten(name, new RegExp(_ItemName, "i"));
			return parseInt(s);
		}
		
		//playerCon.container.getChildIndex(item)
		public function order_switch(target:int ,to:int):void
		{			
			_Container.swapChildrenAt(target, to);
		}
		
		public function Drag(idx:int,handle:Function):void
		{
			_drag_handle = handle;
			ItemList[idx].addEventListener(MouseEvent.MOUSE_DOWN, cut_name);			
		}
		
			public function cut_name(e:Event):void
		{
			//utilFun.Log("cut_name ="+ e.currentTarget.name);
			//utilFun.Log("cut_name =" + _ItemName);
			var pa_st:String = _ItemName.substr(_ItemName.length - 1, _ItemName.length);
			
			if( _drag_handle != null ) _drag_handle(e, parseInt(pa_st));
		}
		
		private function Listen():void
		{
			var N:int =  ItemList.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{
				if ( MouseFrame[0] != 0) ItemList[i].addEventListener(MouseEvent.ROLL_OUT, eventListen);
				if ( MouseFrame[1] != 0) ItemList[i].addEventListener(MouseEvent.ROLL_OVER, eventListen);
				if ( MouseFrame[2] != 0) ItemList[i].addEventListener(MouseEvent.MOUSE_DOWN, eventListen);
				if ( MouseFrame[3] != 0) ItemList[i].addEventListener(MouseEvent.MOUSE_UP, eventListen);
			}
			//var mc:MovieClip
			//mc.addEventListener(MouseEvent.ROLL_OUT,eventListen,
		}
		
		public function removeListen():void
		{
			if ( MouseFrame.length == 0 ) return;
			
			var N:int =  ItemList.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{
				if ( MouseFrame[0] != 0) ItemList[i].removeEventListener(MouseEvent.ROLL_OUT, eventListen);
				if ( MouseFrame[1] != 0) ItemList[i].removeEventListener(MouseEvent.ROLL_OVER, eventListen);
				if ( MouseFrame[2] != 0) ItemList[i].removeEventListener(MouseEvent.MOUSE_DOWN, eventListen);
				if ( MouseFrame[3] != 0) ItemList[i].removeEventListener(MouseEvent.MOUSE_UP, eventListen);
			}
		}
		
		public function eventListen(e:Event):void
		{
			var idx:int = Getidx(e.currentTarget.name);
			switch (e.type)
			{
				case MouseEvent.ROLL_OUT:
				{
					if ( rollout != null) 
					{
						_contido = rollout(e,idx);
					    if( _contido ) utilFun.GotoAndStop(e, MouseFrame[0]);					
					}
				}
				break;
				case MouseEvent.ROLL_OVER:
				{
					if ( rollover != null)
					{
						_contido = rollover(e, idx);
						if( _contido ) utilFun.GotoAndStop(e, MouseFrame[1]);
					}
					
				}
				break;
				case MouseEvent.MOUSE_DOWN:
				{
					if ( mousedown != null) 
					{
						_contido = mousedown(e, idx);
						if ( _contido ) utilFun.GotoAndStop(e, MouseFrame[2]);
						
						if( stop_Propagation) e.stopPropagation();
					}
				}
				break;
				case MouseEvent.MOUSE_UP:
				{
					if ( mouseup != null) 
					{
						_contido = mouseup(e, idx);
						if ( _contido ) utilFun.GotoAndStop(e, MouseFrame[3]);
						
						if( stop_Propagation) e.stopPropagation();
					}
					
				}
				break;
			}
		}
		
	}

}