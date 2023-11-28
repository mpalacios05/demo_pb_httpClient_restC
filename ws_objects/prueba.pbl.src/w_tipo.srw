$PBExportHeader$w_tipo.srw
forward
global type w_tipo from window
end type
type p_10 from picture within w_tipo
end type
type p_9 from picture within w_tipo
end type
type st_1 from statictext within w_tipo
end type
type st_fecha from statictext within w_tipo
end type
type p_8 from picture within w_tipo
end type
type p_7 from picture within w_tipo
end type
type p_6 from picture within w_tipo
end type
type p_5 from picture within w_tipo
end type
type p_2 from picture within w_tipo
end type
type st_venta_pe from statictext within w_tipo
end type
type st_venta_col from statictext within w_tipo
end type
type st_venta_mx from statictext within w_tipo
end type
type p_3 from picture within w_tipo
end type
type p_1 from picture within w_tipo
end type
type p_4 from picture within w_tipo
end type
type gb_1 from groupbox within w_tipo
end type
end forward

global type w_tipo from window
integer width = 4315
integer height = 1980
boolean titlebar = true
string title = "Tipo de Cambio"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
p_10 p_10
p_9 p_9
st_1 st_1
st_fecha st_fecha
p_8 p_8
p_7 p_7
p_6 p_6
p_5 p_5
p_2 p_2
st_venta_pe st_venta_pe
st_venta_col st_venta_col
st_venta_mx st_venta_mx
p_3 p_3
p_1 p_1
p_4 p_4
gb_1 gb_1
end type
global w_tipo w_tipo

forward prototypes
public function decimal wf_tipo_mex ()
public function decimal wf_tipo_co ()
public function decimal wf_tipo_pe ()
end prototypes

public function decimal wf_tipo_mex ();long ll_return
long ll_row
long ll_fila
string ls_value
string ls_url
string ls_json
decimal ld_tipo_cambio
date ldt_fecha
httpclient lnv_httpclient
jsonpackage lnv_pack1
jsonpackage lnv_pack2
datastore lds_data

lds_data = CREATE datastore
lds_data.DataObject = 'dw_tipo'
lds_data.SetTransObject ( SQLCA )

lnv_pack1 = create jsonpackage
lnv_pack2 = create jsonpackage
lnv_httpclient = create httpclient

If DayNumber ( Today ( ) ) = 2 Then
	ldt_fecha = RelativeDate ( Today ( ), -3 )
Else
	ldt_fecha = RelativeDate ( Today ( ), -1 )
End If
debugbreak()
//Get the JSON string via httpclient
ls_url = "https://sidofqa.segob.gob.mx/dof/sidof/indicadores/" + String ( ldt_fecha, "dd-mm-yyyy" )
ll_return = lnv_httpclient.sendrequest("Get",ls_url)

if ll_return <> 1 then
	messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
//	return 0
end if

lnv_httpclient.getresponsebody( ls_json)


//Load the JSON string via jsonpackage
lnv_pack1.loadstring(ls_json)
//Get the JSON string under key=ListaIndicadores
ls_value = lnv_pack1.getvalue("ListaIndicadores")
//Import JSON data to the DataWindow via importjson
lds_data.importjson(ls_value)

ll_fila = lds_data.Find ( "codtipoindicador = 158", 1, lds_data.RowCount ( ) )
ld_tipo_cambio = Dec ( lds_data.Object.valor [ ll_fila ] )



destroy lnv_pack1
destroy lnv_pack2
destroy lnv_httpclient
return ld_tipo_cambio
end function

public function decimal wf_tipo_co ();long ll_return
long ll_row
long ll_fila
string ls_value
string ls_url
string ls_json
decimal ld_tipo_cambio
httpclient lnv_httpclient
jsonpackage lnv_pack1
jsonpackage lnv_pack2

lnv_pack1 = create jsonpackage
lnv_pack2 = create jsonpackage
lnv_httpclient = create httpclient

//Get the JSON string via httpclient
ls_url = "http://app.docm.co/prod/Dmservices/Utilities.svc/GetTRM"
ll_return = lnv_httpclient.sendrequest("Get",ls_url)

if ll_return <> 1 then
	messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
	return 0
