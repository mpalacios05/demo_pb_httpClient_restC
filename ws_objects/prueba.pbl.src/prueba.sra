$PBExportHeader$prueba.sra
$PBExportComments$Generated Application Object
forward
global type prueba from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
 


end variables

global type prueba from application
string appname = "prueba"
string displayname = "Pruebas"
string themepath = "C:\Users\mpalacios\Desktop\pb 2019 example\theme190"
string themename = "Flat Design Blue"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "22.0.0.1900"
boolean manualsession = false
boolean unsupportedapierror = false
boolean bignoreservercertificate = false
uint ignoreservercertificate = 0
end type
global prueba prueba

type variables
Datetime          			idt_fecha_hoy
end variables

on prueba.create
appname="prueba"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on prueba.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;

Open(w_tipo) //RibbonBar
end event

