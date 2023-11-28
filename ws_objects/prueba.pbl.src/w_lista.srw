$PBExportHeader$w_lista.srw
forward
global type w_lista from window
end type
type dw_1 from datawindow within w_lista
end type
end forward

global type w_lista from window
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
dw_1 dw_1
end type
global w_lista w_lista

on w_lista.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_lista.destroy
destroy(this.dw_1)
end on

type dw_1 from datawindow within w_lista
integer x = 338
integer y = 360
integer width = 933
integer height = 156
integer taborder = 10
string title = "none"
string dataobject = "d_lista"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

