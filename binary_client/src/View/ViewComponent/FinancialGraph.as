package View.ViewComponent
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import util.utilFun;
	import caurina.transitions.Tweener;
	
	public class FinancialGraph extends MovieClip
	{
		public var granularity : int = 10;
		public var variation : Number = 0.5;
		
		public var gridColor : uint = 0x8080c0;
		public var gridThickness : uint = 1;
		
		public var borderColor : uint = 0xc0c0c0;
		public var borderThickness : uint = 2;
		
		public var bgColor : uint = 0x333333;
		public var graphColor : uint = 0x8080ff;
		public var graphThickness : uint = 2;
		
		public var graphGradientColors:Array = [0x000000, 0x000000];
		public var graphGradientAlphas:Array = [1, 0];
		
		public var graphHeight:Number;
		public var graphWidth:Number;
		
		public var _yestoday_close_price:Number;
		public var heart:MovieClip;
		
		public var _newdate:Array = [];		
		public var _current_idx:int = 0;
		
		public var _old_x:Number;
		public var _old_y:Number;
		
		public var _new_x:Number = 0;
		public var _new_y:Number = 0;
		public var pan_color:Array = [0xFF0000, 0x66CC66]; //red,green
		
		/**
		 * Creates random line graphs that simulate stock price charts.
		 */
		public function FinancialGraph()
		{
			super();			
		}
		
		public function setSize(w:Number = 740, h:Number = 310, graphColor:uint = 0x8080ff):void
		{
			this.graphWidth = w;
			this.graphHeight = h;
			this.graphColor = graphColor;			
			
			//heart = utilFun.GetClassByString("financial_heart");
			//heart.x = w -20;
			//heart.y = h - h+20;
			//addChild(heart);
			//heart_();
			
			
			drawPoint();
			//redraw();
		}
		
		//有data 才開始draw point
		public function init():void 
		{			
			//static draw
			//drawPoint();
			//redraw();
		}
		
		
		public function dotloop(endX:Number,endy:Number,color:int):void
		{			
			_new_x += endX;
			_new_y += endy;
			
			graphics.moveTo(_old_x, _old_y);
			graphics.lineStyle( 2, pan_color[color] );		
			graphics.lineTo(_new_x, _old_y  -_new_y );
			//cross mid line
			//utilFun.Log("_old_x ="+_old_x + "_old_y = "+_old_y);
			//utilFun.Log("_new_x ="+_new_x + "_new_y = "+_new_y);
			//utilFun.Log("_old_y  -_new_y = "+(_old_y  -_new_y));
			if ( _old_y != _yestoday_close_price)  
			{
				var total_distance:Number = Math.abs(_new_y);
				if (  (_yestoday_close_price - _old_y ) > 0 && (_old_y  -_new_y) > _yestoday_close_price)   
				{
					//utilFun.Log("up to down");					
					var y_ration:Number =   _yestoday_close_price -_old_y;
					var x_to_mid_line:Number = (_new_x -_old_x) / Math.abs(total_distance) * y_ration ;
									
					var myx:Number = (_new_x -_old_x) -x_to_mid_line;
					var back_y:Number = _new_y + y_ration;
					
					color += 1;
					color %= 2;
					graphics.lineStyle( 2, pan_color[color] );
					graphics.moveTo(_new_x - myx, _old_y  -_new_y + back_y);
					graphics.lineTo(_new_x , _old_y  -_new_y );
					//graphics.moveTo(_new_x  , _old_y  -_new_y  );
					//utilFun.Log("x= "+ (_new_x  ));
					//utilFun.Log("y= "+ (_old_y  -_new_y  ));
				}
				else  if( (_yestoday_close_price - _old_y ) < 0 && (_old_y  -_new_y) < _yestoday_close_price)
				{
					//utilFun.Log("down to up");
					var y_ration_2:Number =  _yestoday_close_price -_old_y ;				
					var x_to_mid_line_2:Number = (_new_x -_old_x) /  Math.abs(total_distance)*	Math.abs(y_ration_2)
					color += 1;
					color %= 2;					
					
					var back_x:Number = (_new_x -_old_x) -x_to_mid_line_2;
					var back_y_2:Number = _new_y + y_ration_2;
					//utilFun.Log("back_x= "+ (back_x  ));
					graphics.lineStyle( 2, pan_color[color] );
					graphics.moveTo(_new_x - back_x, _old_y  -_new_y +back_y_2);
					graphics.lineTo(_new_x , _old_y  -_new_y );						
					//utilFun.Log("x= "+ (_new_x ));
					//utilFun.Log("y= "+ (_old_y  -_new_y));
				}
			}
			
			
			
			
		}
		
		public function nextLine(oldx:Number,oldy:Number):void
		{
			_old_x = oldx;
			_old_y = oldy ;
			//utilFun.Log("_newdate = "+_newdate);
			//utilFun.Log("_old_x  "+_old_x +" _old_y = "+_old_y);
			if ( _current_idx < _newdate.length )
			{
				var arr:Array = _newdate[_current_idx];	
				var pen_color:int = 0;
				var last_vaule:Number = _yestoday_close_price - _old_y;
				var Xdiff:Number = utilFun.NPointInterpolateDistance(1, 0, arr[0] - _old_x);
				var ydiff:Number = utilFun.NPointInterpolateDistance(1, 0, (arr[1] - last_vaule));
				
				//起點				
				if ( _old_y == _yestoday_close_price)  
				{					
					if ( arr[1] < 0)  pen_color = 1;
					else pen_color = 0 ;
				}
				else if ( _old_y < _yestoday_close_price) pen_color =  0;
				else pen_color =  1;
				
				_new_y = 0;
				Tweener.addCaller( this, { time:0.1 , count: 1 , transition:"easeOutCubic", onUpdateParams:[Xdiff,ydiff,pen_color], onUpdate: this.dotloop,onComplete:this.nextLine,onCompleteParams:[ arr[0], _old_y-ydiff ] } );
			}
			_current_idx++;
		}
		
		public function drawP( ):void
		{
			for ( var i:int = 0; i <_newdate.length; i++)
			{
				var arr:Array = _newdate[i];
				if( arr[1]  > 0) graphics.lineStyle( 3, 0xFF0000 ); //red
				else graphics.lineStyle( 3, 0x66CC66 ); //green
				
				//utilFun.Log("arr[0] = " + arr[0] + "  arr[1] = " + arr[1]);	
				graphics.lineTo(arr[0], _yestoday_close_price- arr[1]);
				graphics.moveTo(arr[0], _yestoday_close_price -arr[1]);
				
			}			
		}
		
		private function fractalDraw( x1 : int, y1 : int, x2 : int, y2 : int ):void 
		{
			graphics.moveTo(x1,y1);
			fractalDrawRecurse( x1, y1, x2, y2 );
		}
		
		private function fractalDrawRecurse( x1 : int, y1 : int, x2 : int, y2 : int ):void 
		{			
			var delta:int = x2 - x1;
			if( delta < 0 )
			{
				delta = -delta; 
			}
			
			if( delta <= granularity ) 
			{
				graphics.lineTo(x2,y2);
				return;
			}
			
			var midx : int = (x1 + x2)/2;
			var midy : int = (y1 + y2)/2;
			
			midy += (Math.random() - 0.5) * variation * (x2 - x1);
			
			if( midy > height )
			{
				midy = height;
			}
			if( midy < 0 )
			{
				midy = 0;
			}
			
			fractalDrawRecurse( x1, y1, midx, midy );
			fractalDrawRecurse( midx, midy, x2, y2 );
		}
		
		public function drawPoint():void
		{
			var ybegin: int = graphHeight //* Math.random();
			var yend: int = graphHeight  //* Math.random();
			var ymin: int = Math.min(ybegin, yend);
			var ratios:Array = [0, 255];
			var verticalGradient:Matrix = new Matrix();
			verticalGradient.createGradientBox(graphWidth, graphHeight-ymin, Math.PI/2, 0, ymin);
			
			graphics.clear();			
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, graphWidth, graphHeight);
			graphics.endFill();
						
			
			graphics.beginGradientFill( GradientType.LINEAR, graphGradientColors, 
				graphGradientAlphas, ratios, verticalGradient );
			graphics.lineStyle( graphThickness, graphColor );
			
			//start			
			//left up corner = 0,0   -> y down =+    y up=-
			graphics.moveTo(0, graphHeight/2);			
			graphics.lineTo(0,  graphHeight / 2);
			
			_yestoday_close_price = graphHeight / 2;
			_current_idx = 0;
			_new_x = 0;
			_new_y = 0;
			_old_x = 0;
			_old_y = graphHeight / 2;
			
			//drawP();				
			nextLine(_old_x, _old_y);
			
			//down color
			//graphics.lineTo(graphWidth, graphHeight);
			//graphics.lineTo(0, graphHeight);
			graphics.endFill();
			
			graphics.lineStyle( gridThickness, gridColor );
			for( var i:int = 1; i < 2; ++i ) 
			{
				graphics.moveTo( 0, i * graphHeight / 2 );
				graphics.lineTo( graphWidth, i * graphHeight / 2 );
			}
			
			for( i = 1; i < 6; ++i ) 
			{
				graphics.moveTo( i * graphWidth / 6, 0 );
				graphics.lineTo( i * graphWidth / 6, graphHeight );
			}
			
		}
		
		public function heart_():void
		{		
			Tweener.addCaller(heart, { time:100 , count: 100 , transition:"linear", onUpdateParams:[heart], onUpdate: this.heart_bet } );
		}
		
		public function heart_bet(mc:MovieClip):void
		{
			mc.gotoAndStop( utilFun.cycleFrame(mc.currentFrame,mc.totalFrames) )	
		}
		
		public function redraw() : void 
		{
			var ybegin: int = graphHeight * Math.random();
			var yend: int = graphHeight  * Math.random();
			var ymin: int = Math.min(ybegin, yend);
			
			var ratios:Array = [0, 255];
			var verticalGradient:Matrix = new Matrix();
			verticalGradient.createGradientBox(graphWidth, graphHeight-ymin, Math.PI/2, 0, ymin);
			
			graphics.clear(); 		
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, graphWidth, graphHeight);
			graphics.endFill();
			
			//graphics.beginGradientFill( GradientType.LINEAR, graphGradientColors, 
				//graphGradientAlphas, ratios, verticalGradient );
			graphics.lineStyle( graphThickness, graphColor );
			graphics.moveTo(0, graphHeight/2);
			graphics.lineTo(0, graphHeight / 2);
			ybegin = graphHeight / 2;
			fractalDraw( 0, ybegin, graphWidth, yend );
			//graphics.lineTo(graphWidth, graphHeight);
			//graphics.lineTo(0, graphHeight);
			graphics.endFill();
			//
			graphics.lineStyle( gridThickness, gridColor );
			
			for( var i:int = 1; i < 2; ++i ) 
			{
				graphics.moveTo( 0, i * graphHeight / 2 );
				graphics.lineTo( graphWidth, i * graphHeight / 2 );
			}
			
			for( i = 1; i < 6; ++i ) 
			{
				graphics.moveTo( i * graphWidth / 6, 0 );
				graphics.lineTo( i * graphWidth / 6, graphHeight );
			}
		}
	}
}