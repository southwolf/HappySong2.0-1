

Do(function() {

 	var shade = layer.load(1, {shade: [0.3,'#000']});//转圈遮罩
  var token = $('#token').val();
    //获取子女列表
    $.ajax({
    	type:"get",
    	url:"/api/v1/users/children",
      data:{
        token: token
      },
    	success:function (res) {
    		layer.close(shade);
    		console.log(res);
    		writeznlist(res);//这边使用真数据调用方法
    	},
    	error:function () {
			layer.close(shade);
			layer.msg('获取子女列表失败',{time: 1000});
    	}
    });

   //生成子女列表的假数据，真数据用ajax返回，这段删除




	$('.dialogbox').click(function(){
		if ($(this).find('label').attr('name')=='vx') {
			layer.alert('微信支付功能暂未开通');
			return false;
		}
		var radioId = $(this).find('label').attr('name');
		$('.dialogbox').find('label').removeAttr('class') && $(this).find('label').attr('class', 'checked');
		$('.dialogbox').find('input[type="radio"]').removeAttr('checked') && $('#' + radioId).prop('checked', 'checked');
	});

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
				amount:$('.price .zn-hover').data("price"),//价格
				token: token,
				target_user_id:$('.zn .zn-hover').data("userid")//用户id
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
