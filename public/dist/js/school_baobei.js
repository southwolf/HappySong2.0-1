

jQuery(document).ready(function ($) {

    //添加新学校
    function sadd() {

        var d1_name = $('#d1').val();

        if (d1_name == '') {
            alert('请先选择区域');
            return false;
        }


        if ($.trim($('#sname').val()) == '') {
            alert('请输入学校');
            return false;
        }

        //获取省市区学校的名字
        var p1_name = $("#p1").find("option:selected").text()
        var c1_name = $('#c1').find("option:selected").text()
        var d1_name = $('#d1').find("option:selected").text()
        var s1_name = $('#sname').val();
        var info1 = p1_name + c1_name + d1_name;
        var dist_id = $('#d1').val();

        $.ajax({
            type: "post",
            url: '/channel/school/schoolAdd',
            dataType: 'text',
            data: {name: s1_name, district_id: dist_id},
            success: function (msg) {

                if (msg == 'token') {
                    alert('该学校已经存在');
                    return false;
                }

                if (msg == 'fail') {
                    alert('失败,请重试');
                    return false;
                }

                var con = "<li class='add'><span class='addschool' id='" + msg + "'>" + s1_name + "</span><span>" + info1 + "</span><span><img class='conimg' src='/dist/close.png'></span></li>";
                $('.preadd').append(con);
                $('.conimg').click(function () {
                    $(this).parent().parent().hide();
                })
            }
        });
    }


    $('.theme-login').click(function () {
        $('.theme-popover-mask').fadeIn(100);
        $('.theme-popover').slideDown(200);
    })
    $('.theme-poptit .close').click(function () {
        $('.theme-popover-mask').fadeOut(100);
        $('.theme-popover').slideUp(200);
    })






})




//省市区学校
$(function () {

    var province = $('#province');

    var city = $('#city');

    var district = $('#district');

    province.change(function (event) {
        var province_id = province.val();

        if (province_id == " ") {
            return false;
        }

        $.ajax({
            url: '/api/v1/cities',
            method: 'GET',
            data: {province_id: province_id},
            dataType: "json",
            success: function (data) {
                var city = $("#city");
                city.empty();
                var dom = '<option value="">选择市</option>';
                $.each(data, function (k, v) {
                    dom += "<option value=" + v.id + ">" + v.name + "</option>";
                });

                city.append(dom);
            }
        })

    });

    city.change(function (event) {
        console.log("city change")
        var city_id = city.val();
        if (city_id == " ")
            return
        else {
            $.ajax({
                url: '/api/v1/districts',
                method: 'GET',
                data: {city_id: city_id},
                dataType: "json",
                success: function (data) {
                    var district = $("#district");
                    district.empty();
                    var dom = '<option value="">选择区(县)</option>';
                    $.each(data, function (k, v) {
                        dom += "<option value=" + v.id + ">" + v.name + "</option>";
                    });

                    district.append(dom);
                }
            })
        }

    });

    district.change(function (event) {
        console.log("city change")
        var district_id = district.val();
        if (district_id == " ")
            return
        else {
            $.ajax({
                url: '/api/v1/school_manager/school/search',
                method: 'GET',
                data: {district_id: district_id},
                dataType: "json",
                success: function (data) {
                    var school = $("#school");
                    school.empty();
                    var dom = '<option value="">选择学校</option>';
                    $.each(data, function (k, v) {
                        dom += "<option value=" + v.id + ">" + v.name + "</option>";
                    });

                    school.append(dom);
                }
            })
        }

    });
})

//append 将要报备的信息到下边的框框中
$('.subbot').click(function () {

    //学校的id
    var s_id = $('#school').val();

    if ($("#" + s_id).length > 0) {
        return false;
    }

    if (!checkSchool(s_id)) {
        alert('该学校已经报备,请联系管理员');
        return false;
    }

    //获取省市区学校的名字
    var p_name = $("#province").find("option:selected").text()
    var c_name = $('#city').find("option:selected").text()
    var d_name = $('#district').find("option:selected").text()
    var s_name = $('#school').find("option:selected").text()

    if (s_name == '选择学校') {
        return false;
    }

    var info = p_name + c_name + d_name;

    var con = "<li class='add'><span class='addschool' id='" + s_id + "'>" + s_name + "</span><span>" + info + "</span><span><img class='conimg' src='/dist/close.png'></span></li>";
    $('.preadd').append(con);

    $('.conimg').click(function () {
        $(this).parent().parent().hide();
    })

})

//开始插入数据库
$('#subapply').click(function () {

    var ids = [];

    $('.addschool').each(function () {
        ids.push($(this).attr('id'));
    })

    if (ids.length == 0) {
        alert('请先添加学校')
    }

    $.ajax({
        type: "post",
        url: '/channel/school/addSchool',
        dataType: 'text',
        data: {ids: $.toJSON(ids)},
        success: function () {
            alert('申请成功,等待管理员审核,谢谢');
            window.location.reload()
        }
    });

})

//check学校是否已经报备  return true or false
function checkSchool(obj) {
    var result = false;
    $.ajax({
        type: "post",
        url: '/channel/school/checkSchool',
        async: false,
        dataType: 'text',
        data: {school_id: obj},
        success: function (date) {
            if (date == 'yes') {
                result = false;
            } else {
                result = true;
            }
        }
    });

    return result;

}

//弹出框 省市区
$(function () {

    var p1 = $('#p1');

    var c1 = $('#c1');

    var d1 = $('#d1');

    p1.change(function (event) {
        var province_id = p1.val();

        if (province_id == " ") {
            return false;
        }

        $.ajax({
            url: '/api/v1/cities',
            method: 'GET',
            data: {province_id: province_id},
            dataType: "json",
            success: function (data) {
                var c1 = $("#c1");
                c1.empty();
                var dom = '<option value="">选择市</option>';
                $.each(data, function (k, v) {
                    dom += "<option value=" + v.id + ">" + v.name + "</option>";
                });

                c1.append(dom);
            }
        })

    });

    c1.change(function (event) {
        console.log("city change")
        var city_id = c1.val();
        if (city_id == " ")
            return
        else {
            $.ajax({
                url: '/api/v1/districts',
                method: 'GET',
                data: {city_id: city_id},
                dataType: "json",
                success: function (data) {
                    var d1 = $("#d1");
                    d1.empty();
                    var dom = '<option value="">选择区(县)</option>';
                    $.each(data, function (k, v) {
                        dom += "<option value=" + v.id + ">" + v.name + "</option>";
                    });

                    d1.append(dom);
                }
            })
        }

    });

})

