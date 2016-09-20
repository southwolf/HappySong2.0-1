function more(obj) {
    $(obj).addClass('will_go').siblings().removeClass('will_go');
    $('.work-confirm-container').show();
}

function hidediv() {
    $('.work-confirm-container').hide();
}
