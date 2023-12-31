$PBExportHeader$w_logo.srw
$PBExportComments$Mantenimiento a la Tabla Sector
forward
global type w_logo from w_gen_mant_me
end type
type ole_1 from olecontrol within w_logo
end type
type dw_1 from datawindow within w_logo
end type
type gb_1 from groupbox within w_logo
end type
type gb_3 from groupbox within w_logo
end type
type gb_4 from groupbox within w_logo
end type
type gb_2 from groupbox within w_logo
end type
type wstr_datos from structure within w_logo
end type
end forward

type wstr_datos from structure
	long		id_logo
	long		identificador
	string		tipo
	blob		logo
end type

global type w_logo from w_gen_mant_me
integer width = 4411
integer height = 2324
string title = "Mantenimiento de Logo"
string menuname = "m_logo"
ole_1 ole_1
dw_1 dw_1
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
gb_2 gb_2
end type
global w_logo w_logo

type variables
datawindowchild dwc_identificador

Long ii_renglon

private:
wstr_datos istr_datos

end variables

forward prototypes
public function boolean wf_valida_datos ()
public subroutine wf_agrega_logo ()
end prototypes

public function boolean wf_valida_datos ();dw_registro.AcceptText()

istr_datos.id_logo         	= dw_registro.GetItemNumber(1,"id_logo")
istr_datos.identificador   	= dw_registro.GetItemNumber(1,"identificador")
istr_datos.tipo   			= dw_registro.GetItemString(1,"tipo")

if IsNull(istr_datos.identificador) or  istr_datos.identificador=0 and istr_datos.tipo='C' then
	dw_registro.SetColumn("identificador")
	dw_registro.SetFocus()
	messagebox("Aviso","Se tiene que elgir un contrato",Exclamation!)
	Return FALSE	
ElseIf IsNull(istr_datos.identificador) or  istr_datos.identificador=0 and istr_datos.tipo='M' then
	dw_registro.SetColumn("identificador")
	dw_registro.SetFocus()
	messagebox("Aviso","Se tiene que elgir una cuenta unica",Exclamation!)
	Return FALSE
	
ElseIf IsNull(istr_datos.identificador) or  istr_datos.identificador=0 and istr_datos.tipo='F' then
	dw_registro.SetColumn("identificador")
	dw_registro.SetFocus()
	messagebox("Aviso","Se tiene que elgir una Familia",Exclamation!)
	Return FALSE
	
else
	RETURN TRUE
end if
end function

public subroutine wf_agrega_logo ();blob lb_logo
string ls_fecha
datetime ldtt_fecha_hoy

lb_logo = ole_1.objectdata

istr_datos.logo = lb_logo

end subroutine

event open;/*******************************************************************
w_logo								Copyright (c)	   15/mayo/2000

PROYECTO: Sistema Integral de Administración de Portafolios

RESPONSABLE(S):	Ma. del Carmen Montero Ponce

DESCRIPCIÓN: Ventana para el Mantenimiento de Logo

OBSERVACIONES: 
*******************************************************************/
STRING ls_nombre
LONG li_ancho_orig
//Para consulta historicos
gi_cierra = 0

li_ancho_orig = w_logo.Width

//CODIGO HEREDADO
this.x= 2
this.y = 2
uo_men.of_centra_mensaje(this)
wf_menu_lista()
wf_valida_menu()
PostEvent("ue_retrieve")
f_crea_tags(this.menuid,"Logo")

w_logo.Width = li_ancho_orig

//seguridad, permisos
wf_perfil_usuario("w_logo")

IF gb_solo_consulta THEN
	ole_1.enabled = false
END IF

dw_1.settransobject(SQLCA)
dw_1.retrieve()
end event

event ue_valida_guardar;ib_permite_guardar = wf_valida_datos()

if ib_permite_guardar Then
	dw_registro.SetTabOrder("id_logo",0)
	dw_registro.Object.tipo.Protect 	= 1
	dw_registro.Object.identificador.Protect 	= 1
end if
end event

event ue_cancelar;call super::ue_cancelar;
dw_registro.SetTabOrder("id_logo",0)
dw_registro.Object.identificador.Protect 		= 1

end event

event ue_insertar;call super::ue_insertar;LONG	ll_child

