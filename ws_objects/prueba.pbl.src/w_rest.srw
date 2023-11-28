$PBExportHeader$w_rest.srw
forward
global type w_rest from window
end type
type cb_4 from commandbutton within w_rest
end type
type cb_3 from commandbutton within w_rest
end type
type cb_2 from commandbutton within w_rest
end type
type dw_1 from datawindow within w_rest
end type
type cb_1 from commandbutton within w_rest
end type
end forward

global type w_rest from window
integer width = 4754
integer height = 1980
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
dw_1 dw_1
cb_1 cb_1
end type
global w_rest w_rest

on w_rest.create
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.dw_1=create dw_1
this.cb_1=create cb_1
this.Control[]={this.cb_4,&
this.cb_3,&
this.cb_2,&
this.dw_1,&
this.cb_1}
end on

on w_rest.destroy
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.cb_1)
end on

type cb_4 from commandbutton within w_rest
integer x = 238
integer y = 1568
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "MAIL"
end type

event clicked;mailSession mSes
mailReturnCode mRet
mailMessage mMsg
mailFileDescription mAttach

mMsg.Recipient[1].name   = 'mpalacios@columbus.mx'
mMsg.Recipient[1].RecipientType	= mailTo!


mMsg.Subject   = "Pruebas " 
mMsg.NoteText  =  "Pruebas 123" 

// Create a mail session
mSes = CREATE mailSession
// Log on to the session
mRet = mSes.mailLogon("Outlook","")
IF mRet <> mailReturnSuccess! THEN 
	IF mRet = mailReturnLoginFailure! THEN
		MessageBox("AVISO mailSession", ' mailReturnLoginFailure!') 
	ELSEIF mRet =  mailReturnInsufficientMemory! THEN
		MessageBox("AVISO mailSession", ' mailReturnInsufficientMemory!') 
	ELSEIF mRet =  mailReturnTooManySessions! THEN
		MessageBox("AVISO mailSession", ' mailReturnTooManySessions!') 
	ELSEIF mRet =  mailReturnUserAbort! THEN	
			MessageBox("AVISO mailSession", ' mailReturnUserAbort!') 
	ELSE
		MessageBox("AVISO mailSession", ' *Mail Logon.') 
	END IF
	
END IF 



//  mMsg.AttachmentFile[1] = mAttach
//  mRet = mSes.mailAddress(mMsg)
//IF mRet <> mailReturnSuccess! THEN
//    MessageBox("Mail", 'Addressing failed.')
//    RETURN
//END IF
// Send the mail
mRet = mSes.mailSend(mMsg)
IF mRet <> mailReturnSuccess! THEN
    MessageBox("Mail", 'Sending mail failed.')
    RETURN
END IF
mSes.mailLogoff()
DESTROY mSes
end event

type cb_3 from commandbutton within w_rest
integer x = 3022
integer y = 1128
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "MÉTODO 3"
end type

event clicked;string ls_json
string ls_url
string ls_error
long ll_row,ll_return
long ll_root,ll_object,ll_item
long ll_loop1,ll_loop2
long ll_id,ll_data
string ls_data,ls_key
jsonparser lnv_jsonparser
httpclient lnv_httpclient

dw_1.reset()

lnv_httpclient = create httpclient
lnv_jsonparser = create jsonparser
ls_url = "https://employeespb.free.beeceptor.com/getemployees2"

//Get the JSON string via httpclient
ll_return = lnv_httpclient.sendrequest("Get",ls_url)
if ll_return <> 1 then
messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
return
end if
lnv_httpclient.getresponsebody( ls_json)
/* JSON string returned from the URL：
{
"1106":{"First_name":"Vincent","Last_name":"Phillipino","Sex":"Male","Age":63},
"1107":{"First_name":"Natalie","Last_name":"Mariano","Sex":"Female","Age":16},
"1108":{"First_name":"Li","Last_name":"Mary","Sex":"Female","Age":36},
"1109":{"First_name":"Vic","Last_name":null,"Sex":"male","Age":20}
}*/

