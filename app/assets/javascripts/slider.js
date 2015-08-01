/*banner插件 zhaoyulong*/
;(function ($) {	
	$.flexslider = function(el, options) {
		//默认参数
		$.flexslider.defaults = {
			selector: ".slides > li",       //Selector:必须匹配一个简单的模式，规避潜在风险 √
			animation: "fade",              //String:选择你的动画类型，“淡出fade”或“幻灯片slide”
			direction: "horizontal",        //String:选择滑动方向，“水平”或“垂直”animation位slide才触发
			animationLoop: true,            //Boolean:动画是否循环？
			beforeNum: -1,                  //Integer:执行动画之前的banner定位
			currentNum: 0,                  //Integer:执行动画的当前banner定位
			slideshowSpeed: 7000,           //Integer:幻灯两张之间间隔切换时间（单位毫秒）
			animationSpeed: 600,            //Integer:动画执行时间（单位毫秒）
			initDelay: 0,                   //Integer:第一次动画初始化延时时间（单位毫秒）	
			pauseOnHover: false,            //Boolean:鼠标移动到幻灯片范围停止自动滑动
			// Carousel Options
			itemWidth: 0,                   //Integer:轮播宽度
			minItems: 0,                    //Integer:最少循环个数（为0不限制）
			maxItems: 0,                    //Integer:最大循环个数（为0不限制）
			// Callback API
			start: function(){},            //Callback:只有一张图的情况，运行空函数
			after: function(){},            //Callback:每一个滑块执行完动画后执行
			end: function(){}               //Callback:完成最后一张幻灯片动画后执行
		};
		var slider = $(el),	vars = $.extend({},$.flexslider.defaults,options);
		try{		
			_this = this;
			for(var k in vars){
				_this[k] = vars[k];
			}
		} catch (e) {
			console.log("配置错误：" + e);
		}
		//方法
		methods = {
			init:function(){	
				methods.addControlNav();				
				if(_this['animation'] === 'fade'){
					_this['timer'] = setInterval(methods.autoStart,3000);
					events.controlEvent();
				}else if(_this['animation'] === 'slide'){
					if(_this['direction']==='horizontal'){
						//待拓展
					}
				}
				$(_this['selector']).parent().prev(".loader").hide();
			},
			addControlNav:function(){
				_this['controlNav'] = $('<ul class="control-nav"></ul>');
				for(var i=0;i<$(_this['selector']).length;i++){
					_this['controlNav'].append('<li>'+i+'</li>');
				}				
				$(_this['selector']).parent().after(_this['controlNav']);
				_this['controlNav'].children("li").eq(_this['currentNum']).addClass('focus');
			},
			changeFades:function(){				
				$(vars.selector).eq(_this['beforeNum']).stop().fadeOut(300,function(){
					$(this).css("z-index",1);
				});
				$(vars.selector).eq(_this['currentNum']).stop().fadeIn(300,function(){
					$(this).css("z-index",2);
				});
				_this['controlNav'].children("li").removeClass("focus");
				_this['controlNav'].children("li").eq(_this['currentNum']).addClass('focus');
			},
			autoStart:function(){				
				_this['beforeNum'] = _this['currentNum'];
				if(_this['currentNum'] >= $(_this['selector']).length-1){
					_this['currentNum']=0;
				}else{
					_this['currentNum']++;
				}
				methods.changeFades();
			},
			prevNum:function(){				
			},
			nextNum:function(){
				
			}	
		}
		events = {
			controlEvent:function(){
				_this['controlNav'].children().on("mouseenter",function(){
					clearInterval(_this['timer']);
					var num = Number($(this).html());
					if(_this['currentNum']!==num){
						_this['beforeNum'] = _this['currentNum'];
						_this['currentNum'] = num;
						methods.changeFades();
					}
				}).on("mouseleave",function(){
					_this['timer'] = setInterval(methods.autoStart,3000);
				});
			}
		}
		methods.init();
	};
	$.fn.flexslider = function(options){
		if (options === undefined) options = {};
		if (typeof options === "object") {
			return this.each(function() {
				var $this = $(this),
				selector = (options.selector) ? options.selector : ".slides > li",
				$slides = $this.find(selector);
				if ($slides.length === 1) {
					$slides.fadeIn(400);
					if (options.start) options.start($this);
				}else{
					new $.flexslider(this, options);
				}
			});
		}
	};
})(jQuery);