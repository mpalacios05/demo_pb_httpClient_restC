$PBExportHeader$w_principal.srw
forward
global type w_principal from window
end type
type dw_lista from datawindow within w_principal
end type
type cb_2 from commandbutton within w_principal
end type
type cb_4 from commandbutton within w_principal
end type
type cb_3 from commandbutton within w_principal
end type
type cb_1 from commandbutton within w_principal
end type
end forward

global type w_principal from window
integer width = 2043
integer height = 1212
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_lista dw_lista
cb_2 cb_2
cb_4 cb_4
cb_3 cb_3
cb_1 cb_1
end type
global w_principal w_principal

on w_principal.create
this.dw_lista=create dw_lista
this.cb_2=create cb_2
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_1=create cb_1
this.Control[]={this.dw_lista,&
this.cb_2,&
this.cb_4,&
this.cb_3,&
this.cb_1}
end on

on w_principal.destroy
destroy(this.dw_lista)
destroy(this.cb_2)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_1)
end on

type dw_lista from datawindow within w_principal
boolean visible = false
integer x = 1166
integer width = 2944
integer height = 764
integer taborder = 40
string title = "none"
string dataobject = "d_lista_logo"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.settransobject(sqlca)
end event

type cb_2 from commandbutton within w_principal
integer x = 187
integer y = 104
integer width = 539
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "PDF"
end type

event clicked;dw_lista.Object.DataWindow.Export.PDF.NativePDF.UsePrintSpec = 'Yes'
dw_lista.Object.DataWindow.Export.PDF.Method = NativePDF!
dw_lista.Object.DataWindow.Export.PDF.NativePDF.PDFStandard = 1 //PDF/A-1a
dw_lista.Object.DataWindow.Print.Orientation = 1 //Landscape!
dw_lista.Object.DataWindow.Print.Paper.Size = 1 //1 – Letter 8 1/2 x 11 in

dw_lista.SaveAs ('', PDF!, true )

end event

type cb_4 from commandbutton within w_principal
integer x = 201
integer y = 764
integer width = 571
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "RIBOON"
end type

event clicked;open(w_leaflet)
end event

type cb_3 from commandbutton within w_principal
integer x = 183
integer y = 556
integer width = 603
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "API TIPO DE CAMBIO"
end type

event clicked;open(w_tipo)
end event

type cb_1 from commandbutton within w_principal
integer x = 178
integer y = 348
integer width = 544
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "JSON - MAIL"
end type

event clicked;open(w_rest)


end event

