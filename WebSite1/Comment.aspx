<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Comment.aspx.cs" Inherits="Comment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/bootstrap.css" rel="stylesheet" />
   <style>
        h3 {
            color: black;
        }

        * {
            border: 0px solid #ff0000;
        }

        .veryImportHide {
            display: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div>
        <h3>留言板</h3>
        <input type="button" id="makeComment" class=" btn btn-primary" name="name" value="發表文章" />

    </div>
    <div id="CommentBody">
        <ul>
        </ul>
    </div>


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">











    <div class="modal fade" id="commentStrart" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title" id="exampleModalLabel">New message</h4>

                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="recipient-name" class="control-label">主旨:</label>
                            <input type="text" class="form-control" id="recipient-name" required>
                        </div>
                        <div class="form-group">
                            <label for="message-text" class="control-label">內文:</label>
                            <textarea class="form-control" id="message-text" style="margin-top: 0px; margin-bottom: 0px; height: 250px;" required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" id="demo" class="btn btn-outline-success" >demo</button>
                    <button type="button" id="closeModal" class="realSure btn btn-default" data-dismiss="">取消發文</button>
                    <button type="button" id="comment" class="realSure btn btn-primary" data-dismiss="">發表文章</button>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="comfirmModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-sm " role="document">
            <div class="modal-content btn btn-outline-dark">
                <div class="modal-header">
                    <h4 class="modal-title">提示訊息</h4>

                </div>
                <div class="modal-body">
                    <p id="sureOrNot"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" id="innerCancel" class="btn btn-outline-light" data-dismiss="modal">取消</button>
                    <button type="button" id="innerRealSure" class="btn btn-outline-secondary" data-dismiss="modal">確定</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="script" runat="server">
    <script>
        $(function () {
            $("#commentWebMasterPageLi").addClass("active");
            $("#demo").click(function () {
                $("#recipient-name").val("為什麼要這樣做卡片？");
                 $("textarea").val("大家好，我是新來的，我有卡片的問題想問，為什麼這麼醜的卡片還可以賣錢");
            });
           
        });
        var confirm1 = false;
        var confirm2 = false;
        var modifyModalType = false;
        var messageArray = [];

        function makeDateString(aNewDateTimeID) {
            return `${aNewDateTimeID.getFullYear()}/${aNewDateTimeID.getMonth() + 1}/${aNewDateTimeID.getDate()} ${aNewDateTimeID.getHours() < 10 ? "0" + aNewDateTimeID.getHours() : aNewDateTimeID.getHours()}:${aNewDateTimeID.getMinutes() < 10 ? "0" + aNewDateTimeID.getMinutes() : aNewDateTimeID.getMinutes()}`
        }

        function commentMaker(title, commentIDTimeHuman, body, name, timeID) {
            var commentBoard =

                `
                         <div id="cardForRemove_${timeID}_${name}" class="container">
                             <div class="card mt-3">
                                 <div class="card-body">
                                     <h5 class="card-title row"><div id="cardTitleText_${timeID}_${name}" class="col-sm">${title}</div><div class="col-sm"><label style=" font-size:5px; right:0px ; position:absolute;">${commentIDTimeHuman}</label></div></h5>
                                      <p id="cardBodyText_${timeID}_${name}" class="card-text">${body}</p>
                                     <label>${name}</label>
                                      <input type="button" id="modifyComment_${timeID}_${name}" class="btn-sm btn-primary veryImportHide" style="  right:97px ; position:absolute;"  name="name" value="修改" />
                                        <input type="button" id="deleteComment_${timeID}_${name}"  class="btn-sm btn-primary veryImportHide" name="name"  style="  right:56px ; position:absolute;" value="刪除" />
                                     <input type="button" id="showBoard_${timeID}_${name}" style="  right:15px ; position:absolute;" class="btn-sm btn-primary" name="name" value="留言" />
                                 </div>
                                 <div class="card-footer">

                                     <ul  id="ul_${timeID}_${name}" class="list-group list-group-flush">
                                         
                                     </ul>
                                     
                                     <label>留言：</label><input type="text"  id="message_${timeID}_${name}" placeholder=""  name="name" value="因為我們覺得這樣很酷" /><input type="button" id="insertMessage_${timeID}_${name}" class="btn-sm btn-primary" name="name" value="送出" />
                                  </div>
                             </div>
                         </div>
                 `;

            return commentBoard;
        }

        function modifyDeleteComment(name, timeID, title, content) {
            if (name == "<%=Page.User.Identity.Name%>") {
                $(`#modifyComment_${timeID}_${name}`).removeClass("veryImportHide");
                $(`#deleteComment_${timeID}_${name}`).removeClass("veryImportHide");
            }

            $(`#modifyComment_${timeID}_${name}`).on("click", function () {
                modifyModalType = true;
                $("#recipient-name").val(`${title}`);
                $("#message-text").val(`${content}`);
                $('#commentStrart').modal({ backdrop: 'static', keyboard: false });   //跳modal出來，設定按取消才能關，連esc也鎖住



                $('#commentStrart').one('hide.bs.modal', function () {
                    if (modifyModalType == true && confirm1 == true && confirm2 == true) {

                        //alert("慘了，扯到修改了");
                        $(`#cardTitleText_${timeID}_${name}`).text($("#recipient-name").val());
                        $(`#cardBodyText_${timeID}_${name}`).text($("#message-text").val());

                        let param = {                                   //準備資料ajax
                            TimeLong: timeID,
                            Title: $("#recipient-name").val(),
                            Body: $("#message-text").val(),
                            Author: name

                        }
                        $.ajax({
                            type: 'post',
                            url: "/WebService.asmx/modifyComment",
                            dataType: 'json',
                            data: JSON.stringify(param),
                            contentType: "application/json; charset=utf-8",
                            success: function () {
                                toastr.success("留言板修改", "已將留言板資料修改進資料庫")

                            }
                        });




                        $("#recipient-name").val("");//還原modal
                        $("#message-text").val("");//還原modal
                    }

                });
            });

            $(`#deleteComment_${timeID}_${name}`).on("click", function () {
                if (confirm("真的要刪除嗎")) {

                    let param = {                                   //準備資料ajax
                        TimeLong: timeID,
                        Author: name

                    }
                    $.ajax({
                        type: 'post',
                        url: "/WebService.asmx/deleteComment",
                        dataType: 'json',
                        data: JSON.stringify(param),
                        contentType: "application/json; charset=utf-8",
                        success: function () {
                            toastr.error("已將留言板從資料庫刪除", "留言板刪除成功")

                        }
                    });

                    $(`#cardForRemove_${timeID}_${name}`).remove();
                }

            });

        }

        function messageMaker(body, name, messageTimeID) {
            var messageLi =
                `
                  <li id="li_${messageTimeID}_${name}" class="list-group-item list-group-item-action list-group-item-secondary" >
                      <div class="row">
                          <div class="col-sm-9"><span id="oldTextModify_${messageTimeID}_${name}">${name}:${body}</span><input type="text" id="modifyContent_${messageTimeID}_${name}" class="veryImportHide" name="name" value="修改的測試" /><input type="button" id="modifySent_${messageTimeID}_${name}" class="btn-sm btn-outline-primary veryImportHide" name="name" value="確定" /><input type="button" id="modifyCancelSent_${messageTimeID}_${name}" class="btn-sm btn-outline-primary veryImportHide" name="name" value="取消" /></div>
                     
                          <div class="col-sm"><label style="font-size:1px;" class="close">${makeDateString(new Date(messageTimeID))}</label></div>
                      </div>
                      <div class="row">
                        
                                 <input type="button" id="hideMessageModify_${messageTimeID}_${name}" class=" btn-sm btn-outline-primary veryImportHide " name="name" value="修改" />
                                <input type="button" id="hideMessageDelete_${messageTimeID}_${name}"  class="btn-sm btn-outline-primary veryImportHide " name="name" value="刪除" />
                                <input type="button" id="hideMessageDeleteConfirm_${messageTimeID}_${name}" class="btn-sm btn-outline-primary veryImportHide" name="name" value="確認嗎?" />
                                <input type="button" id="hideMessageDeleteConfirmCancel_${messageTimeID}_${name}" class="btn-sm btn-outline-primary veryImportHide" name="name" value="取消" />

                      </div>
                  </li>
              `;

            return messageLi
        }

        function toggleClassVeryImportHide(itemID, name, ) {
            let onOff = 0;


            $(`#li_${itemID}_${name}`).click(function () { //按到li就跑出修改跟刪除兩個按鈕，這邊定為，狀態一

                if (onOff == 0) {
                    $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");        //這是修改鈕
                    $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");        //這是刪除鈕
                }
            });

            $(`#hideMessageDelete_${itemID}_${name}`).on("click", function () {     //這是按了刪除後
                onOff = 1;                                                                                              //因為按了沒有去關閉他還是會一直toggle會干擾，所以要去互鎖一下
                $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");            //為了關閉，不顯示修改這顆鈕而設
                $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");
                $(`#hideMessageDeleteConfirm_${itemID}_${name}`).toggleClass("veryImportHide");                              //為了要重覆確認而設

                $(`#hideMessageDeleteConfirmCancel_${itemID}_${name}`).toggleClass("veryImportHide");     //為了要讓他重覆確認時可以反悔而設
            });

            $(`#hideMessageDeleteConfirmCancel_${itemID}_${name}`).on("click", function () {                  //反悔不想刪除時按的取消鈕

                $(`#hideMessageDeleteConfirm_${itemID}_${name}`).toggleClass("veryImportHide");                           //把確認刪除的按鈕也轉回去隱藏
                $(`#hideMessageDeleteConfirmCancel_${itemID}_${name}`).toggleClass("veryImportHide");     //把那個取消鈕轉回去隱藏模式
                onOff = 0;                                                                                                                      //打開讓他回到原本的，狀態一
                $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
                $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
            });


            $(`#hideMessageDeleteConfirm_${itemID}_${name}`).on("click", function () {     //真的再次確認，按下刪除了
                for (var i = 0; i < messageArray.length; i++) {                                                         //找出暫存陣列裡的那一個時間id然後改掉(表面2)
                    if (messageArray[i].MessageTime == itemID && messageArray[i].Author == name) {
                        messageArray[i].DeleteOrNot = 1;
                    }
                }

                let param = {                                   //準備資料ajax
                    id: itemID,
                    name: name

                }
                $.ajax({
                    type: 'post',
                    url: "/WebService.asmx/deleteMessageBoard",
                    dataType: 'json',
                    data: JSON.stringify(param),
                    contentType: "application/json; charset=utf-8",
                    success: function () {
                        toastr.error("已將訊息從資料庫刪除", "刪除成功")

                    }
                });

                $(`#li_${itemID}_${name}`).remove();//刪除li(表面1)
            });



            $(`#hideMessageModify_${itemID}_${name}`).on("click", function () {             //div點完到這邊的修改按鈕按下去後跑下面的方法
                $(`#modifyContent_${itemID}_${name}`).toggleClass("veryImportHide");    //秀出文字方塊準備給他打想修改的字
                $(`#oldTextModify_${itemID}_${name}`).toggleClass("veryImportHide");        //舊的文字label先隱藏
                $(`#modifySent_${itemID}_${name}`).toggleClass("veryImportHide");           //秀出修改完送出的按鈕
                $(`#modifyCancelSent_${itemID}_${name}`).toggleClass("veryImportHide"); //秀出不想修改時的取消按鈕
                onOff = 1;                                                                                              //這個要去互鎖不然點div就會一直toggle很煩會干擾
                $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");    //因為上述的功能鍵都秀出來後這邊這兩顆不關起來會有程序方向分支的可能性就來把他關起來
                $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");    //因為上述的功能鍵都秀出來後這邊這兩顆不關起來會有程序方向分支的可能性就來把他關起來
            });

            $(`#modifyCancelSent_${itemID}_${name}`).on("click", function () {                      //取消修改時按的按鈕
                $(`#oldTextModify_${itemID}_${name}`).toggleClass("veryImportHide");            //舊的字因為沒有改所以就秀回來
                $(`#modifyContent_${itemID}_${name}`).toggleClass("veryImportHide").val("");        //文字方塊就隱藏，並且內部的內容清掉
                $(`#modifySent_${itemID}_${name}`).toggleClass("veryImportHide");           //按鈕消掉
                $(`#modifyCancelSent_${itemID}_${name}`).toggleClass("veryImportHide");     //取消鈕也自已消掉
                onOff = 0;                                                                                          //回到狀態一
                $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
                $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
            });


            $(`#modifySent_${itemID}_${name}`).on("click", function () {                                    //這是重頭戲，打完文字後確定修改要按的按鈕
                let oldText = $(`#oldTextModify_${itemID}_${name}`).text().split(':')[0];                   //取資料
                let newText = $(`#modifyContent_${itemID}_${name}`).val()                                   //取資料
                for (var i = 0; i < messageArray.length; i++) {                                                         //找出暫存陣列裡的那一個時間id然後改掉
                    if (messageArray[i].MessageTime == itemID && messageArray[i].Author == name) {
                        messageArray[i].Message = newText;
                    }
                }
                let param = {                                   //準備資料ajax
                    id: itemID,
                    name: name,
                    newMessage: newText
                }
                $.ajax({
                    type: 'post',
                    url: "/WebService.asmx/modifyMessageBoard",
                    dataType: 'json',
                    data: JSON.stringify(param),
                    contentType: "application/json; charset=utf-8",
                    success: function () {
                        toastr.success("已將訊息修改進資料庫", "回覆的訊息修改成功")
                    }
                });


                $(`#oldTextModify_${itemID}_${name}`).toggleClass("veryImportHide").text(oldText + ":" + $(`#modifyContent_${itemID}_${name}`).val());          //舊的字取出姓名+上符號: 然後組上新的修改字
                $(`#modifyContent_${itemID}_${name}`).toggleClass("veryImportHide").val("");                            //消掉文字方塊元件，並清空文字方塊
                $(`#modifySent_${itemID}_${name}`).toggleClass("veryImportHide");                                   //也消掉
                $(`#modifyCancelSent_${itemID}_${name}`).toggleClass("veryImportHide");                         //也消掉
                onOff = 0;                                                                                                                  //回狀態一
                $(`#hideMessageModify_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
                $(`#hideMessageDelete_${itemID}_${name}`).toggleClass("veryImportHide");//這只是為了讓他不要馬上又秀才打而已
            });
        }

        $(function () {
            $.ajax({
                type: 'post',
                url: "/WebService.asmx/getTimeIDMessage",
                dataType: 'json',

                contentType: "application/json; charset=utf-8",
                success: function (obj) {
                    $(obj.d).each(function (index, item) {

                        messageArray.push(item);


                    });
                }
            });

           <%-- $.ajax({        //抓資料庫出來秀

                type: 'post',
                url: "/WebService.asmx/getAllComment",
                dataType: 'json',

                contentType: "application/json; charset=utf-8",

                success: function (obj) {

                    $(obj.d).each(function (index, item) {
                        var timeID = item.TimeLong;
                        var aNewDateTimeID = new Date(item.TimeLong);
                        var timeIDhumanSee = makeDateString(aNewDateTimeID);
                        var getCommentName = item.Author;
                        $("#CommentBody").append(

                            commentMaker(item.Title, timeIDhumanSee, item.Body, getCommentName, timeID)
                        );


                        modifyDeleteComment(getCommentName, timeID, item.Title, item.Body);


                        let onOff = 0;
                        $(`#showBoard_${timeID}_${getCommentName}`).on("click", function () {
                            if (onOff == 0) {

                                for (var i = 0; i < messageArray.length; i++) {
                                    if (messageArray[i].CommentTime == timeID && messageArray[i].DeleteOrNot == 0) {
                                        let messageTime = messageArray[i].MessageTime;
                                        let loadDataFormSQLinArrayAuthor = messageArray[i].Author;
                                        $(`#ul_${timeID}_${getCommentName}`).append(

                                            messageMaker(messageArray[i].Message, loadDataFormSQLinArrayAuthor, messageTime)
                                        );
                                        if (messageArray[i].Author == "<%=Page.User.Identity.Name%>") {

                                            toggleClassVeryImportHide(messageTime, loadDataFormSQLinArrayAuthor);
                                        }

                                    }
                                }
                                onOff = 1;

                            } else if (onOff = 1) {

                                $(`#ul_${timeID}_${getCommentName}`).find("li").remove();

                                onOff = 0;
                            }
                        });






--%>




                        //$(`#insertMessage_${timeID}_${getCommentName}`).on("click", function () {
                        //    var getMessageText = $(`#message_${timeID}_${getCommentName}`).val();

                        //    let messageTime = new Date().getTime();
                            <%--
                            var messageGuy = "<%=Page.User.Identity.Name%>";--%>
                            //var messageGuy = "test"
                            //var param = {
                            //    message: {
                            //        CommentTime: timeID,
                            //        Message: getMessageText,
                            //        Author: messageGuy,
                            //        MessageTime: messageTime,
                            //        DeleteOrNot: 0
                            //    }

                            //};





                            //$.ajax({
                            //    type: 'post',
                            //    url: "/WebService.asmx/insertMessageBoard",
                            //    dataType: 'json',
                            //    data: JSON.stringify(param),
                            //    contentType: "application/json; charset=utf-8",
                            //    success: function () {
                            //        $(`#ul_${timeID}_${getCommentName}`).append(

                            //            messageMaker(getMessageText, messageGuy, messageTime)
                            //        );

                            //        toggleClassVeryImportHide(messageTime, messageGuy);

                            //        onOff = 1;
                            //    }
                            //});
                            //messageArray.push(param.message);
                        //});

                    //});

                //}

            //});









            $(".realSure").on("click", function () {

                $("#sureOrNot").text(`確定${this.innerText}`);

                if (this.id == "comment") {
                    confirm1 = true;
                } else if (this.id == "closeModal") {
                    confirm1 = false;
                }

                $("#comfirmModal").modal({ backdrop: 'static', keyboard: false });
                $("#innerRealSure").one("click", function () {

                    confirm2 = true;
                    $("#commentStrart").modal('hide');
                    $("#comfirmModal").modal('hide');

                });




            });






        });//READY




        $("#makeComment").click(function () {
            modifyModalType = false;
            $('#commentStrart').one('show.bs.modal', function () {
                //alert(1);//  J個很危險會一直疊要打one
            });

            $('#commentStrart').one('hidden.bs.modal', function () {
                //alert("hidden");//  hidden是關了之後才觸發
            });

            $('#commentStrart').one('hide.bs.modal', function () {
                $("#CommentBody").prepend(
                commentMaker("測試", "123", "測試", "eric", "time123")  //就這一個
                );

            





                //alert("hide");//  hide是得到要關的指令後在關掉之前觸發
                if (modifyModalType == false && confirm1 == true && confirm2 == true) {
                    //alert("驚嚇!現在扯到了新增了");
                    var innerTitle = $("#recipient-name").val().replace(/</g, "&lt;").replace(/>/g, "&gt;");
                    var innerContent = $("#message-text").val().replace(/</g, "&lt;").replace(/>/g, "&gt;");
                    var dateTimeForCommentID = new Date();<%--
                    var name = "<%=Page.User.Identity.Name%>";--%>
                    var name = "test"
                    var CommentIDForMessage = new Date(dateTimeForCommentID).getTime();
                    let timeIDhumanSeeForInsertMode = makeDateString(new Date(dateTimeForCommentID));
                    var param = {
                        commentClass: {
                            CommentTime: dateTimeForCommentID,
                            Title: innerTitle,
                            Body: innerContent,
                            Author: name,
                            TimeLong: CommentIDForMessage
                        }

                    };

                    confirm1 = false; // ajax會有突發狀況沒有成功，所以要在這邊就false
                    confirm2 = false;   // ajax會有突發狀況沒有成功，所以要在這邊就false
                    modifyModalType = true;
                   <%-- $.ajax({        //抓資料進資料庫

                        type: 'post',
                        url: "/WebService.asmx/insertComment",
                        dataType: 'json',
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify(param),
                        success: function () {
                            $("#CommentBody").prepend(

                                commentMaker(innerTitle, timeIDhumanSeeForInsertMode, innerContent, name, CommentIDForMessage)
                               
                            );

                            modifyDeleteComment(name, CommentIDForMessage, innerTitle, innerContent);



                            let onOff = 0;
                            $(`#showBoard_${CommentIDForMessage}_${name}`).on("click", function () {
                                if (onOff == 0) {

                                    for (var i = 0; i < messageArray.length; i++) {
                                        if (messageArray[i].CommentTime == CommentIDForMessage && messageArray[i].DeleteOrNot == 0) {

                                            $(`#ul_${CommentIDForMessage}_${name}`).append(

                                                messageMaker(messageArray[i].Message, messageArray[i].Author, messageArray[i].MessageTime)
                                            );
                                            if (messageArray[i].Author == "<%=Page.User.Identity.Name%>") {

                                                toggleClassVeryImportHide(messageArray[i].MessageTime, messageArray[i].Author);
                                            }

                                        }
                                    }
                                    onOff = 1;

                                } else if (onOff = 1) {

                                    $(`#ul_${CommentIDForMessage}_${name}`).find("li").remove();

                                    onOff = 0;
                                }
                            });//收合回覆訊息的括號


                            $(`#insertMessage_${CommentIDForMessage}_${name}`).on("click", function () {

                                var getMessageText = $(`#message_${CommentIDForMessage}_${name}`).val();
                                var messageTime = new Date().getTime();
                                var param = {
                                    message: {
                                        CommentTime: CommentIDForMessage,
                                        Message: getMessageText,
                                        Author: name,
                                        MessageTime: messageTime,
                                        DeleteOrNot: 0
                                    }

                                };
                                $.ajax({
                                    type: 'post',
                                    url: "/WebService.asmx/insertMessageBoard",
                                    dataType: 'json',
                                    data: JSON.stringify(param),
                                    contentType: "application/json; charset=utf-8",
                                    success: function () {
                                        $(`#ul_${CommentIDForMessage}_${name}`).append(

                                            messageMaker(getMessageText, name, messageTime)
                                        );
                                        toggleClassVeryImportHide(messageTime, name);

                                        messageArray.push(param.message);
                                        onOff = 1; //因為剛打完訊息列表中有東西要改1不然就會打開留言插在他的下面很醜，所以就要先讓留言是收的模式把這個也remove掉之後，再去打開(重load陣列)才會順眼
                                    }
                                });
                            });//新增模式中馬上要插入回覆訊息的送出鈕
                        }

                    });--%>
                }//判斷是新增模式的括號
                $("#recipient-name").val("");//還原modal
                $("#message-text").val("");//還原modal
            });//新增模式的modal關閉時會跑的語法的括號'hide.bs.modal'
            $('#commentStrart').modal({ backdrop: 'static', keyboard: false });//按取消才能關，連esc也鎖住

        });


    </script>
    <script src="Scripts/bootstrap.bundle.js"></script>
  </asp:Content>