end if

lnv_httpclient.getresponsebody( ls_json)
ld_tipo_cambio = Dec ( Mid ( Mid ( ls_json, Pos ( ls_json, '"' ) + 1 ), 1, Pos ( Mid ( ls_json, Pos ( ls_json, '"' ) + 1 ), '"' ) - 1 ) )

If ld_tipo_cambio <= 0 Then
	destroy lnv_pack1
	destroy lnv_pack2
	destroy lnv_httpclient
	//MessageBox ( "DORA Sistemas", "Error al obtener el tipo de cambio de COP, no se ha modificado", Exclamation! )
	Return 0
End If

destroy lnv_pack1
destroy lnv_pack2
destroy lnv_httpclient

Return ld_tipo_cambio
end function

public function decimal wf_tipo_pe ();long ll_return
long ll_row
long ll_fila
string ls_value
string ls_url
string ls_json
decimal ld_tipo_cambio
httpclient lnv_httpclient
jsonpackage lnv_pack1
jsonpackage lnv_pack2
date ldt_fecha

lnv_pack1 = create jsonpackage
lnv_pack2 = create jsonpackage
lnv_httpclient = create httpclient

If DayNumber ( Today ( ) ) = 2 Then
	ldt_fecha = RelativeDate ( Today ( ), -3 )
Else
	ldt_fecha = RelativeDate ( Today ( ), -1 )
End If

//Get the JSON string via httpclient
ls_url = "https://estadisticas.bcrp.gob.pe/estadisticas/series/api/PD04644PD/xml/"  + String ( ldt_fecha, "yyyy-mm-dd" )
ll_return = lnv_httpclient.sendrequest("Get",ls_url)

if ll_return <> 1 then
	messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
	return 0
end if

lnv_httpclient.getresponsebody( ls_json)
ls_value = Mid ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), 1, Pos ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), '</v>' ) -1 )
ld_tipo_cambio = Dec ( Mid ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), 1, Pos ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), '</v>' ) -1 ) )

If ld_tipo_cambio <= 0 Then
	If DayNumber ( ldt_fecha ) = 2 Then
		ldt_fecha = RelativeDate ( ldt_fecha, -3 )
	Else
		ldt_fecha = RelativeDate ( ldt_fecha, -1 )
	End If
	
	//Get the JSON string via httpclient
	ls_url = "https://estadisticas.bcrp.gob.pe/estadisticas/series/api/PD04644PD/xml/"  + String ( ldt_fecha, "yyyy-mm-dd" )
	ll_return = lnv_httpclient.sendrequest("Get",ls_url)
	
	if ll_return <> 1 then
		messagebox("Failed","SendRequest Failed:"+lnv_httpclient.getresponsestatustext( ))
		return 0
	end if
	
	lnv_httpclient.getresponsebody( ls_json)
	ls_value = Mid ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), 1, Pos ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), '</v>' ) -1 )
	ld_tipo_cambio = Dec ( Mid ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), 1, Pos ( Mid ( ls_json, Pos ( ls_json, '<v>' ) + 3 ), '</v>' ) -1 ) )
End If

If ld_tipo_cambio <= 0 Then
	destroy lnv_pack1
	destroy lnv_pack2
	destroy lnv_httpclient

	Return 0
End If

destroy lnv_pack1
destroy lnv_pack2
destroy lnv_httpclient

Return ld_tipo_cambio
end function

on w_tipo.create
this.p_10=create p_10
this.p_9=create p_9
this.st_1=create st_1
this.st_fecha=create st_fecha
this.p_8=create p_8
this.p_7=create p_7
this.p_6=create p_6
this.p_5=create p_5
this.p_2=create p_2
this.st_venta_pe=create st_venta_pe
this.st_venta_col=create st_venta_col
this.st_venta_mx=create st_venta_mx
this.p_3=create p_3
this.p_1=create p_1
this.p_4=create p_4
this.gb_1=create gb_1
this.Control[]={this.p_10,&
this.p_9,&
this.st_1,&
this.st_fecha,&
this.p_8,&
this.p_7,&
this.p_6,&
this.p_5,&
this.p_2,&
this.st_venta_pe,&
this.st_venta_col,&
this.st_venta_mx,&
this.p_3,&
this.p_1,&
this.p_4,&
this.gb_1}
end on