ole_1.clear()
dw_registro.SetItem(1,"tipo",'C')
dw_registro.SetItem(1,"identificador",0)

dwc_identificador.SetTransObject(sqlca) 
dwc_identificador.retrieve('C', 0) 	

dw_registro.Object.tipo.Protect = 0
dw_registro.Object.identificador.Protect = 0


end event

on w_logo.create
int iCurrent
call super::create
if this.MenuName = "m_logo" then this.MenuID = create m_logo
this.ole_1=create ole_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ole_1
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.gb_1
this.Control[iCurrent+4]=this.gb_3
this.Control[iCurrent+5]=this.gb_4
this.Control[iCurrent+6]=this.gb_2
end on

on w_logo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ole_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_2)
end on

event ue_guardar;String ls_error, ls_accion


ib_permite_guardar = false
This.TriggerEvent("ue_valida_guardar")
if ib_permite_guardar then
	wf_menu_lista()
	wf_campos_editar(dw_registro)
	dw_lista.enabled = true
end if
SetPointer(HourGlass!)


	SetPointer(HourGlass!)
	if ib_permite_guardar then
//CMP				uo_men.of_mensaje("EPR009")
		/* Si se va a insertar*/
		if ib_permite_insertar then
			ls_error='EDB002'
			ls_accion='EPR006'
			dw_registro.Dynamic Event ue_insertar(10,10)				
		elseif ib_permite_modificar then /* Si se se esta actualizando*/
			ls_error='EDB004'
			ls_accion='EPR007'
			dw_registro.Dynamic Event ue_actualizar(10,10)				
		end if
	
		if sqlca.sqlcode <> 0  then
				/* Hubo un error*/
				ib_permite_cerrar=FALSE
				messagebox("Error","Existió un error al momento de insertar el registro")
				TriggerEvent("ue_cancelar")
		else
			ib_permite_cerrar=TRUE
//			if ls_accion ='EPR006' then // Insertando
//				/* Se inserta un renglon en la lista, y se selecciona*/
//				dw_registro.Dynamic Event ue_inserta_en_lista(10,10)									
//			elseif ls_accion='EPR007' then
//				dw_registro.Dynamic Event ue_actualiza_descripcion(10,10)				
//			end if
			
				dw_lista.SetFocus()
				dw_registro.ResetUpdate()
		end if
		uo_men.of_cierra_mensaje()			
		ib_permite_guardar=FALSE
		ib_permite_modificar=FALSE
		ib_permite_insertar=FALSE	
	end if


end event

type st_buttonface from w_gen_mant_me`st_buttonface within w_logo
integer x = 2834
integer y = 44
integer width = 78
integer height = 132
end type

type uo_men from w_gen_mant_me`uo_men within w_logo
integer x = 2848
integer y = 212
integer width = 73
integer height = 224
end type

type st_backcolor from w_gen_mant_me`st_backcolor within w_logo
integer x = 2857
integer y = 472
integer width = 69
integer height = 112
end type

type dw_registro from w_gen_mant_me`dw_registro within w_logo
integer x = 82
integer y = 1484
integer width = 1920
integer height = 600
string dataobject = "d_detalle_logo"
end type

event dw_registro::editchanged;call super::editchanged;ib_permite_modificar = TRUE
end event

event dw_registro::itemchanged;call super::itemchanged;STRING	ls_tipo
LONG	ll_identificador 

ib_permite_modificar = TRUE

IF dwo.name = 'tipo' THEN
	ls_tipo = string(data)
	
	ll_identificador = dw_registro.GetItemNumber ( 1,"identificador")
	
	GetChild("identificador", dwc_identificador)
	dwc_identificador.SetTransObject(sqlca) 
	dwc_identificador.retrieve(ls_tipo,ll_identificador) 		
	
//	dw_registro.SetItem(1,"identificador",0)
	
eND IF
end event

event dw_registro::itemerror;RETURN 1
end event

event dw_registro::ue_actualiza_descripcion;
string ls_tipo, ls_nombre
ls_tipo = dw_registro.GetItemString(1,"tipo")


dw_lista.SetItem(dw_lista.GetSelectedRow(0),1,istr_datos.id_logo)
dw_lista.SetItem(dw_lista.GetSelectedRow(0),2,istr_datos.identificador)


