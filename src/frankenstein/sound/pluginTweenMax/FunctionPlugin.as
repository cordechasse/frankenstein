/*
 * Copyright © CorDeChasse 1999-2011
 */

package frankenstein.sound.pluginTweenMax {
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;

	/**
	 * <div class="author">
	 * <p>
	 * 		<b>Author </b> n.bush<br />
	 * 		<b>Date </b> 4 nov 2009<br />
	 * 		<b>Version </b> 1.0.0<br />
	 * </p>
	 * <p>
	 * 		<b>Language Version </b> Actionscript 3.0<br />
	 * 		<b>Runtimes Version </b> Flash Player 9<br />
	 * </p>
	 * </div>
	 * <p>
	 * Plugin pour tweenmax v11<br />
	 * Il permet de faire un tween sur un objet<br />
	 * plutot que de modifier une propriété de l'objet,
	 * il appelle une méthode setter et getter specifié
	 * </p>
	 * @example
	 * <listing version="3.0">
	 * 	<pre class="prettyprint">
	 * 		TweenPlugin.activate([FunctionPlugin]);
	 * 		TweenLite.to(obj, 1, {functionPlugin:{setter: "setProperty", setterParams: [param], getter : "getProperty", getterParams: [param], destValue: newVolume}});
	 * 		
	 * 		//Le tween sera fait sur l'objet en appelant les setter et getter suivant:
	 * 		obj.getProperty(param);
	 * 		//et
	 * 		obj.setProperty(param, value); //value etant la valeur tweenée
	 * 	</pre>
	 * </listing>
	 * 
	 * @author n.bush
	 * @project TweenMaxFunction
	 * @date 4 nov. 2009
	 * 
	 */
	public class FunctionPlugin extends TweenPlugin {
		
		public static const API:Number = 1.0; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		
		/** @private **/
		protected var _target:Object;
		protected var _value : Number;
		
		private var _setter : String;
		private var _setterParams : Array;
		
		private var _getter : String;
		private var _getterParams : Array;
		
		private var _internalValue : Number;
		
		
		public function FunctionPlugin() {
			super();
			this.propName = "functionPlugin";
			this.overwriteProps = ["functionPlugin"];
		}
		
		/** @private **/
		override public function onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			
			_target = target;
			_getter = value.getter;
			_getterParams = value.getterParams;
			_setter = value.setter;
			_setterParams = value.setterParams;
			
			_internalValue = changeFactor;
			
			addTween(this, "internalValue", changeFactor, value.destValue, "internalValue");
			return true;
		}
		
		/** @private **/
		override public function set changeFactor(n:Number):void {
			updateTweens(n);
			(_target[_setter] as Function).apply(_target, _setterParams.concat(_internalValue));
		}
		
		
		/** @private **/
		override public function get changeFactor():Number {
			return (_target[_getter] as Function).apply(_target, _getterParams);
		}
		
		public function get internalValue() : Number {
			return _internalValue;
		}
		
		public function set internalValue(internalValue : Number) : void {
			_internalValue = internalValue;
		}
	}
}
