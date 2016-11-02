
Do(function() {

  var shade = layer.load(1, {shade: [0.3,'#000']});//转圈遮罩
  	var token = $('#token').val();
    //获取子女列表
    $.ajax({
    	type:"get",
    	url:"/api/v1/users/children",
      data: {
        token: token
      },
    	success:function (res) {
    		writeznlist(res);//这边使用真数据调用方法
    	},
    	error:function () {
			layer.close(shade);
			layer.msg('获取子女列表失败',{time: 1000});
    	}
    });

    // //生成子女列表的假数据，真数据用ajax返回，这段删除
    // var _arr = [
    // 	{
    // 		name:'张慧聪',
    // 		id:1
    // 	},
    // 	{
    // 		name:'王小二',
    // 		id:2
    // 	},
    // 	{
    // 		name:'洪金宝',
    // 		id:3
    // 	},
    // 	{
    // 		name:'张三',
    // 		id:4
    // 	}
    // ];
    // writeznlist(_arr);
   //生成子女列表的假数据，真数据用ajax返回，这段删除



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


$(".button").click(function() {
  $("#dialog1").show();
  $("#mask").show();
  $(".dialog-title").find("span").text($(this).data("price"));
});
$("#topclosed1").click(function() {
  $("#dialog1").hide();
  $("#mask").hide();
});

  $(".price").find("dd").click(function () {
      $(".price").find("dd").removeClass();
      $(this).addClass("zn-hover");
      $("#Save").val($(this).attr("id"));
  });

  $('#zhifuBtn').on('click', function(e) {
    if ($('.zn .zn-hover').length==0) {
      layer.msg('请先选择子女',{time: 1000});
      return false;
    }
    if ($('.price .zn-hover').length==0) {
      layer.msg('请选择开通类别',{time: 1000});
      return false;
    }
    e.preventDefault();
    $("#dialog1").show();
    $("#mask").show();
    $(".dialog-title").find("span").text('¥'+$('.price .zn-hover').data("price")+'.00');
  });

  $('.am-button').click(function () {
  shade = layer.load(1, {shade: [0.3,'#000']});
  $.ajax({
    type:"post",
    url:"/api/v1/pay/web_pay",
    data:{
      channel:'alipay_wap',
      account:$('.price .zn-hover').data("price"),//价格
      token: token,
      target_user_id:$('.zn .zn-hover').data("userid")//用户id
    },
    success:function (charge) {
      console.log(charge);
      layer.close(shade);
      layer.alert('获取charge成功');
      return false;
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



  function writeznlist(arr) {
    $('.zn').html('');
    for (var i = 0 ; i < arr.length; i++) {
      $('.zn').append('<dd data-userid="'+arr[i].id+'"><p>'+arr[i].name+'</p></dd>');
    }
  $(".zn").find("dd").click(function () {
        $(".zn").find("dd").removeClass();
        $(this).addClass("zn-hover");
        $("#Save").val($(this).attr("id"));
    });
  };












})