IF ls_tipo = 'C' then
	SELECT nombre_corto
	INTO :ls_nombre
	FROM contrato
	WHERE id_cliente =:istr_datos.identificador;
ELSEIF  ls_tipo = 'M' then
		SELECT alias_cdm
		INTO :ls_nombre
		FROM cuenta_unica_cliente
		WHERE id_cdm =:istr_datos.identificador;
ELSEIF  ls_tipo = 'F' then
	SELECT nombre_fam
	INTO :ls_nombre
	FROM tipo_Familia
	WHERE id_tipo_familia =:istr_datos.identificador;
END IF

dw_lista.SetItem(dw_lista.GetSelectedRow(0),3,ls_nombre)




dw_lista.retrieve()

end event

event dw_registro::ue_actualizar;string ls_tipo
//messagebox("istr_datos.tipo",istr_datos.tipo)
////ls_tipo = dw_lista.GetItemString(lparam,"tipo")
//ls_tipo = dw_registro.GetItemString(lparam,"tipo")
//
//istr_datos.tipo = istr_datos.tipo

sqlca.spm_logo(istr_datos.id_logo,&
					  istr_datos.identificador,&
                 istr_datos.tipo,&
					  3)
					  
IF sqlca.sqldbcode <> 0 THEN
	MESSAGEBOX("ERROR EN INSERTAR",SQLCA.SQLERRTEXT)
else				
	if not isnull(istr_datos.logo) then
		updateblob LOGO 
		set LOGO= :istr_datos.logo
		where id_logo = :istr_datos.id_logo;
	end if

	if SQLCA.SQLCode = -1 then	
		MessageBox("Aviso",SQLCA.SQLErrText,Information!)
	Else
		MessageBox("Aviso","Datos actualizados correctamente.",Information!)
	End if
end if
dw_lista.retrieve()
dw_lista.groupcalc()
dw_lista.setsort("grupo, nombre") 
dw_lista.sort()

end event

event dw_registro::ue_insertar;Double ii_max_logo

//Inserta el valor a la dw de dw_talle
sqlca.sps_max_logo(ref ii_max_logo)
dw_registro.SetItem(1,"id_logo",ii_max_logo)
istr_datos.id_logo = ii_max_logo

sqlca.spm_logo  (	istr_datos.id_logo,&
						istr_datos.identificador,&
						istr_datos.tipo,&
						1	)

IF sqlca.sqldbcode <> 0 THEN
	MESSAGEBOX("ERROR EN INSERTAR",SQLCA.SQLERRTEXT)
else
	istr_datos.id_logo = dw_registro.GetItemNumber(1,'id_logo')	

	if not isnull(istr_datos.logo) then
		updateblob LOGO 
		set LOGO= :istr_datos.logo
		where id_logo = :istr_datos.id_logo;
	end if

	IF SQLCA.SQLCode = -1 then	
		MessageBox("Aviso",SQLCA.SQLErrText,Information!)
	ELSE
			MessageBox("Aviso","Datos almacenados correctamente.",Information!) 
	END IF
END IF 	
dw_lista.setredraw(false)
dw_lista.retrieve()
dw_lista.groupcalc()
dw_lista.groupcalc()
dw_lista.setsort("grupo as, nombre as") 
dw_lista.sort()

dw_lista.setredraw(true)

end event

event dw_registro::ue_borrar;Long li_logo, ll_nulo
setnull(ll_nulo)
li_logo = dw_lista.GetItemNumber(lparam,"id_logo")


sqlca.spm_logo(li_logo,&
					  ll_nulo,&
                 "",&
					  2)

IF sqlca.sqldbcode <> 0 THEN
	MESSAGEBOX("Aviso",SQLCA.SQLERRTEXT) 
END IF


dw_lista.retrieve()
dw_lista.groupcalc()

dw_lista.setsort("grupo, nombre") 
dw_lista.sort()

end event

event dw_registro::ue_inserta_en_lista;Long ll_renglon
String ls_tipo,ls_nombre
/*****************************************************
Inserta en la DataWindow Lista los valores que fueron 
Capturados en la DataWindow registro.
*****************************************************/
ls_tipo = dw_registro.GetItemString(1,"tipo")