on w_tipo.destroy
destroy(this.p_10)
destroy(this.p_9)
destroy(this.st_1)
destroy(this.st_fecha)
destroy(this.p_8)
destroy(this.p_7)
destroy(this.p_6)
destroy(this.p_5)
destroy(this.p_2)
destroy(this.st_venta_pe)
destroy(this.st_venta_col)
destroy(this.st_venta_mx)
destroy(this.p_3)
destroy(this.p_1)
destroy(this.p_4)
destroy(this.gb_1)
end on

event open;
st_venta_mx.text = string(wf_tipo_mex())
st_venta_col.text = string(wf_tipo_co())
st_venta_pe.text =  string(wf_tipo_pe())
st_fecha.text = string(today())+" " +string(now())
end event

type p_10 from picture within w_tipo
integer x = 2990
integer y = 1620
integer width = 320
integer height = 228
string picturename = ".\imagenes\computer-icons-download-clip-art-reload-restore-icon.jpg"
boolean focusrectangle = false
end type

event clicked;
st_venta_mx.text = string(wf_tipo_mex())
st_venta_col.text = string(wf_tipo_co())
st_venta_pe.text =  string(wf_tipo_pe())
st_fecha.text = string(today())+" " +string(now())
end event

type p_9 from picture within w_tipo
integer x = 2043
integer y = 748
integer width = 174
integer height = 112
string picturename = ".\imagenes\dolar.png"
boolean focusrectangle = false
end type

type st_1 from statictext within w_tipo
integer x = 1966
integer y = 716
integer width = 165
integer height = 204
integer textsize = -24
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "1 "
boolean focusrectangle = false
end type

type st_fecha from statictext within w_tipo
integer x = 78
integer y = 1688
integer width = 1257
integer height = 164
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type p_8 from picture within w_tipo
integer x = 3890
integer y = 1284
integer width = 219
integer height = 176
string picturename = ".\imagenes\perumon.png"
boolean focusrectangle = false
end type

type p_7 from picture within w_tipo
boolean visible = false
integer x = 2578
integer y = 1284
integer width = 219
integer height = 176
string picturename = ".\imagenes\mex.png"
boolean focusrectangle = false
end type

type p_6 from picture within w_tipo
integer x = 1042
integer y = 1284
integer width = 219
integer height = 176
string picturename = ".\imagenes\mex.png"
boolean focusrectangle = false
end type

type p_5 from picture within w_tipo
integer x = 101
integer y = 4
integer width = 4087
integer height = 720
string picturename = ".\imagenes\imagesQ3DKS7XK.jpg"
boolean focusrectangle = false
end type

type p_2 from picture within w_tipo
integer x = 3442
integer y = 1608
integer width = 731
integer height = 248
string picturename = ".\imagenes\LOGO DORA.png"
boolean focusrectangle = false
end type

type st_venta_pe from statictext within w_tipo
integer x = 3067
integer y = 1240
integer width = 1093
integer height = 352
integer textsize = -36
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "0.00"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_venta_col from statictext within w_tipo
integer x = 1577
integer y = 1240
integer width = 1093
integer height = 352
integer textsize = -36
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "0.00"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_venta_mx from statictext within w_tipo
integer x = 192
integer y = 1260
integer width = 1093
integer height = 352
integer textsize = -36
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "0.00"
boolean focusrectangle = false
end type

type p_3 from picture within w_tipo
integer x = 425
integer y = 980
integer width = 398
integer height = 196
string picturename = ".\imagenes\istockphoto-537287305-612x612.jpg"
boolean focusrectangle = false
end type

type p_1 from picture within w_tipo
integer x = 1902
integer y = 984
integer width = 398
integer height = 196
string picturename = ".\imagenes\kindpng_4934520.png"
boolean focusrectangle = false
end type

type p_4 from picture within w_tipo
integer x = 3438
integer y = 968
integer width = 398
integer height = 196
string picturename = ".\imagenes\peru.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_tipo
integer x = 64
integer y = 848
integer width = 4101
integer height = 728
integer taborder = 10
integer textsize = -24
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
end type

