package
{
	
	import br.com.stimuli.loading.BulkLoader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author umhr
	 */
	public class Canvas extends Sprite
	{
		private var _bulkLoader:BulkLoader;
		private var _photoSliderList:Array /*PhotoSlider*/;
		private var _timer:Timer;
		
		public function Canvas()
		{
			init();
		}
		
		private function init():void
		{
			if (stage)
				onInit();
			else
				addEventListener(Event.ADDED_TO_STAGE, onInit);
		}
		
		private function onInit(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			_bulkLoader = new BulkLoader("theOne");
			_bulkLoader.add("images/img0.jpg", {type: BulkLoader.TYPE_IMAGE, id: "img0"});
			_bulkLoader.add("images/img1.jpg", {type: BulkLoader.TYPE_IMAGE, id: "img1"});
			_bulkLoader.add("images/img2.jpg", {type: BulkLoader.TYPE_IMAGE, id: "img2"});
			_bulkLoader.add("images/img3.jpg", {type: BulkLoader.TYPE_IMAGE, id: "img3"});
			_bulkLoader.addEventListener(BulkLoader.COMPLETE, bulkLoader_complete);
			_bulkLoader.start();
		
		}
		
		private function bulkLoader_complete(e:Event):void
		{
			var imgW:int = _bulkLoader.getBitmapData("img0").width;
			var imgH:int = _bulkLoader.getBitmapData("img0").height;
			_photoSliderList = [];
			var n:int = Math.floor(imgH / 32);
			for (var i:int = 0; i < n; i++)
			{
				var photoSlider:PhotoSlider = new PhotoSlider();
				photoSlider.addBitmapData(_bulkLoader.getBitmapData("img0"), new Rectangle(0, i * 32, imgW, 32));
				photoSlider.addBitmapData(_bulkLoader.getBitmapData("img1"), new Rectangle(0, i * 32, imgW, 32));
				photoSlider.addBitmapData(_bulkLoader.getBitmapData("img2"), new Rectangle(0, i * 32, imgW, 32));
				photoSlider.addBitmapData(_bulkLoader.getBitmapData("img3"), new Rectangle(0, i * 32, imgW, 32));
				addChild(photoSlider);
				photoSlider.position = new Point(0, i);
				photoSlider.x = 0;
				photoSlider.y = i * 32;
				photoSlider.setMask();
				_photoSliderList.push(photoSlider);
			}
			
			_timer = new Timer(7000, 0);
			_timer.addEventListener(TimerEvent.TIMER, timer_timer);
			_timer.start();
			
			timer_timer(null);
		}
		
		private function timer_timer(e:TimerEvent):void
		{
			var n:int = _photoSliderList.length;
			for (var i:int = 0; i < n; i++)
			{
				var photoSlider:PhotoSlider = _photoSliderList[i];
				photoSlider.doTween(i * (n - i) * 10);
			}
		}
	}

}