IF ls_tipo = 'C' then
	SELECT nombre_corto
		INTO :ls_nombre
		FROM contrato
		where id_cliente =:istr_datos.identificador;
ELSEIF  ls_tipo = 'M' then

		SELECT alias_cdm
		INTO :ls_nombre
		FROM cuenta_unica_cliente
		where id_cdm =:istr_datos.identificador;
ELSEIF  ls_tipo = 'F' then
		SELECT nombre_fam
		INTO :ls_nombre
		FROM tipo_Familia
		where id_tipo_familia =:istr_datos.identificador;
END IF


ll_renglon= wf_insertarenglon(0)
dw_lista.SetItem(ll_renglon,1,istr_datos.id_logo)
dw_lista.SetItem(ll_renglon,2,istr_datos.identificador)
dw_lista.SetItem(ll_renglon,3,ls_nombre)
dw_lista.SetItem(ll_renglon,4,istr_datos.tipo)

wf_selecciona_renglon(ll_renglon)
end event

event dw_registro::ue_traer;LONG 	ll_logo, ll_identificador
BLOB		ole_blob
STRING	ls_tipo

if lparam > 0 then
	
	ll_logo 			= dw_lista.GetItemNumber(lparam,"id_logo")
	ls_tipo			= dw_lista.GetItemString(lparam,"tipo")
	ll_identificador	= dw_lista.GetItemNumber(lparam,"identificador")
	
	GetChild("identificador", dwc_identificador)
	dwc_identificador.SetTransObject(sqlca) 
	dwc_identificador.retrieve(ls_tipo, ll_identificador) 		
	
	dw_registro.Retrieve ( ll_logo )
	
	selectblob LOGO  into :ole_blob 
	from LOGO
	where ID_LOGO = :ll_logo ;	
	
	ole_1.objectdata = ole_blob		
	
//else
//	ole_1.Visible = False
end if
end event

type dw_lista from w_gen_mant_me`dw_lista within w_logo
integer x = 73
integer y = 100
integer width = 2949
integer height = 1188
string dataobject = "d_lista_logo"
end type

event dw_lista::itemchanged;//if row > 0 then
//	ii_renglon= row
//end if

end event

type ole_1 from olecontrol within w_logo
integer x = 2057
integer y = 1488
integer width = 955
integer height = 600
integer taborder = 40
boolean bringtotop = true
borderstyle borderstyle = stylelowered!
long backcolor = 16777215
boolean focusrectangle = false
string binarykey = "w_logo.win"
omactivation activation = activateondoubleclick!
omdisplaytype displaytype = displayascontent!
omcontentsallowed contentsallowed = containsany!
end type

event doubleclicked;String ls_ruta, ls_file
Integer li_id_logo, li_existe_reg

//VALIDO ACCION A REALIZAR INSERT O ACTUALIZAR

li_id_logo = dw_registro.object.id_logo[dw_registro.getrow()]

SELECT count(*)
INTO: li_existe_reg
FROM LOGO
WHERE ID_LOGO = :li_id_logo;



IF li_existe_reg >= 0 THEN
	ib_permite_modificar = TRUE  
ELSE
	ib_permite_insertar = TRUE  
END IF 

wf_menu_detalle()

GetFileOpenName("Seleccione archivo",ls_ruta,ls_file)


If ls_file ="" Then return

If ole_1.insertfile(ls_ruta) = 0 Then	
	wf_agrega_logo()
End If
end event

type dw_1 from datawindow within w_logo
integer x = 3182
integer y = 148
integer width = 1134
integer height = 1320
integer taborder = 30
boolean bringtotop = true
string title = "none"
string dataobject = "d_testim"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_logo
integer x = 5
integer y = 28
integer width = 3067
integer height = 1324
integer taborder = 12
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type gb_3 from groupbox within w_logo
integer x = 2030
integer y = 1416
integer width = 1019
integer height = 704
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Logo"
end type

type gb_4 from groupbox within w_logo
integer x = 2021
integer y = 1428
integer width = 480
integer height = 400
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "none"
end type

type gb_2 from groupbox within w_logo
integer x = 5
integer y = 1372
integer width = 3067
integer height = 768
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Ew_logo.bin 
2B00000600e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe00000006000000000000000000000001000000010000000000001000fffffffe00000000fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Ew_logo.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
