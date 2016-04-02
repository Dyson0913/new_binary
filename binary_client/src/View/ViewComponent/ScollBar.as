package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import util.*;
	import caurina.transitions.Tweener;
	import View.Viewutil.MultiObject;
	/**
	 * ...
	 * @author divia
	 */
	public class ScollBar  extends MovieClip
	{
		private var _view:Sprite;
		private var _track:track;
		private var _slider:slider;
		private var _old_container_y:int = 0;
		private var _container:DisplayObjectContainer;
		private var _mask:DisplayObjectContainer;
		
		
		/*
		 * view 底層容器
		 * container 目標容器
		 * $mask 遮罩容器
		 */ 
		public function ScollBar(view:Sprite, container:DisplayObjectContainer, $mask:DisplayObjectContainer) 
		{
			_view = view;
			_old_container_y = container.y;
			_container = container;
			_mask = $mask;
			_mask.addChild(this);
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			
			_track = new track();
			_track.height = _mask.height;
			_slider = new slider();
			
			_track.x = 720;
			_track.y = 588;
			_slider.x = 720;
			_slider.y = 588;
			
			//拖拉bar總長 * mask容器height/目標容器height
			_slider.height = _track.height *(_mask.height/_container.height) ;
			
			addChild(_track);
			addChild(_slider);
			
			_slider.buttonMode = true;
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			
			_view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			
			check();
		}
		
		private function check():void {
		//已全部顯示，不需顯示scollbar
			if (_mask.height/_container.height >= 1) {
				_track.visible = false;
				_slider.visible = false;
				_track.x = 720;
				_track.y = 588;
				_slider.x = 720;
				_slider.y = 588;
			}else {
				_track.visible = true;
				_slider.visible = true;
			}
			
		}
		
		public function remove():void 
		{
			_view.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
		}
		
		public function reSetScollBar():void {
			//拖拉bar總長 * mask容器height/目標容器height
			_slider.height = _track.height * (_mask.height / _container.height) ;
			
			_view.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			
			var minY:int = _track.y;
			var maxY:int = _track.height + _track.y - _slider.height;
			if (_slider.y < minY)
			{
				_slider.y = minY;
			}
			else if (_slider.y > maxY)
			{
				_slider.y = maxY;
			}
				
			check();
			
			moveHandler();
		}
		
		private function mDown(e:MouseEvent):void { 
			
			var newRect:Rectangle = new Rectangle(_track.x, _track.y,
												  0, _track.height - _slider.height);
			
			e.currentTarget.startDrag(false, newRect); 
			
			_slider.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_slider.addEventListener(MouseEvent.MOUSE_UP, disable); 
			
			_view.addEventListener(MouseEvent.MOUSE_UP, disable);
			
			moveHandler();
		} 
		
		private function onMouseWheelHandler($event:MouseEvent):void
		{
			// define parameters
			var scrollDistance:int = $event.delta;
			var minY:int = _track.y;
			var maxY:int = _track.height + _track.y - _slider.height;
			
			// check if there's room to scroll
			if ((scrollDistance > 0 && _slider.y <= maxY) ||
				(scrollDistance < 0 && _slider.y >= minY))
			{
				// move dragger
				_slider.y = _slider.y - (scrollDistance * 5);
				
				// make sure we don't come out of our boundries
				if (_slider.y < minY)
				{
					_slider.y = minY;
				}
				else if (_slider.y > maxY)
				{
					_slider.y = maxY;
				}
				
				// move content
				moveHandler();
			}
		}
		
		private function onEnterFrame(e:Event):void {
			moveHandler();
		}
		
		private function moveHandler():void {
			
			var p :Number =  (_slider.y -  _old_container_y) / Math.abs(_track.height - _slider.height);
			
			var pstr:String = p.toFixed(2);
			utilFun.Log("scollbar p:" + pstr);
			
			if (p < 0 || p > 1) {
				return;
			}
			
			//目標容器y原始座標 - 移動比率 * (目標容器height - 遮罩容器height)
			var y_move:Number = _old_container_y - p * (_container.height - _mask.height);
			
			if (y_move <= _old_container_y - _container.height ){
				utilFun.Log("over height");
				return;
			}
			
			utilFun.Log("y_move:" + y_move);
			//_container.y = y_move;
			Tweener.addTween(_container, { y:y_move, time:0.3,transition:"linear" } );
		}
		
		private function disable(e:MouseEvent):void {
			_slider.removeEventListener(MouseEvent.MOUSE_UP, disable); 
			e.currentTarget.stopDrag(); 
			
			_slider.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			moveHandler();
		}
		
	}

}