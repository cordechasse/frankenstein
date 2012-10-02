/*
 * Copyright © CorDeChasse 1999-2011
 */
 
 
package frankenstein.socketServer.fms {
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.utils.Timer;
	import frankenstein.events.SocketServerEvent;
	import frankenstein.tools.UArray;


	/**
	 * Evènement dispatché lors d'une erreur de sécurité à la connexion 
	 *
	 * @eventType SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="security_error", type="flash.events.SecurityErrorEvent")]

	/**
	 * Evènement dispatché lorsqu'on est cours de connexion
	 *
	 * @eventType SocketServerEvent.CONNECTING
	 */
	[Event(name="connecting", type="frankenstein.events.SocketServerEvent")]

	/**
	 * Evènement dispatché lorsqu'on est connecté au serveur
	 *
	 * @eventType SocketServerEvent.CONNECTED
	 */
	[Event(name="connected", type="frankenstein.events.SocketServerEvent")]

	/**
	 * Evènement dispatché lorsqu'on a une erreur à la connection
	 *
	 * @eventType SocketServerEvent.CONNECTION_ERROR
	 */
	[Event(name="connection_error", type="frankenstein.events.SocketServerEvent")]

	/**
	 * Evènement dispatché lorsqu'on est deconnecté du serveur
	 *
	 * @eventType SocketServerEvent.DISCONNECTED
	 */
	[Event(name="disconnected", type="frankenstein.events.SocketServerEvent")]

	/**
	 * Evènement dispatché lorsque la connexion est déclarée comme
	 * impossible : on a tenté de se connecter 3 fois à la liste des URI sans succès.
	 *
	 * @eventType SocketServerEvent.CONNECTION_IMPOSSIBLE
	 */
	[Event(name="connection_impossible", type="frankenstein.events.SocketServerEvent")]

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 26 nov 2008<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * 
	 * <p>Object permettant de faciliter la connexion à un serveur FMS.<br />
	 * Il dispose des caractéristiques suivantes : <br />
	 * 	<ul>
	 * 		<li>on peut lui spécifier une liste d'URI</li>
	 * 		<li>reconnection automatique en cas de deconnexion</li>
	 * 		<li>tentative de connexion en boucle en cas d'échec, avec délai avant les nouvelles tentatives</li>
	 * 	</ul>	
	 * </p>
	 * <p>
	 * <b>Mode de connection par défaut :</b><br />
	 * Tentative connexion Boucle 3 fois -> attente 30 sec -> Tentative connexion Boucle 3 fois -> ...<br />
	 * avec : <br />
	 * Boucle = Tentative connexion URI 1 -> Erreur -> Attente 1 sec -> Tentative connexion URI 2 -> Erreur -> ...<br/>
	 * Si le serveur ne repond pas au bout de 5 sec, on déclare la connexion comme échouée et on tente la suivante.
	 * </p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		var fmsConnector = new FMSConnector();
	 * 		fmsConnector.addEventListener(SocketServerEvent.CONNECTING, _eventCatcher);
	 * 		fmsConnector.addEventListener(SocketServerEvent.CONNECTED, _eventCatcher);
	 * 		fmsConnector.addEventListener(SocketServerEvent.CONNECTION_ERROR, _eventCatcher);
	 * 		fmsConnector.addEventListener(SocketServerEvent.CONNECTION_IMPOSSIBLE, _eventCatcher);
	 * 		fmsConnector.addEventListener(SocketServerEvent.DISCONNECTED, _eventCatcher);
	 * 		
	 * 		fmsConnector.connect(["rtmp://fms.cordechasse.fr/test", "rtmpt://fms.cordechasse.fr/test"]);
	 * 		
	 * 		function _eventCatcher(e : SocketServerEvent):void{
	 * 			trace(this, "_eventCatcher", e.type);
	 * 		}
	 * 		
	 * 	</pre>
	 * </listing>
	 * 	
	 * 
	 * @see flash.net.NetConnection
	 * 
	 * 	
	 * @author n.bush
	 * @since 26 nov 2008
	 * @version 1.0.0
	 */ 
	public class FMSConnector extends EventDispatcher {

		private var _reconnectionDelay : uint;
		private var _reconnectionDelayImpossible : uint;
		private var _FMSResponseTimeOut : uint;
		private var _maxAttempts : uint;

		private var _netconnection : NetConnection;

		private var _uri : String;
		private var _uriList : Array;

		private var _numAttempt : uint;
		private var _numUri : int;

		private var _askClose : Boolean;

		
		//delai entre chaque tentative de reconnection
		private var _reconnectionTimer : Timer;

		//delai apres le nb de tentative max atteint
		private var _reconnectionTimerImpossible : Timer;

		//temps de reponse max avant de determiner une connection impossible
		private var _fmsResponseTimer : Timer;

		
		/**
		 * Crée un nouveau FMSConnector.
		 * 
		 * @param reconnectionDelay
		 * Temps d'attente (en millisecondes) avant la tentative de connexion de la prochaine URI.
		 * 
		 * @param reconnectionDelayImpossible
		 * Temps d'attente (en millisecondes) avant la prochaine tentative de connexion, 
		 * quand la connexion est déclarée "impossible".
		 * 
		 * @param FMSResponseTimeOut
		 * Temps à partir duquel on déclare que la connexion a échoué faute de réponse du serveur.
		 * 
		 * @param maxAttemptBeforeConnectionImpossible
		 * Nombre de boucles d'essai à faire avant de déclarer la connexion impossible.
		 *   
		 */
		public function FMSConnector(reconnectionDelay : uint = 1000, reconnectionDelayImpossible : uint = 30000, FMSResponseTimeOut : uint = 5000, maxAttemptBeforeConnectionImpossible : uint = 3) {
				
			_reconnectionDelay = reconnectionDelay;
			_reconnectionDelayImpossible = reconnectionDelayImpossible;
			_FMSResponseTimeOut = FMSResponseTimeOut;
			_maxAttempts = maxAttemptBeforeConnectionImpossible;
				
			_netconnection = new NetConnection();
			_netconnection.addEventListener(NetStatusEvent.NET_STATUS, _onGetStatus, false, 0, true);
			_netconnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError, false, 0, true);
			_netconnection.objectEncoding = ObjectEncoding.AMF0;
				
			//timer de reconnection si erreur de connection 
			_reconnectionTimer = new Timer(_reconnectionDelay, 1);
			_reconnectionTimer.addEventListener(TimerEvent.TIMER, _reconnect, false, 0, true);
							
			//timer de reconnection si nb essai max atteint
			_reconnectionTimerImpossible = new Timer(_reconnectionDelayImpossible, 1);
			_reconnectionTimerImpossible.addEventListener(TimerEvent.TIMER, _reconnect, false, 0, true);
				
			//timer d'attente de reponse du server (si superieur au temps => connexion impossible)
			_fmsResponseTimer = new Timer(_FMSResponseTimeOut, 1);
			_fmsResponseTimer.addEventListener(TimerEvent.TIMER, _onTimeOutFMS, false, 0, true);
		}

		
		
		/**
		 * Tente de se connecter à une liste d'URI (dans l'ordre).
		 * 
		 * @param uriList
		 * Tableau de String contenant la liste des URI.
		 * 
		 * @return void
		 */
		public function connect(uriList : Array) : void {
			
			disconnect();
			
			_uriList = uriList;
			
			_numAttempt = 0;
			_numUri = 0;
			
			_tryConnection();
		}

		
		
		/**
		 * Tente de se connecter à une liste d'URI (dans le désordre).
		 * 
		 * @param uriList
		 * Tableau de String contenant la liste des URI.
		 * 
		 * @return void
		 */
		public function connectRandomly(uriList : Array) : void {
			var newList : Array = UArray.randomize(uriList);
			connect(newList);
		}

		
		
		/**
		 * Ferme la connexion au serveur, l'objet est alors unitilisable.
		 * 
		 * @return void
		 */
		public function close() : void {
			
			_netconnection.close();
			_netconnection.removeEventListener(NetStatusEvent.NET_STATUS, _onGetStatus);
			_netconnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onError);
			_netconnection = null;
			
			_reconnectionTimer.removeEventListener(TimerEvent.TIMER, _reconnect);
			if (_reconnectionTimer.running)
				_reconnectionTimer.stop();
			_reconnectionTimer = null;
			
			_reconnectionTimerImpossible.removeEventListener(TimerEvent.TIMER, _reconnect);
			if (_reconnectionTimerImpossible.running)
				_reconnectionTimerImpossible.stop();
			_reconnectionTimerImpossible = null;
			
			_fmsResponseTimer.removeEventListener(TimerEvent.TIMER, _onTimeOutFMS);
			if (_fmsResponseTimer.running)
				_fmsResponseTimer.stop();
			_fmsResponseTimer = null;
		}

		
		/**
		 * Se deconnecte du serveur en cours.
		 * 
		 * @return void
		 */
		public function disconnect() : void {
			_netconnection.close();
			
			_reconnectionTimer.reset();
			_reconnectionTimerImpossible.reset();
			_fmsResponseTimer.reset();
		}

		
		private function _reconnect(e : TimerEvent = null) : void {
			
			_numUri++;
			
			if (_numUri >= _uriList.length) {
				_numUri = 0;
				_numAttempt++;
			}
			
			if (_numAttempt >= _maxAttempts) {
				
				_fmsResponseTimer.reset();
				_reconnectionTimer.reset();
				
				
				var e2 : SocketServerEvent = new SocketServerEvent(SocketServerEvent.CONNECTION_IMPOSSIBLE);
				e2.attempt = _maxAttempts;
				dispatchEvent(e2);
				
				_numAttempt = 0;
				_numUri = -1;
				_reconnectionTimerImpossible.reset();
				_reconnectionTimerImpossible.start();
			} else {
				_tryConnection();
			}
		}

		
		private function _tryConnection() : void {
			
			//trace(this, "_tryConnection");

			_uri = _uriList[_numUri];
			
			var e : SocketServerEvent = new SocketServerEvent(SocketServerEvent.CONNECTING);
			e.attempt = _numAttempt;
			e.uri = _uri;
			dispatchEvent(e);

			_netconnection.connect(_uri);
			
			_fmsResponseTimer.reset();
			_fmsResponseTimer.start();
		}

		
		private function _onTimeOutFMS(e : TimerEvent) : void {
			var e2 : SocketServerEvent = new SocketServerEvent(SocketServerEvent.CONNECTION_ERROR);
			e2.attempt = _numAttempt;
			e2.uri = _uri;
			e2.error = "FMS response timeout";
			dispatchEvent(e2);
			

			//on ferme la connection
			_askClose = true;
			_netconnection.close();
			_askClose = false;
			
			_reconnectionTimer.start();
		}

		
		
		//--------------------------------------
		//					EVENTS
		//--------------------------------------

		private function _onGetStatus(e : NetStatusEvent) : void {

			var e2 : SocketServerEvent;
			
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
					e2 = new SocketServerEvent(SocketServerEvent.CONNECTED);
					e2.uri = _uri;
					e2.attempt = _numAttempt;
					dispatchEvent(e2);
					_fmsResponseTimer.stop();
					
					_numAttempt = 0;
					
					break;
				case "NetConnection.Connect.AppShutdown":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.InvalidApp":
					//on lance la reconnection si ce n'est pas une demande du client
					e2 = new SocketServerEvent(SocketServerEvent.CONNECTION_ERROR);
					e2.attempt = _numAttempt;
					e2.error = e.info.code;
					e2.uri = _uri;
					dispatchEvent(e2);
					
					_reconnectionTimer.start();
					break;
				case "NetConnection.Connect.Closed":
					if (!_askClose) {
						e2 = new SocketServerEvent(SocketServerEvent.DISCONNECTED);
						e2.attempt = _numAttempt;
						dispatchEvent(e2);
						
						_reconnectionTimer.start();
					}
					break;
			}
		}

		
		private function _onError(e : SecurityErrorEvent) : void {
			dispatchEvent(e.clone());
			
			var e2 : SocketServerEvent = new SocketServerEvent(SocketServerEvent.CONNECTION_ERROR);
			e2.attempt = _numAttempt;
			e2.error = "SecurityError";
			dispatchEvent(e2);
			
			_askClose = true;
			_netconnection.close();
			_askClose = false;
			
			_reconnectionTimer.start();
		}

		
		//--------------------------------------
		//					SETTER / GETTER
		//--------------------------------------
		
		/**
		 * Retourne l'objet netconnection
		 */
		public function get netconnection() : NetConnection {
			return _netconnection;
		} 

		
		/**
		 * Retourne l'URI du serveur à laquelle on s'est connecté.
		 */
		public function get uri() : String {
			return _uri;
		}

		
		/**
		 * Nombre max d'essai avant de déclarer une connexion impossible.
		 *
		 *	@default 3
		 */
		public function get maxAttempts() : uint {
			return _maxAttempts;
		} 

		
		public function set maxAttempts(p : uint) : void {
			_maxAttempts = p;
		} 

		
		/**
		 * Temps d'attente entre deux connexions (en millisecondes).
		 * 
		 * @default 1000
		 */
		public function get reconnectionDelay() : uint {
			return _reconnectionDelay;
		}

		
		public function set reconnectionDelay(p : uint) : void {
			_reconnectionDelay = p;
			_reconnectionTimer.delay = _reconnectionDelay;
		} 

		
		/**
		 * Temps d'attente (en millisecondes) avant une nouvelle connexion quand la connexion est 
		 * déclarée impossible (On a tenté de se connecter [maxAttempts] fois à tous les serveurs
		 * sans succès).
		 *  
		 *  @default 30000
		 */
		public function get reconnectionDelayImpossible() : uint {
			return _reconnectionDelayImpossible;
		}

		
		public function set reconnectionDelayImpossible(p : uint) : void {
			_reconnectionDelayImpossible = p;
			_reconnectionTimerImpossible.delay = _reconnectionDelayImpossible;
		}

		
		/**
		 * Délai (en millisecondes) à partir duquel on déclare qu'on ne pourra pas se connecter
		 * à l'URI (sans réponse du serveur).
		 *  
		 * @default 5000 
		 */
		public function get FMSResponseTimeOut() : uint {
			return _FMSResponseTimeOut;
		}

		
		public function set FMSResponseTimeOut(p : uint) : void {
			_FMSResponseTimeOut = p;
			_fmsResponseTimer.delay = _FMSResponseTimeOut;
		}
	}
}
