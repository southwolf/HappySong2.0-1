
Do(function() {
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
			url:"http://abc.happysong.com.cn/api/v1/pay/web_pay",
			headers: {
        "Content-type": "text/html",
				"charset":"utf-8"
			},
			data:{
				channel:'alipay_wap',
				amount: parseInt($(".dialog-title").find("span").text().substring(1,$(".dialog-title").find("span").text().length)),
				token: token,
				target_user_id:''
			},
			success:function (charge) {
				console.log(charge);
				layer.close(shade);
				layer.alert('获取charge成功');
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


//	var charge = {
//    "id": "ch_a5OinLGyzzjLXPSOy9rPKKiL",
//    "object": "charge",
//    "created": 1458186221,
//    "livemode": true,
//    "paid": false,
//    "refunded": false,
//    "app": "app_1Gqj58ynP0mHeX1q",
//    "channel": "alipay_wap",
//    "order_no": "123456789",
//    "client_ip": "127.0.0.1",
//    "amount": 100,
//    "amount_settle": 100,
//    "currency": "cny",
//    "subject": "Your Subject",
//    "body": "Your Body",
//    "extra": {},
//    "time_paid": null,
//    "time_expire": 1458272621,
//    "time_settle": null,
//    "transaction_no": null,
//    "refunds": {
//        "object": "list",
//        "url": "/v1/charges/ch_a5OinLGyzzjLXPSOy9rPKKiL/refunds",
//        "has_more": false,
//        "data": []
//    },
//    "amount_refunded": 0,
//    "failure_code": null,
//    "failure_msg": null,
//    "metadata": {},
//    "credential": {
//        "object": "credential",
//        "alipay": {
//            "orderInfo": "service=\"mobile.securitypay.pay\"&_input_charset=\"utf-8\"&notify_url=\"https%3A%2F%2Fapi.pingxx.com%2Fnotify%2Fcharges%2Fch_a5OinLGyzzjLXPSOy9rPKKiL\"&partner=\"2008010319263982\"&out_trade_no=\"123456789\"&subject=\"Your Subject\"&body=\"Your Body\"&total_fee=\"0.10\"&payment_type=\"1\"&seller_id=\"2088020116983982\"&it_b_pay=\"2016-03-18 11:43:41\"&sign=\"ODRJPReSwsH8om5fGTqvhia9453k4eUaaGMJTLMTnEYbBuceMyTathvKtdnUpsP6Q5%2F5jcEV887EdtBWi4tuMFHPQmm4dz1nG6b4Blafi6v2tvKaf8b0RiQTOycU4SxigugKoyfeR6E4AGA6uIzWUBRpkq%2BZf65eqT0qe712BJ0%3D\"&sign_type=\"RSA\""
//        }
//    },
//    "description": "Your Description"
//};








})
