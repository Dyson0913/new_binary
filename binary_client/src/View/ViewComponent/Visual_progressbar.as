package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import util.time.time_format;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import flash.utils.setInterval;
	import View.GameView.gameState;
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_progressbar  extends VisualHandler
	{	
		[Inject]
		public var _betCommand:BetCommand;
		
		private const bg:int = 0;
		private const style:int = 1;		
		private const percent:int = 2;
		private const effect:int = 3;
		//private const tag:int = 4;
		
		private const pointor:int = 0;
		
		//res
		public const progresstitle:String = ResName.emptymc;
		
		public const progress_bar:String = "bar_bg";
		public const bar_continue:String = "power_bar_continue";
		public const fire_effect:String = "progress_effect";
		public const progress_bartag:String = "progress_bar_tag";
		public const progressnum:String = "progress_num";
		public const progress_pullbar:String = "progress_pointor";
		
		private const progress_lenth:int = -211;
		
		//res
		public const betbg:String = "bet_bg";
		public const betbtn:String = "bet_btn";
		public const bettitle:String = "bet_title";
		public const betprice:String = "up_down_price";
		
		//tag
		private const bet_tag:int = 0;
		private const title:int = 1;		
		private const btn:int = 2;
		private const price:int = 3;
		
			//res
		public const expectvalue:String = "expect_value";		
		//tag
		private const value_tag:int = 0;
		
		public const basefont:String = "base_font";
        private const now_price:int = 0;
		
		private var  _Percent:Number = 0.1;
		
		//目前即時點數
		private var _Pull_bar_centrol_point:Number = 432;
		
		//單邊調整點數
		private var _adjust_range:Number = 100;
		
		private var _isContinue_mode:Boolean;
		
		public function Visual_progressbar() 
		{
			
		}
		
		public function init():void
		{
			_isContinue_mode = true;
			
			var title:MultiObject = create("progresstitle", [progresstitle]);			
			title.container.x = 738.8;
			title.container.y = 187.40;			
			title.Create_(1);
			
			put_to_lsit(title);	
			
			var progress_container:MultiObject = create("progress_container", [ResName.emptymc],title.container);
			progress_container.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			progress_container.Post_CustomizedData = [3, 0, 265];
			progress_container.CustomizedFun = obinit;
			progress_container.CustomizedData = [[3, 2], [1, 4], [1, 2]];
			progress_container.container.x = 160;
			progress_container.container.y = 110;
			progress_container.Create_(3);
			
			put_to_lsit(progress_container);
			
			_model.putValue("power_idx", [0, 0, 0]);
			
			var progress_sec_pull_container:MultiObject = create("progress_sec_pull_container", [ResName.emptymc],title.container);
			progress_sec_pull_container.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_sec_pull_container.Post_CustomizedData = [[0, 0], [0, 265] ];
			progress_sec_pull_container.CustomizedFun = pullbar_sec_init;			
			progress_sec_pull_container.CustomizedData = [];			
			progress_sec_pull_container.container.x = 148;
			progress_sec_pull_container.container.y = 52;
			progress_sec_pull_container.Create_(1);
			
			put_to_lsit(progress_sec_pull_container);	
			
			//現價bar
			var now_price_container:MultiObject = create("now_price_container", [ResName.emptymc],title.container);		
			now_price_container.CustomizedFun = now_price_init;
			now_price_container.CustomizedData = ["8400"];
			now_price_container.container.x = 478;
			now_price_container.container.y = 180;
			now_price_container.Create_(1);
			
			put_to_lsit(now_price_container);
			
			//setInterval(price_update, 5000,"now_price_",0);	
			
			
			var progress_pull_container:MultiObject = create("progress_pull_container", [ResName.emptymc],title.container);
			progress_pull_container.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_pull_container.Post_CustomizedData = [[0, 0], [0, 265] ,[0, 530]];
			progress_pull_container.CustomizedFun = pullbar_init;
			progress_pull_container.CustomizedData =  [_Pull_bar_centrol_point, 0, 0];	
			progress_pull_container.container.x = 148;
			progress_pull_container.container.y = 52;
			progress_pull_container.Create_(3);
			
			put_to_lsit(progress_pull_container);	
			
			//disappear();
			//買入 賣出 hard to define put where
			var bet_container:MultiObject = create("bet_container", [ResName.emptymc],title.container);
			bet_container.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			bet_container.Post_CustomizedData = [2, 480,0];
			bet_container.CustomizedFun = btn_init;
			bet_container.CustomizedData = [1, 2];
			bet_container.container.x = 222;
			bet_container.container.y = 230;
			bet_container.Create_(2);
			
			put_to_lsit(bet_container);
			
			//最多,最少金額
			_model.putValue("money_high", 100000);
			var XXX_container:MultiObject = create("XXX_container", [ResName.emptymc],title.container);		
			XXX_container.CustomizedFun = XXX_money_init;
			XXX_container.CustomizedData = ["0"];
			XXX_container.container.x = 83;
			XXX_container.container.y = 665;
			XXX_container.Create_(1);
			
			put_to_lsit(XXX_container);
		
			//預期獲利拉bar
			_model.putValue("expect_profit", 0);
			var p_win_r:MovieClip = GetSingleItem("pullbar_" + "0", pointor);
			var p_win_l:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);
			var ex_profie_pointor:MovieClip = GetSingleItem("pullbar_" + "2", pointor);	
			ex_profie_pointor.x = 1.04;
			
			//初始time
			var time_pointor:MovieClip = GetSingleItem("pullbar_" + "1", pointor);
			time_pointor.x = 53.45;
			time_scale_update(time_pointor);
			
			//初始買入賣出價
			
			pull_expect_value(ex_profie_pointor,p_win_r,p_win_l);
			_model.putValue("My_price", 8400);
			
			utilFun.SetTime(My_ini, 0.1);
			
			var pullhand:MultiObject = create("pull_hand", ["pull_hand"], title.container);
			pullhand.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 0, 0]);
			pullhand.Create_(1);
			pullhand.container.x = 560;
			pullhand.container.y = 50;
			
			_regular.Twinkle_by_loopFrame(pullhand.ItemList[0], 3, 2, 2);
			put_to_lsit(pullhand);
			
			state_parse([gameState.START_BET]);
		}		
		
		public function now_price_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "now_price_";
            var component:Array =  [basefont];
            var progress_bar:MultiObject = create(name + idx, component , mc);              
            progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
            progress_bar.Post_CustomizedData = [[0, 0]];
            progress_bar.Create_(component.length);
            GetSingleItem(name + idx, now_price)["_text"].text = "現價:" +data[idx];
		}
		
		private function price_update(name:String,idx:int ):void
		{
			var price:Number = 8400 + utilFun.Random(40) -20 ;
			_model.putValue("My_price", price);
			GetSingleItem(name + idx, idx)["_text"].text = "現價:" +price.toFixed(2);
			
			var pointor:MovieClip = GetSingleItem("pullbar_" + "0", pointor);		
			//pullbar text update
			pullbar_update(pointor);
		}
		
		//預想漲跌及點數
		private function pullbar_update(pointor:MovieClip):void
		{			
			var price:Number = _model.getValue("My_price");
			
			if( _isContinue_mode) price += get_continue_amount(pointor,_Pull_bar_centrol_point,_adjust_range);
			else  price +=  get_continue_amount(pointor,_Pull_bar_centrol_point,_adjust_range,10);		
			//Log("point =" + get_continue_amount(pointor)); 
			pointor["_text"].text = price.toFixed(0).toString();			
		}
		
		/**
		 * 拉bar位置計算出相對數值   
		 * @param	pointor   ->拉bar
		 * @param	centrol_point  ->拉bar 起始中心點,一開始在中間就傳 distance /2,在最左邊就傳零 
		 * @param	splite_to  -> 分成幾份
		 * @param	base_unit  -> 最小單位分量 ,設1,每個單位都顥示,設10,每十個單位更新
		 * @return   
		 */
		private function get_continue_amount(pointor:MovieClip , centrol_point:Number = 0 ,dis_splite_to:Number = 100, base_unit:int = 1):int
		{
			var bar_dis_width:Number = 860 - centrol_point ;			
			var num_per_pixel:Number =    dis_splite_to / bar_dis_width ;			
			var amount:int = (pointor.x - centrol_point) * num_per_pixel / base_unit;
			amount = amount * base_unit;
			return amount;
		}		
		
		public function CDF(p_win:Number):Number
        {
			//Log("p_win = " + p_win); 
            var sum:Number = p_win;           
            var value:Number = p_win;
            for (var i:int = 0; i < 1000; i++)
            {
                     var a:int = a + 1
                     value = value * p_win * p_win / (2 * a + 1)
                     sum = sum +value                     
            }
            var result:Number = 0.5 + ( sum / Math.sqrt(2 * Math.PI)) * Math.exp( -(p_win * p_win) / 2)			
            return result;
        }

		
		private function My_ini():void
		{
			//預期獲利
			var pointor:MovieClip = GetSingleItem("pullbar_" + "2", pointor);	
			var mc:MovieClip = GetSingleItem("progress_" + "2", style);
			mc["_firstbar"].x = pointor.x;
			mc["_tail"].x = pointor.x;
			
			//時間初值
			var time_pointor:MovieClip = GetSingleItem("pullbar_" + "1", 0 );				
			var time:MovieClip = GetSingleItem("progress_" + "1", style);
			var myx:Number = time_pointor.x;
			time["_firstbar"].x = time_pointor.x;
			time["_tail"].x = time_pointor.x;
		}
		
		public function btn_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "bet_";
			var component:Array =  [betbg, bettitle,betbtn,betprice];
			var ob_cotainer:MultiObject = create(name + idx, component , mc);
			ob_cotainer.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			ob_cotainer.mousedown = buy_in;
			ob_cotainer.mouseup = None_reaction;
			ob_cotainer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			ob_cotainer.Post_CustomizedData = [[0, 0],[-50, 0], [190,0],[10,8]];
			ob_cotainer.Create_(component.length);
			GetSingleItem(name + idx, bet_tag).gotoAndStop(data[idx]);
			GetSingleItem(name + idx, title).gotoAndStop(data[idx]);
			GetSingleItem(name + idx, price)["_text"].text = "";
			
			//custzmied		
			
			//object_init("progress_"+idx, percent);
			
			put_to_lsit(ob_cotainer);
		}
		
		
		public function XXX_money_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "xxx_money_";
			var component:Array =  [expectvalue];
			var progress_bar:MultiObject = create(name + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0]];
			progress_bar.Create_(component.length);
			GetSingleItem(name + idx, value_tag)["_text"].text = data[idx];
		}
		
		public function obinit(mc:MovieClip, idx:int, data:Array):void
		{
			var component:Array =  [progress_bar, bar_continue, ResName.emptymc, fire_effect];
			var progress_bar:MultiObject = create("progress_" + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0], [13.3,10], [289.4, 7.5], [-38.95, -19],[-5,10]];
			progress_bar.Create_(component.length);
			GetSingleItem("progress_" + idx, bg).gotoAndStop(2);
			GetSingleItem("progress_" + idx, style)["_firstbar"].gotoAndStop(data[idx][0]);		
			GetSingleItem("progress_" + idx, style)["_sec_bar"].gotoAndStop(data[idx][1]);
			GetSingleItem("progress_" + idx, style)["_tail"].gotoAndStop(1);	
			GetSingleItem("progress_" + idx, style)["_tail_sec"].gotoAndStop(1);	
			
			//custzmied
			if ( idx == 0)
			{
				GetSingleItem("progress_" + idx, style)["_firstbar"].x = 860 / 2 +1;
				GetSingleItem("progress_" + idx, style)["_tail"].x = 860 / 2 +1;
				GetSingleItem("progress_" + idx, style)["_tail"].gotoAndStop(3);
				GetSingleItem("progress_" + idx, style)["_tail_sec"].gotoAndStop(2);
			}
			
			if ( idx == 1)  GetSingleItem("progress_" + idx, style)["_tail_sec"].gotoAndStop(4);
			
			
			object_init("progress_"+idx, percent);
			
			put_to_lsit(progress_bar);
		}
		
		public function pullbar_init(mc:MovieClip, idx:int, data:Array):void
		{
			var component:Array =  [progress_pullbar];
			var progress_bar:MultiObject = create("pullbar_" + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0]];		
			progress_bar.Create_(component.length);
			GetSingleItem("pullbar_" + idx, pointor).x = data[idx];
			GetSingleItem("pullbar_" + idx, pointor)["_text"].text = "";
			//GetSingleItem("pullbar_" + idx, pointor)["_arrow"].gotoAndStop(1);			
			
			
			progress_bar.Drag(0,drag);
			
			//put_to_lsit(progress_bar);	
		}
		
		public function drag(e:Event, idx:int):Boolean
		{
			switch (e.type)
			{
				case "mouseDown":
				{
					//utilFun.Log("e.cur =  + mouseDown ");					
					var mu:MultiObject = Get("pullbar_" + idx);
					var mc:MovieClip = GetSingleItem("pullbar_" + idx, pointor);
					
					//限制拖曳的範圍
					var sRect:Rectangle = new Rectangle(0,0,860,0);
					mc.startDrag(false,sRect);
					mc.addEventListener(MouseEvent.MOUSE_MOVE, mu.cut_name);
					mc.addEventListener(MouseEvent.MOUSE_UP, mu.cut_name);
				}
				break;
				
				case "mouseMove":
				{					
					//pull bar text
					var p_win_r:MovieClip = GetSingleItem("pullbar_" + "0", pointor);
					var p_win_l:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);	
					var ex_profie_pointor:MovieClip = GetSingleItem("pullbar_" + "2", pointor);
					
					var mypointor:MovieClip = GetSingleItem("pullbar_" + idx, pointor);				
						
					//防呆
					//左邊拉bar
					var L_pointor:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);				
					if ( L_pointor.x > 0 && idx == 0)
					{
						if ( (mypointor.x - L_pointor.x) < 53) 
						{						
							remove_listen(idx);
							return true						
						}
						else
						{
							pullbar_update(mypointor);
							
							//價內,價外 點數計算					
							price_in_out_ad()							
						}
					}
					
					if (idx == 0)
					{
						if ( (p_win_r.x - p_win_l.x) <= 53) 
						{
							remove_listen2(idx);
							return true						
						}
						
						pullbar_update(mypointor)
							
						//漲跌 點數計算	
						price_low_high(mypointor);						
					}
						
					var mc:MovieClip = GetSingleItem("progress_" + idx, style);
					mc["_firstbar"].x = mypointor.x;
					mc["_tail"].x = mypointor.x;
					
					
					if ( idx == 1)
					{
						if ( mypointor.x >= 53.45 ) 
						{
							time_scale_update(mypointor);
						}
						else
						{
							remove_listen(idx);
						}

						//price_decrece(mypointor);
					}
					
					//price
					if ( idx == 2) 
					{						
						pull_expect_value(ex_profie_pointor, p_win_r,p_win_l);						
					}
					
					//utilFun.Log("move  x= " + mc.x + " y= " + (mc.y + mc.height));					
					if ( mypointor.x <=0 || mypointor.x >= 860 ) remove_listen(idx);
					
				}
				break;
				
				case "mouseUp":
			   {
					remove_listen(idx);			
			   }
			    break;
			}
			
			return true;
		}
		
		public function p_win_pullbar_zone_normalize(p_win_pullbar:MovieClip):Number
		{			
			var shift_point:Number;
			if ( _isContinue_mode) shift_point = get_continue_amount(p_win_pullbar, _Pull_bar_centrol_point);
			else shift_point = get_continue_amount(p_win_pullbar, _Pull_bar_centrol_point, _adjust_range, 10);
			
			return shift_point / _adjust_range;
		}
		
		public function price_low_high(pullbar:MovieClip):void
		{			
			var normal:Number  = p_win_pullbar_zone_normalize(pullbar);
			Log("normal zone= " + normal.toFixed(2));
			
			//算出stack
			var stack:Array =  get_cdf_low_high( parseFloat( normal.toFixed(2) ), get_amount());
			
			set_lowprice_and_upprice(stack[0],  stack[1]);			
		}
		
		public function get_amount():Number
		{			
			var expect_value_pullbar:MovieClip = GetSingleItem("pullbar_" + "2", pointor);
			var amount:int = get_expect_profi(expect_value_pullbar);
			return amount;
		}
		
		public function get_expect_profi(expect_profi_pullbar:MovieClip):int
		{			
			var amount:int =  get_continue_amount(expect_profi_pullbar, 0, _model.getValue("money_high"), 100);			
			
			if ( amount <= 100) amount = 100;
			
			_model.putValue("expect_profit", amount);
			return amount
		}
		
		
		public function pull_expect_value(ex_profit_pullbar:MovieClip,p_win_r:MovieClip,p_win_l:MovieClip):void
		{
			//expect_value
			var mc:MovieClip = GetSingleItem("xxx_money_" + "0");
			mc.x = ex_profit_pullbar.x;
			var amount:int = get_amount();
			mc["_text"].text =  amount.toString();
			
			if ( p_win_l.x > 0)
			{
				//價內價外
				price_in_out_ad();
			}
			else
			{
				//漲跌
				price_low_high(p_win_r);
			}
			
		}
		
		public function set_lowprice_and_upprice(down:int,up:int):void
		{
			var mc:MovieClip = GetSingleItem("bet_" + "0", 3);
			if ( down == 0) mc["_text"].text = "";
			else mc["_text"].text = down.toString();						
			
			var mc2:MovieClip = GetSingleItem("bet_" + "1", 3);
			if ( up == 0) mc2["_text"].text = "";
			else mc2["_text"].text = up.toString();
			
			_model.putValue("price_low", down);
			_model.putValue("price_high", up);
		}
		
		public function get_cdf_low_high(p_win:Number,amount:Number):Array
		{
			var payout:Number = amount;
            var percent:Number = _Percent;
            var y:Number = CDF( p_win)
            //utilFun.Log("y =" +y);
            var down_stak:Number = payout * (y / (1 - percent))
            var up_stake:Number = payout * ( (1 - y) / (1 - percent) )      
			
			return [down_stak, up_stake];
		}
		
		public function get_in_price(p_win:Number):Number
		{
			//Log("in_price = " + p_win);
			var payout:Number = get_amount();
            var percent:Number = _Percent;
			var y:Number = p_win ;
            var in_price:Number = payout * (y / (1 - percent))
			
			return in_price;
		}
		
		public function get_out_price(p_win:Number):Number
		{
			//Log("out_price = " + p_win);
			var payout:Number = get_amount();
            var percent:Number = _Percent;
			var y:Number = p_win; 
           var out_price:Number = payout * ( (1 - y) / (1 - percent) )      
			
			return out_price;
		}
		
		
		public function time_scale_update(pullbar:MovieClip):void
		{			
			var pullbar_x:Number  = pullbar.x;			 
			var timescale_day:int = 86400;
			var timescale_hours:int = 3600;
			
			var time_shift_pixel:Number = timescale_day / 860;
			var per_unit:int  = (pullbar_x / 43) ;//  (860 /43);
			var hour:int = 0
			var min:int = 0			
			if ( per_unit == 1) min = 1;
			if ( per_unit == 2) min = 3;
			if ( per_unit == 3) min = 5;
			if ( per_unit == 4) min = 10;
			if ( per_unit == 5) min = 15;
			if ( per_unit == 6) min = 30;
			if ( per_unit == 7) min = 45;
			if ( per_unit >= 8) 
			{
				hour = per_unit - 7;
				min = 0;
			}
			
			var days:int = 0
			if ( hour != 0)
			{
				if ( hour == 13)
				{
					pullbar["_text"].text = 1 + "day";
					hour = 0;
					days = 1;								
				}
				else pullbar["_text"].text = hour + "hours";
			}
			if ( min != 0) 	pullbar["_text"].text = min + "mins";
			
			
			//Log("time ad = " + per_unit );				
			GetSingleItem("time_" + "0", 2)["_text"].text =  "  To  " + time_format.get_time("MM / dd  hh:mm", days, hour, min);
		}
		
		private function remove_listen(idx:int):void
		{
			var mu:MultiObject = Get("pullbar_" + idx);
			var mc:MovieClip = GetSingleItem("pullbar_" + idx, pointor);
			mc.stopDrag();
			mc.removeEventListener(MouseEvent.MOUSE_MOVE, mu.cut_name);
			mc.removeEventListener(MouseEvent.MOUSE_UP, mu.cut_name);
			mc.removeEventListener(MouseEvent.ROLL_OUT, mu.cut_name);
			
		}
		
		public function pullbar_sec_init(mc:MovieClip, idx:int, data:Array):void
		{
			var component:Array =  [progress_pullbar];
			var progress_bar:MultiObject = create("pullbar_Sec" + idx, component , mc);			
			progress_bar.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			progress_bar.Post_CustomizedData = [[0, 0]];		
			progress_bar.Create_(component.length);			
			GetSingleItem("pullbar_Sec" + idx, pointor)["_text"].text = "";
			
			progress_bar.Drag(0,drag_2);
			
			//put_to_lsit(progress_bar);	
		}
		
		public function buy_in(e:Event, idx:int):Boolean
		{
			if ( idx != btn) return false;
			
			//Log("idx = " + e.currentTarget.name);
			Log("buy in");
			var name:String = e.currentTarget.name;
			var pa_st:String = name.substr(0 ,name.length - 1);
			var contain_idx:String = pa_st.substr(pa_st.length -1 ,pa_st.length);
			Log("buy in  contain_idx= " + contain_idx + " btn idx " + idx);
			
			//0 跌,價內 買入  1,漲,價外買入
			var L_pointor:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);
			if ( parseInt(contain_idx) == 0)
			{				
				if ( L_pointor.x  > 0 ) dispatcher(new ModelEvent("In_price"));
				else dispatcher(new ModelEvent("fall_down"));
			}
			else 
			{
				if ( L_pointor.x  > 0 ) dispatcher(new ModelEvent("out_price"));
				else dispatcher(new ModelEvent("raise_up"));
			}
			
			return true;
		}	
		
		public function None_reaction(e:Event, idx:int):Boolean
		{			
			if ( idx != btn) return false;
			return true;
		}	
		
		public function price_in_out_ad():void
		{
			//same as drag_2
			//右邊拉bar	
			var right_pointor:MovieClip = GetSingleItem("pullbar_" + "0", pointor);			
			var normal:Number  = p_win_pullbar_zone_normalize(right_pointor);			
			
			//左邊拉bar
			var pointor:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);			
			var L_normal:Number  = p_win_pullbar_zone_normalize(pointor);			
			
			var In_price:Number = CDF(normal) - CDF(L_normal);
			//Log("cdf(b)-cdf(a) =" +  In_price.toFixed(1));				
			
			set_lowprice_and_upprice(get_in_price(In_price), get_out_price(In_price));
			
		}
		
		public function drag_2(e:Event, idx:int):Boolean
		{		
			switch (e.type)
			{
				case "mouseDown":
				{
					//utilFun.Log("e.cur =  + mouseDown ");					
					var mu:MultiObject = Get("pullbar_Sec" + idx);
					var mc:MovieClip = GetSingleItem("pullbar_Sec" + idx, pointor);
					
					//限制拖曳的範圍
					var sRect:Rectangle = new Rectangle(0,0,860,0);
					mc.startDrag(false,sRect);
					mc.addEventListener(MouseEvent.MOUSE_MOVE, mu.cut_name);
					mc.addEventListener(MouseEvent.MOUSE_UP, mu.cut_name);
					mc.addEventListener(MouseEvent.ROLL_OUT, mu.cut_name);				
				}
				break;
				
				case "mouseMove":
				{
					var p_win_r:MovieClip = GetSingleItem("pullbar_" + "0", pointor);
					var p_win_l:MovieClip = GetSingleItem("pullbar_Sec" + "0", pointor);	
					var ex_profie_pointor:MovieClip = GetSingleItem("pullbar_" + "2", pointor);
					
					//左邊拉bar
					var pointor:MovieClip = GetSingleItem("pullbar_Sec" + idx, pointor);
					
					//防呆
					if ( (p_win_r.x - p_win_l.x) <= 53) 
					{
						remove_listen2(idx);
						return true						
					}
						
					if ( idx == 0)
					{
						//區間內外
						pull_expect_value(ex_profie_pointor, p_win_r,p_win_l);
					}
					
					pullbar_update(pointor);
					
					bet_type_change(idx);
					
					//utilFun.Log("move  x= " + mc.x + " y= " + (mc.y + mc.height));					
					if ( pointor.x <=0 || pointor.x >= 860 ) remove_listen(idx);
				}
				break;
				
				case "mouseUp":
				{
					remove_listen2(idx);
				}
				break;
			}
			
			return true;
		}
		
		private function bet_type_change(idx:int):void
		{
			var pointor:MovieClip = GetSingleItem("pullbar_Sec" + idx, pointor);
			//區間內,外更新
			var mc:MovieClip = GetSingleItem("bet_" + "0", 1);
			var mc2:MovieClip = GetSingleItem("bet_" + "1", 1);
			if ( pointor.x > 0)
			{
				mc.gotoAndStop(3);
				mc2.gotoAndStop(4);
			}
			else
			{
				//換回漲跌,第一個bar  reset
				pointor["_text"].text = "";
				mc.gotoAndStop(1);					
				mc2.gotoAndStop(2);					
			}
			
			//pullbar 色條
			reset_pullbar(pointor,idx);
		}
		
		private function reset_pullbar(pointor:MovieClip,idx:int):void
		{
			var zone_inside_out:MovieClip = GetSingleItem("progress_" + idx, style);
			zone_inside_out["_sec_bar"].x = pointor.x;
			zone_inside_out["_tail_sec"].x = pointor.x;		
		}
		
		private function remove_listen2(idx:int):void
		{
			var mu:MultiObject = Get("pullbar_Sec" + idx);
			var mc:MovieClip = GetSingleItem("pullbar_Sec" + idx, pointor);
			mc.stopDrag();
			mc.removeEventListener(MouseEvent.MOUSE_MOVE, mu.cut_name);
			mc.removeEventListener(MouseEvent.MOUSE_UP, mu.cut_name);
			mc.removeEventListener(MouseEvent.ROLL_OUT, mu.cut_name);
		}
		
		override public function appear():void
		{
			var mu:MultiObject = Get("progresstitle");
			mu.container.visible = true;
			
			mu = Get("progress_container");
			mu.container.visible = true;
			mu.FlushObject();
		}
		
		override public function disappear():void
		{
			var mu:MultiObject = Get("progresstitle");
			mu.container.visible = false;
			
			mu = Get("progress_container");
			mu.container.visible = false;		
		}
		
		//mode -> (contorl ?)->view 
		public function progress(zero_position:Number,full_position:Number,To_percent:Number):Number
		{
			//model
			var dis:Number = Math.abs(full_position - zero_position);
			var move_dis:Number =  zero_position + dis * (To_percent / 100);
			
			return move_dis;
		}
		
		public function no_effect(mc:DisplayObjectContainer,  move_dis:Number):void
		{
			mc.x = move_dis;
		}
		
		//view
		public function effect_in_tail(mc:DisplayObjectContainer,effect:DisplayObjectContainer,move_dis:Number,rasingtime:int,kind:int):void
		{			
			Tweener.addTween(mc, { x:move_dis, time:rasingtime, onUpdate:this.update, onUpdateParams:[mc,effect],onComplete:this.progress_finish, onCompleteParams:[kind] } );			
		}	
		
		public function update(mc:DisplayObjectContainer,effect:DisplayObjectContainer):void
		{
			effect.x = mc.x+320 -60;
			effect.y = mc.y -20;
		}
		
		public function progress_finish(kind:int):void
		{			
			var arr:Array = _model.getValue("power_idx");
			var idx:int  = arr[kind];
			
			if ( idx != 5)
			{
				//dispatcher(new Intobject(1, "settle_step"));	
				//utilFun.SetTime(triger, 2);
				return ;
			}
			
			
			bigwin_show(kind);
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="power_up")]
		public function check_effect(type:Intobject):void
		{
			//model temp
			var arr:Array = _model.getValue("power_idx");			
			var kind:int = type.Value;			
			
			
			//get model
			var idx:int  = arr[kind];
			var move_dis:Number = progress( progress_lenth, 0, (idx+1)*20);
			arr[kind] += 1;			
			
			//data set			
			//GetSingleItem("powerbar_" + kind, effect).gotoAndPlay(2);		
			//gotoAndPlay
			//gotoAndStop
			
			var acumu:Array = [utilFun.Random(100),utilFun.Random(100),utilFun.Random(100),utilFun.Random(100),utilFun.Random(100),utilFun.Random(100)];// _model.getValue("power_jp");			
			
			data_setting("progress_" + kind, percent, acumu, kind);
			
			//GetSingleItem("progress_"+kind,tag).gotoAndStop(utilFun.Random(10));
			
			//effect 
			no_effect(GetSingleItem("progress_" + kind, style)["_colorbar"], move_dis);
			//effect_in_tail(GetSingleItem("powerbar_"+kind, style)["_colorbar"],GetSingleItem("powerbar_" + kind, effect), move_dis, 2, kind);
			
			
			
		}
		
		//dock type handle
		public function object_init(obname:String,resTag:int):void
		{
			if ( Get(obname).resList[resTag] == ResName.TextInfo)
			{
				_text.textSetting_s(GetSingleItem(obname, resTag), [ { size:22, align:_text.align_left } , ""]);
			}
			else if (Get(obname).resList[resTag]== ResName.emptymc)
			{
				//frame_setting(GetSingleItem(obname, resTag), 0);
			}
		}
		
		public function data_setting(obname:String, resTag:int,data:Array,data_idx:int):void
		{
			if ( Get(obname).resList[resTag] == ResName.TextInfo)
			{
				//TODO move to _text object
				GetSingleItem(obname, resTag).getChildByName("Dy_Text").text =  data[data_idx];
			}
			else if (Get(obname).resList[resTag]== ResName.emptymc)
			{				
				//frame_setting(GetSingleItem(obname, resTag), data[data_idx]);
			}
		}
		
		//TODO move to frame Object
		private function frame_setting(mc:MovieClip,data:int):void
		{			
			utilFun.Clear_ItemChildren(mc);			
			var arr:Array = data.toString().split("");
			arr.push(11);
			var num:int = arr.length;
			var p_num:MultiObject = create_dynamic(mc.parent.name, [progressnum], mc);			
			p_num.CustomizedFun = FrameSetting;
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [num, -18, 0];		
			p_num.Create_(num);		
			
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			if ( data[idx] == 0 ) data[idx] = 10;
			mc.gotoAndStop(data[idx]);			
		}
		
		private function triger():void
		{
			dispatcher(new StringObject("sound_Powerup_poker","sound" ) );
		}
		
		private function bigwin_show(kind:int):void
		{
			Get("Power_JP").container.visible = true;
			var acumu:Array = _model.getValue("power_jp");
			var s:String = acumu[kind].toString();
			var arr:Array = utilFun.frameAdj(s.split(""));					
			
			
			
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.container.x = -30 + ((-57 /2) * (arr.length-1));
			PowerJPNum.container.y = 110;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = _regular.FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 57, 10];
			PowerJPNum.Create_(arr.length);					
			_regular.Call(this, { onComplete:this.showok,onCompleteParams:[kind] }, 4, 1, 1, "linear");
			dispatcher(new StringObject("sound_bigPoker", "sound" ) );
			
		}
		
		
		private function showok(kind:int):void
		{
			var arr:Array = _model.getValue("power_idx");	
			arr[kind] = 0;
			_model.putValue("power_idx", arr);
			
			GetSingleItem("progress_"+kind, 1)["_colorbar"].x = progress_lenth;
			GetSingleItem("progress_"+kind, 2).visible = false;
			GetSingleItem("progress_"+kind, 3).getChildByName("Dy_Text").text = "";
			
			var acu_jp:Array  = _model.getValue("power_jp");
			acu_jp[kind] = 0;
			_model.putValue("power_jp", acu_jp );
			//utilFun.Log("acu_jp = " + _model.getValue("power_jp"));
			
			//TODO move
			Get("Power_JP").container.visible = false;
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.CleanList();
			
			dispatcher(new Intobject(1, "settle_step"));	
		}
		
	}

}