var allInputs = new Array();

//蒐集Form裡面所有要控制Keydown的輸入控制項，並註冊keydown事件
function prepareForm(f) {

    var x = 0;
    for (var i = 0; i < f.elements.length; i++) {
        console.log(f.elements[i].type);
        var type = f.elements[i].type;
        if (type == "text" || type == "password" || type == "select-one" || type == "submit" || type == "email") {
            allInputs[x] = f.elements[i];
            allInputs[x].onkeydown = processKeydown;
            x++;
        }
    }

}

//下或Enter : 跳下一個
//上 : 跳上一個
//左 : 跳上一個，遇DropDownList變成選上一個
//右 : 跳下一個，遇DropDownList變成選下一個
function processKeydown(e) {
    var elem = (e.target) ? e.target : ((e.srcElement) ? e.srcElement : null);
    var charCode = (e.charCode) ? e.charCode : ((e.which) ? e.which : e.keyCode);

    switch (charCode) {
        case 13: // ENTER
        case 40: // DOWN
            doFocusNext(elem);
            break;
        case 38: // UP
            doFocusPrevious(elem);
            break;
        case 37: // LEFT

            if (elem.type == "select-one") {
                if (elem.selectedIndex != null) {
                    if (elem.selectedIndex == 0)
                        elem.selectedIndex = elem.options.length - 1;
                    else
                        elem.selectedIndex -= 1;
                } else {
                    elem.selectedIndex = 0;
                }
            }
            else
                doFocusPrevious(elem);

            break;
        case 39: // RIGHT

            if (elem.type == "select-one") {
                if (elem.selectedIndex != null) {
                    if (elem.selectedIndex == (elem.options.length - 1)) {
                        elem.selectedIndex = 0;
                    } else {
                        elem.selectedIndex += 1;
                    }
                } else {
                    elem.selectedIndex = 0;
                }
            }
            else
                doFocusNext(elem);

            break;
        default:
            return;
            break;
    }

    event.preventDefault();
    event.stopPropagation();

}

function doFocusNext(elem) {

    var i = allInputs.indexOf(elem)
    i++;
    if (i == allInputs.length)
        allInputs[0].focus();
    else
        allInputs[i].focus();

}

function doFocusPrevious(elem) {

    var i = allInputs.indexOf(elem)
    i--;
    if (i < 0)
        allInputs[allInputs.length - 1].focus();
    else
        allInputs[i].focus();

}


window.onload = function () {

    prepareForm(document.forms[0]);


}