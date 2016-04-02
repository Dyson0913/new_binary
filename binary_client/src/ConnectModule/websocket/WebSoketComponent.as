package ConnectModule.websocket 
{	
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import Command.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import Model.*;	
	import util.DI;
	
	import Model.valueObject.*;
	
	import View.GameView.gameState;
	import util.utilFun;	
	import ConnectModule.websocket.Message

	/**
	 * socket 連線元件
	 * @author hhg4092
	 */
	public class WebSoketComponent 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _actionqueue:ActionQueue;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		private var websocket:WebSocket;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{
			//var object:Object = _model.getValue(modelName.LOGIN_INFO);						
			var uuid:String = _model.getValue(modelName.UUID);
			utilFun.Log("uuid =" + uuid);
			websocket = new WebSocket("ws://" + _model.getValue(modelName.Domain_Name) +":8401/gamesocket/token/" + uuid, "");
			websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocket);
			websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocket);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			websocket.connect();
		}
		
		private function handleWebSocket(event:WebSocketEvent):void 
		{			
			if ( event.type == WebSocketEvent.OPEN)
			{
				utilFun.Log("Connected open="+ event.type );
			}
			else if ( event.type == WebSocketEvent.CLOSED)
			{
				utilFun.Log("Connected  DK close="+ event.type );
			}
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			utilFun.Log("Connected= fale"+ event.type);
		}
		
		
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			var result:Object ;
			if (event.message.type === WebSocketMessage.TYPE_UTF8) 
			{
				utilFun.Log("before"+event.message.utf8Data)
				result = JSON.decode(event.message.utf8Data);			
			}
			
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();
			   
			    if ( result.game_type != _model.getValue(modelName.Game_Name) ) return;				
				
				dispatcher(new ArrayObject([result], "pack_recoder"));
				
				switch(result.message_type)
				{
					case Message.MSG_TYPE_INTO_GAME:
					{
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.NEW_ROUND)
						{
							dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.START_BET)
						{
						    dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );	
						
						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.game_id, "game_id") );
						
						dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );								
						
						dispatcher(new ModelEvent("update_state"));
						
						dispatcher(new Intobject(modelName.POKER_1, "poker_No_mi"));
						dispatcher(new Intobject(modelName.POKER_2, "poker_No_mi"));
						
					}
					break;
					
					case Message.MSG_TYPE_GAME_OPEN_INFO:
					{
						var card:Array = result.card_list;
						var card_type:String = result.card_type;
						var mypoker:Array =[];
						var mypoker2:Array = [];
					
											
						mypoker = _model.getValue(modelName.POKER_1);
						mypoker2 = _model.getValue(modelName.POKER_2);
						mypoker.push(card[0]);
						mypoker2.push(card[0]);
						_model.putValue(modelName.POKER_1, mypoker);
						_model.putValue(modelName.POKER_2, mypoker2);
						dispatcher(new Intobject(modelName.POKER_1, "poker_mi"));
						dispatcher(new Intobject(modelName.POKER_2, "poker_mi"));
						
						//last 2 poker (open card become just handle half in)
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.END_BET)
						{
							dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
							dispatcher(new ModelEvent("update_state"));
						}
						
						
					}
					break;
					
					case Message.MSG_TYPE_STATE_INFO:
					{						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.NEW_ROUND)
						{
						    dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.START_BET)
						{
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );
						}
						
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
						dispatcher(new ModelEvent("update_state"));
					}
					break;
					
					case Message.MSG_TYPE_BET_INFO:
					{
						utilFun.Log("bet result ="+result.result );			
						if (result.result == 0)
						{

						}
						else
						{						
							//下注失敗處理						
						}
						
					}	
					break;
					
					case Message.MSG_TYPE_ROUND_INFO:
					{
						//update state
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );						
						dispatcher(new ModelEvent("update_state"));
						
						//model update						
						dispatcher( new ValueObject(result.card_showhand_comb, modelName.FINAL_CARD));
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher(new ModelEvent("round_result"));		
					}
					break;
					
				}
				
				
				
		}
		
		public function SendMsg(msg:Object):void 
		{
			dispatcher(new ArrayObject([msg], "pack_recoder"));
			var jsonString:String = JSON.encode(msg);
			utilFun.Log("jsonString ="+jsonString );			
			websocket.sendUTF(jsonString);
		}
		
	}
}