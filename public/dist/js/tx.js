jQuery(document).ready(function ($) {
    $('#tx').click(function () {
        $('.theme-popover-mask').fadeIn(100);
        $('.theme-popover-tx').slideDown(200);
    })
    $('.theme-poptit .close').click(function () {
        $('.theme-popover-mask').fadeOut(100);
        $('.theme-popover-tx').slideUp(200);
    })



    $('.z-btn').click(function () {

        var wt = parseFloat($('#money').val());
        var ct = parseFloat($('#cantx').text());

        if ($('#alipay').val() == '') {
            alert('请输入提现支付账号!');
            return false;
        }

        if(isNaN(wt)){
            alert('请输入正确的金额')
            return false;
        }

        if(wt<0 || wt == ''){
            alert('请输入正确的金额')
            return false;
        }

        if(wt > ct){
            alert('可提现金额不足')
            return false;
        }



        if(ct==0){
            alert('暂无可提现金额!');
            return false;
        }


        if (wt == '' || wt ==0) {
            alert('请输入提现金额!');
            return false;
        }



        $.ajax({
            url: "/channel/school/apply_cash_ajax",
            data: {
                amount: parseInt($('#money').val()),
                alipay: $('#alipay').val()
            },
            type: 'post',
            dateType: 'json',
            success: function(data){

                console.log(data == 'success')
                if(data =='success'){
                    alert('申请成功!');
                    location.reload();
                }

                if(data == 'fail'){
                    alert('申请失败!请重新申请');
                    return false;
                }
            },
            error: function(){
                alert('网络错误')
            }

        })

    })


    $("#money").keyup(function () {

        var cantx = parseFloat($('#cantx').text());

        var willtx = parseFloat($(this).val());

        if (isNaN(willtx)) {
           $('#txinfo').text('0元')
            return false;
        }

        $('#txinfo').text(willtx + '元')

        if (willtx > cantx) {
            $("#money").css("background-color", "#f13f4b").css('color', '#ffffff');
            $('.ipf').show();
        } else {
            $("#money").css("background-color", "").css('color', '');
            $('.ipf').hide();
        }


    });


})


