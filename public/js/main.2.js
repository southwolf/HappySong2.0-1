Do(function () {

  	$('.dialogbox').eq(1).click(function(){
  		layer.alert('微信支付功能暂未开通');
  		return false;
  		var radioId = $(this).find('label').attr('name');
  		$('.dialogbox').find('label').removeAttr('class') && $(this).find('label').attr('class', 'checked');
  		$('.dialogbox').find('input[type="radio"]').removeAttr('checked') && $('#' + radioId).prop('checked', 'checked');
  	});

  	var iLayer ;
  	$(".button").click(function() {
  		iLayer = layer.open({
  			zIndex:999,
  			type: 1,
  			title: false,
  			closeBtn: 0,
  			area: '300px',
  			skin: 'layui-layer-nobg', //没有背景色
  			shadeClose: true,
  			content: $('#dialog1')
  		});
  //
  //		$("#dialog1").show();
  //		$("#mask").show();
  		$(".dialog-title").find("span").text($(this)[0].dataset.price);


  	});
  	$("#topclosed1").click(function() {
  		layer.close(iLayer);
  //		$("#dialog1").hide();
  //		$("#mask").hide();
  	});
  	var shade;
  	var token = $('#token').val();
  	$('#tt').click(function () {
  		shade = layer.load(1, {
  			shade: [0.3,'#000'] //0.1透明度的白色背景
  		});
  		$.ajax({
  			type:"post",
  			url:"/api/v1/pay/web_pay",
  			data:{
  				channel:'alipay_wap',
  			  amount: parseInt($(".dialog-title").find("span").text().substring(1,$(".dialog-title").find("span").text().length)),
  				token: token,
  				target_user_id:''
  			},
  			success:function (charge) {
  				// console.log(charge);
  				// layer.close(shade);
  				// layer.alert('获取charge成功');
  				pingpp.createPayment(charge, function(result, error){
  					console.log(result,error)
  				    if (result == "success") {
  				    	alert('支付成功');
  				      // 只有微信公众账号 wx_pub 支付成功的结果会在这里返回，其他的 wap 支付结果都是在 extra 中对应的 URL 跳转。
  				    } else if (result == "fail") {
  				    	alert('支付失败');
  				        // charge 不正确或者微信公众账号支付失败时会在此处返回
  				    } else if (result == "cancel") {
  				        // 微信公众账号支付取消支付
  				    }
  				});

  			},
  			error:function (res) {
  				layer.close(shade);
  				layer.alert('获取charge失败');
  				console.log(res)
  			}
  		});
  	});
})