//Loads the JSON data via jsonpaser
ls_error = lnv_jsonparser.loadstring(ls_json)
if len(trim(ls_error))  > 0 then
Messagebox("Failed","Load json failed:"+ls_error)
return
end if
//Obtains the handle of root item
ll_root = lnv_jsonparser.getrootitem( )
//Obtains the each row in a loop
for ll_loop1 = 1 to lnv_jsonparser.getchildcount(ll_root)
ll_row = dw_1.insertrow(0)
//Obtains ID
ll_id = long(lnv_jsonparser.getchildkey(ll_root, ll_loop1))
dw_1.setitem( ll_row,"id", ll_id)
//Obtains the other column data in a loop
ll_object = lnv_jsonparser.getchilditem( ll_root, ll_loop1)
for ll_loop2 = 1 to lnv_jsonparser.getchildcount( ll_object)
           ll_item = lnv_jsonparser.getchilditem( ll_object, ll_loop2)
           ls_key = lnv_jsonparser.getchildkey( ll_object, ll_loop2)
           //Obtains the data type of each item
           choose case lnv_jsonparser.getitemtype( ll_item)
                    case jsonarrayitem!,jsonobjectitem!,jsonnullitem!
                             //ignores array, object and null item
                    case jsonstringitem!
                             ls_data = lnv_jsonparser.getitemstring(ll_object,ls_key)
                             dw_1.setitem(ll_row,ls_key,ls_data)
                    case jsonnumberitem!
                             ll_data = lnv_jsonparser.getitemnumber(ll_object,ls_key)
                             dw_1.setitem(ll_row,ls_key,ll_data)
                    case jsonbooleanitem!
                             //handles boolean as string
                             ls_data = string(lnv_jsonparser.getitemboolean( ll_object,ls_key))
                             dw_1.setitem(ll_row,ls_key,ls_data)
           end choose
next //Finish processing one row
next//Start processing next row
destroy lnv_jsonparser
end event

type cb_2 from commandbutton within w_rest
integer x = 1659
integer y = 1136
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "MÉTODO 2"
end type

event clicked;string ls_value
string ls_url
string ls_json
long ll_return,ll_row
httpclient lnv_httpclient
jsonpackage lnv_pack1,lnv_pack2

dw_1.reset()

lnv_pack1 = create jsonpackage
lnv_pack2 = create jsonpackage
lnv_httpclient = create httpclient

//Get the JSON string via httpclient
ls_url = "https://employeespb.free.beeceptor.com/dessert"
ll_return = lnv_httpclient.sendrequest("Get",ls_url)
if ll_return <> 1 then
messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
return
end if
lnv_httpclient.getresponsebody( ls_json)
/* JSON string returned from the URL：
 '{
"id": "0001",
"type": "donut",
"name": "Cake",
"ppu": 0.55,
"batters":
           {
                    "batter":
                             [
                                       { "id": "1001", "type": "Regular" },
                                       { "id": "1002", "type": "Chocolate" },
                                       { "id": "1003", "type": "Blueberry" },
                                       { "id": "1004", "type": "Devil~'s Food"},
                       { "id": "5001", "type": "None" }                      
                             ]
           }
}'*/

//Load the JSON string via jsonpackage
lnv_pack1.loadstring(ls_json)
//Get the JSON string under key=batters
ls_value = lnv_pack1.getvalue("batters")
//Load the new JSON string via jsonpackage
lnv_pack2.loadstring( ls_value)
//Get the JSON data under key=batter (this json data meets the requirements by RestClient)
ls_value = lnv_pack2.getvalue( "batter")
//Import JSON data to the DataWindow via importjson
dw_1.importjson(ls_value)
destroy lnv_pack1
destroy lnv_pack2
destroy lnv_httpclient
end event

type dw_1 from datawindow within w_rest
integer x = 187
integer width = 3438
integer height = 1024
integer taborder = 20
string title = "none"
string dataobject = "dw_empl"
boolean minbox = true
boolean maxbox = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rest
integer x = 251
integer y = 1136
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "MÉTODO 1"
end type

event clicked;restclient lnv_restclient
string ls_url
long ll_row
lnv_restclient = create restclient

dw_1.reset()

ls_url = "https://employeespb.free.beeceptor.com/getemployees"
/* JSON string retruned from the url
[
{"Id":1106,"First_name":"Vincent","Last_name":"Phillipino","Sex":"Male","Age":63},
{"Id":1107,"First_name":"Natalie","Last_name":"Mariano","Sex":"Female","Age":16},
{"Id":1108,"First_name":"Li","Last_name":"Mary","Sex":"Female","Age":36},
{"Id":1109,"First_name":"Vic","Last_name":"Lu","Sex":"male","Age":20}
]*/
ll_row = lnv_restclient.retrieve(dw_1,ls_url)
destroy lnv_restclient
messagebox("Restclient","The rowcount of dw_1 = "+string(ll_row))
 
end event

